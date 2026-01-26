#!/bin/bash
#
# linear-sync.sh - Bidirectional sync between local specs/tasks and Linear
#
# Usage:
#   ./linear-sync.sh push [spec-file]     Push local → Linear
#   ./linear-sync.sh pull [issue-id]      Pull Linear → local
#   ./linear-sync.sh sync                 Bidirectional sync
#   ./linear-sync.sh link <spec> <issue>  Link spec to existing issue
#   ./linear-sync.sh status               Show sync status
#
# Requires:
#   - linearis CLI (npm install -g linearis)
#   - LINEAR_API_TOKEN environment variable
#   - jq for JSON parsing
#   - yq for YAML frontmatter (optional, falls back to grep)

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config defaults
CONFIG_FILE=".linear-sync.json"
SPEC_DIR="context/specs"
TASK_DIR="context/tasks"
DEFAULT_TEAM=""
TASK_MAPPING="sub-issues"  # or "checklist"

# Load config if exists
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        SPEC_DIR=$(jq -r '.specDir // "context/specs"' "$CONFIG_FILE")
        TASK_DIR=$(jq -r '.taskDir // "context/tasks"' "$CONFIG_FILE")
        DEFAULT_TEAM=$(jq -r '.team // ""' "$CONFIG_FILE")
        TASK_MAPPING=$(jq -r '.taskMapping // "sub-issues"' "$CONFIG_FILE")
    fi
    
    # Auto-detect team from directory if not set in config
    if [[ -z "$DEFAULT_TEAM" ]]; then
        DEFAULT_TEAM=$(detect_team_from_dir)
    fi
}

# Auto-detect Linear team from current directory name
detect_team_from_dir() {
    local dir=$(basename "$(pwd)")
    
    # Check for known project patterns
    case "$dir" in
        loadhealth-*|load-*)   echo "Load" ;;
        flexpay-*)             echo "FlexPay" ;;
        pelian-*|pelian)       echo "Pelian" ;;
        *)
            # Try parent directory if current doesn't match
            local parent=$(basename "$(dirname "$(pwd)")")
            case "$parent" in
                loadhealth-*|load-*)   echo "Load" ;;
                flexpay-*)             echo "FlexPay" ;;
                pelian-*|pelian)       echo "Pelian" ;;
                *)                     echo "" ;;
            esac
            ;;
    esac
}

# Check dependencies
check_deps() {
    if ! command -v linearis &> /dev/null; then
        echo -e "${RED}Error: linearis not found. Install with: npm install -g linearis${NC}"
        exit 1
    fi
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}Error: jq not found. Install with: sudo pacman -S jq${NC}"
        exit 1
    fi
    if [[ -z "$LINEAR_API_TOKEN" ]]; then
        echo -e "${RED}Error: LINEAR_API_TOKEN not set${NC}"
        exit 1
    fi
}

# Extract frontmatter value from markdown file
get_frontmatter() {
    local file="$1"
    local key="$2"
    
    # Try to extract from YAML frontmatter between ---
    awk '/^---$/{p=!p; next} p' "$file" | grep "^${key}:" | head -1 | sed "s/^${key}:[[:space:]]*//"
}

# Extract nested frontmatter value (e.g., linear.issue)
get_nested_frontmatter() {
    local file="$1"
    local parent="$2"
    local key="$3"
    
    awk '/^---$/{p=!p; next} p' "$file" | \
        awk "/^${parent}:$/,/^[a-z]/" | \
        grep "^[[:space:]]*${key}:" | \
        head -1 | \
        sed "s/^[[:space:]]*${key}:[[:space:]]*//"
}

# Update frontmatter in markdown file
update_frontmatter() {
    local file="$1"
    local key="$2"
    local value="$3"
    
    # Simple replacement - works for top-level keys
    if grep -q "^${key}:" "$file"; then
        sed -i "s/^${key}:.*/${key}: ${value}/" "$file"
    else
        # Add before closing ---
        sed -i "/^---$/,/^---$/ { /^---$/ { x; /^$/! { x; b }; x; i\\${key}: ${value}
        } }" "$file"
    fi
}

