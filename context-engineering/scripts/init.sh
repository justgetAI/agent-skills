#!/bin/sh
# Context Engineering - Init Script
# Creates context/ directory structure in current project
#
# Portability: POSIX-compliant, tested on Linux. Uses only:
#   mkdir, touch, echo, cd, dirname, set -e
# Should work on macOS, Ubuntu, Git Bash (Windows)
#
# Usage:
#   ./init.sh              # minimal structure
#   ./init.sh --with-examples  # include example files (feat003)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

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

# Handle --with-examples flag (placeholder for feat003)
if [ "$1" = "--with-examples" ]; then
    echo ""
    echo "⚠ --with-examples not yet implemented (see feat003)"
fi
