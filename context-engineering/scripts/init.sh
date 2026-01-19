#!/bin/sh
# Context Engineering - Init Script
# Creates context/ directory structure in current project
#
# Portability: POSIX-compliant, tested on Linux. Uses only:
#   mkdir, touch, echo, cd, dirname, cp
# Should work on macOS, Ubuntu, Git Bash (Windows)
#
# Usage:
#   ./init.sh              # minimal structure
#   ./init.sh --with-examples  # include example files

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
EXAMPLES_DIR="$SKILL_DIR/assets/examples"

# Create directories
mkdir -p context/foundation
mkdir -p context/specs
mkdir -p context/tasks

# Add .gitkeep files
touch context/foundation/.gitkeep
touch context/specs/.gitkeep
touch context/tasks/.gitkeep

echo "✓ Created context/ structure:"
echo "  context/"
echo "  ├── foundation/"
echo "  ├── specs/"
echo "  └── tasks/"

# Handle --with-examples flag
if [ "$1" = "--with-examples" ]; then
    if [ -d "$EXAMPLES_DIR" ]; then
        cp -r "$EXAMPLES_DIR/foundation/"* context/foundation/ 2>/dev/null || true
        cp -r "$EXAMPLES_DIR/specs/"* context/specs/ 2>/dev/null || true
        cp -r "$EXAMPLES_DIR/tasks/"* context/tasks/ 2>/dev/null || true
        echo ""
        echo "✓ Copied example files"
    else
        echo ""
        echo "⚠ Examples directory not found at $EXAMPLES_DIR"
    fi
fi