# Update nested frontmatter (linear.issue, linear.synced_at, etc.)
update_nested_frontmatter() {
    local file="$1"
    local parent="$2"
    local key="$3"
    local value="$4"
    
    # Check if parent section exists
    if grep -q "^${parent}:$" "$file"; then
        # Check if key exists under parent
        if awk "/^${parent}:$/,/^[a-z]/" "$file" | grep -q "^[[:space:]]*${key}:"; then
            # Update existing
            sed -i "/^${parent}:$/,/^[a-z]/ s/^\([[:space:]]*\)${key}:.*/\1${key}: ${value}/" "$file"
        else
            # Add new key under parent
            sed -i "/^${parent}:$/a\\  ${key}: ${value}" "$file"
        fi
    else
        # Add parent section before closing ---
        sed -i "/^---$/,/^---$/ { /^---$/ { x; /^$/! { x; b }; x; i\\${parent}:\\
  ${key}: ${value}
        } }" "$file"
    fi
}

# Extract spec body (everything after frontmatter)
get_spec_body() {
    local file="$1"
    awk '/^---$/{p++; next} p>=2' "$file"
}

# Get spec title from frontmatter or first heading
get_spec_title() {
    local file="$1"
    local title=$(get_frontmatter "$file" "title")
    if [[ -z "$title" ]]; then
        title=$(grep "^# " "$file" | head -1 | sed 's/^# //')
    fi
    echo "$title"
}

# Map local status to Linear state
map_status_to_linear() {
    local status="$1"
    case "$status" in
        todo)        echo "Todo" ;;
        in-progress) echo "In Progress" ;;
        done)        echo "Done" ;;
        blocked)     echo "Todo" ;;  # Linear doesn't have blocked, use Todo + label
        *)           echo "Backlog" ;;
    esac
}

# Map Linear state to local status
map_linear_to_status() {
    local state="$1"
    case "$state" in
        "Backlog")     echo "todo" ;;
        "Todo")        echo "todo" ;;
        "In Progress") echo "in-progress" ;;
        "Done")        echo "done" ;;
        "Canceled")    echo "done" ;;
        *)             echo "todo" ;;
    esac
}

# Push single spec to Linear
push_spec() {
    local spec_file="$1"
    local force="${2:-false}"
    
    if [[ ! -f "$spec_file" ]]; then
        echo -e "${RED}Error: Spec file not found: $spec_file${NC}"
        return 1
    fi
    
    local title=$(get_spec_title "$spec_file")
    local body=$(get_spec_body "$spec_file")
    local issue_id=$(get_nested_frontmatter "$spec_file" "linear" "issue")
    local team=$(get_nested_frontmatter "$spec_file" "linear" "team")
    
    # Use default team if not specified
    if [[ -z "$team" ]]; then
        team="$DEFAULT_TEAM"
    fi
    
    if [[ -z "$team" ]]; then
        echo -e "${RED}Error: No team specified. Set in frontmatter or .linear-sync.json${NC}"
        return 1
    fi
    
    # Get team key for linearis
    local team_key=$(linearis teams list 2>/dev/null | jq -r ".[] | select(.name == \"$team\") | .key")
    if [[ -z "$team_key" ]]; then
        team_key="$team"  # Assume it's already the key
    fi
    
    if [[ -z "$issue_id" ]]; then
        # Create new issue
        echo -e "${BLUE}Creating Linear issue for: $title${NC}"
        
        local result=$(linearis issues create "$title" --team "$team_key" --description "$body" 2>/dev/null)
        issue_id=$(echo "$result" | jq -r '.identifier')
        
        if [[ -n "$issue_id" && "$issue_id" != "null" ]]; then
            # Update frontmatter with issue ID
            update_nested_frontmatter "$spec_file" "linear" "issue" "$issue_id"
            update_nested_frontmatter "$spec_file" "linear" "synced_at" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
            echo -e "${GREEN}✓ Created $issue_id${NC}"
        else
            echo -e "${RED}Failed to create issue${NC}"
            return 1
        fi
    else
        # Update existing issue
        echo -e "${BLUE}Updating Linear issue: $issue_id${NC}"
        
        linearis issues update "$issue_id" --title "$title" --description "$body" 2>/dev/null
        update_nested_frontmatter "$spec_file" "linear" "synced_at" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
        echo -e "${GREEN}✓ Updated $issue_id${NC}"
    fi
}

# Pull Linear issue to local spec
pull_issue() {
    local issue_id="$1"
    local spec_file="$2"
    
    echo -e "${BLUE}Pulling Linear issue: $issue_id${NC}"
    
    local issue=$(linearis issues read "$issue_id" 2>/dev/null)
    
    if [[ -z "$issue" ]]; then
        echo -e "${RED}Error: Issue not found: $issue_id${NC}"
        return 1
    fi
    
    local state=$(echo "$issue" | jq -r '.state.name')
    local local_status=$(map_linear_to_status "$state")
    
    if [[ -n "$spec_file" && -f "$spec_file" ]]; then
        update_nested_frontmatter "$spec_file" "linear" "state" "$state"
        update_nested_frontmatter "$spec_file" "linear" "synced_at" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
        echo -e "${GREEN}✓ Updated local spec with state: $state${NC}"
    else
        echo "$issue" | jq '.'
    fi
}

# Full bidirectional sync
do_sync() {
    local force_mode="${1:-}"
    
    echo -e "${BLUE}Starting bidirectional sync...${NC}"
    
    # Find all specs with Linear metadata
    for spec_file in "$SPEC_DIR"/*.md; do
        [[ -f "$spec_file" ]] || continue
        
        local issue_id=$(get_nested_frontmatter "$spec_file" "linear" "issue")
        local synced_at=$(get_nested_frontmatter "$spec_file" "linear" "synced_at")
        local spec_name=$(basename "$spec_file")
        
        if [[ -z "$issue_id" ]]; then
            echo -e "${YELLOW}⚠ $spec_name: No Linear issue linked (use push to create)${NC}"
            continue
        fi
        
        # Get file modification time
        local file_mtime=$(stat -c %Y "$spec_file" 2>/dev/null || stat -f %m "$spec_file")
        local synced_epoch=0
        if [[ -n "$synced_at" ]]; then
            synced_epoch=$(date -d "$synced_at" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$synced_at" +%s 2>/dev/null || echo 0)
        fi
        
        # Get Linear issue updated time
        local issue=$(linearis issues read "$issue_id" 2>/dev/null)
        local linear_updated=$(echo "$issue" | jq -r '.updatedAt')
        local linear_epoch=$(date -d "$linear_updated" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$linear_updated" +%s 2>/dev/null || echo 0)
        
        local local_newer=false
        local remote_newer=false
        
        [[ $file_mtime -gt $synced_epoch ]] && local_newer=true
        [[ $linear_epoch -gt $synced_epoch ]] && remote_newer=true
        
        if $local_newer && $remote_newer; then
            # Conflict
            if [[ "$force_mode" == "--force-local" ]]; then
                echo -e "${YELLOW}⚠ $spec_name: Conflict - forcing local${NC}"
                push_spec "$spec_file"
            elif [[ "$force_mode" == "--force-remote" ]]; then
                echo -e "${YELLOW}⚠ $spec_name: Conflict - forcing remote${NC}"
                pull_issue "$issue_id" "$spec_file"
            else
                echo -e "${RED}✗ $spec_name: Conflict (both modified). Use --force-local or --force-remote${NC}"
            fi
        elif $local_newer; then
            echo -e "${BLUE}↑ $spec_name: Local newer, pushing...${NC}"
            push_spec "$spec_file"
        elif $remote_newer; then
            echo -e "${BLUE}↓ $spec_name: Remote newer, pulling...${NC}"
            pull_issue "$issue_id" "$spec_file"
        else
            echo -e "${GREEN}✓ $spec_name: In sync${NC}"
        fi
    done
    
    echo -e "${GREEN}Sync complete${NC}"
}

# Link spec to existing Linear issue
link_spec() {
    local spec_file="$1"
    local issue_id="$2"
    
    if [[ ! -f "$spec_file" ]]; then
        echo -e "${RED}Error: Spec file not found: $spec_file${NC}"
        return 1
    fi
    
    # Verify issue exists
    local issue=$(linearis issues read "$issue_id" 2>/dev/null)
    if [[ -z "$issue" ]]; then
        echo -e "${RED}Error: Issue not found: $issue_id${NC}"
        return 1
    fi
    
    local team=$(echo "$issue" | jq -r '.team.name')
    local state=$(echo "$issue" | jq -r '.state.name')
    
    update_nested_frontmatter "$spec_file" "linear" "issue" "$issue_id"
    update_nested_frontmatter "$spec_file" "linear" "team" "$team"
    update_nested_frontmatter "$spec_file" "linear" "state" "$state"
    update_nested_frontmatter "$spec_file" "linear" "synced_at" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    
    echo -e "${GREEN}✓ Linked $spec_file to $issue_id ($team)${NC}"
}

# Show sync status
show_status() {
    echo -e "${BLUE}Linear Sync Status${NC}"
    echo "─────────────────────────────────────────"
    
    for spec_file in "$SPEC_DIR"/*.md; do
        [[ -f "$spec_file" ]] || continue
        
        local spec_name=$(basename "$spec_file")
        local issue_id=$(get_nested_frontmatter "$spec_file" "linear" "issue")
        local synced_at=$(get_nested_frontmatter "$spec_file" "linear" "synced_at")
        local state=$(get_nested_frontmatter "$spec_file" "linear" "state")
        
        if [[ -z "$issue_id" ]]; then
            echo -e "${YELLOW}○ $spec_name${NC} - not linked"
        else
            echo -e "${GREEN}● $spec_name${NC} → $issue_id [$state] (synced: ${synced_at:-never})"
        fi
    done
}

# Main
main() {
    load_config
    check_deps
    
    local action="${1:-status}"
    shift || true
    
    case "$action" in
        push)
            if [[ -n "$1" ]]; then
                push_spec "$1"
            else
                # Push all specs
                for spec_file in "$SPEC_DIR"/*.md; do
                    [[ -f "$spec_file" ]] || continue
                    push_spec "$spec_file"
                done
            fi
            ;;
        pull)
            if [[ -n "$1" ]]; then
                # Find spec linked to this issue
                local spec_file=$(grep -l "issue: $1" "$SPEC_DIR"/*.md 2>/dev/null | head -1)
                pull_issue "$1" "$spec_file"
            else
                # Pull all linked issues
                for spec_file in "$SPEC_DIR"/*.md; do
                    [[ -f "$spec_file" ]] || continue
                    local issue_id=$(get_nested_frontmatter "$spec_file" "linear" "issue")
                    [[ -n "$issue_id" ]] && pull_issue "$issue_id" "$spec_file"
                done
            fi
            ;;
        sync)
            do_sync "$1"
            ;;
        link)
            if [[ -z "$1" || -z "$2" ]]; then
                echo "Usage: $0 link <spec-file> <issue-id>"
                exit 1
            fi
            link_spec "$1" "$2"
            ;;
        status)
            show_status
            ;;
        *)
            echo "Usage: $0 {push|pull|sync|link|status}"
            echo ""
            echo "Commands:"
            echo "  push [spec-file]     Push local specs to Linear"
            echo "  pull [issue-id]      Pull Linear issues to local"
            echo "  sync [--force-*]     Bidirectional sync"
            echo "  link <spec> <issue>  Link spec to existing issue"
            echo "  status               Show sync status"
            exit 1
            ;;
    esac
}

main "$@"
