#!/bin/bash
# Setup development environment for Blackjackal
# Reproducible setup - can be run multiple times safely

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source configuration if available
CONFIG_FILE="$PROJECT_ROOT/config/chrome-workspace.conf"
if [[ -f "$CONFIG_FILE" ]]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE" 2>/dev/null || true
fi

CHROME_WORKSPACE="${BLACKJACKAL_CHROME_PATH:-${CHROME_WORKSPACE_PATH:-/Users/aribs/.blackjackal-chrome}}"

echo "=== Blackjackal Dev Environment Setup ==="
echo "Project root: $PROJECT_ROOT"
echo "Chrome workspace: $CHROME_WORKSPACE"
echo ""

# Create directory structure (idempotent)
echo "Creating directory structure..."
mkdir -p "$PROJECT_ROOT/src"
mkdir -p "$PROJECT_ROOT/tests"
mkdir -p "$PROJECT_ROOT/docs"
mkdir -p "$PROJECT_ROOT/config"
mkdir -p "$PROJECT_ROOT/runtime/chrome-profile"

# Make scripts executable
if [[ -d "$PROJECT_ROOT/scripts" ]]; then
    chmod +x "$PROJECT_ROOT/scripts/"*.sh 2>/dev/null || true
    echo "  ✓ Scripts made executable"
fi

# Create runtime/.gitkeep to document the directory (but runtime/ remains gitignored)
if [[ ! -f "$PROJECT_ROOT/runtime/.gitkeep" ]]; then
    echo "# This directory contains local runtime state" > "$PROJECT_ROOT/runtime/.gitkeep"
    echo "# It is gitignored but preserved for documentation" >> "$PROJECT_ROOT/runtime/.gitkeep"
    echo "  ✓ Created runtime/.gitkeep"
fi

# Verify Chrome workspace
echo ""
echo "Checking Chrome workspace..."
if [[ -d "$CHROME_WORKSPACE" ]]; then
    echo "  ✓ Chrome workspace found: $CHROME_WORKSPACE"
    
    # Count available extensions for info
    if [[ -d "$CHROME_WORKSPACE/Default/Extensions" ]]; then
        ext_count=$(find "$CHROME_WORKSPACE/Default/Extensions" -maxdepth 1 -type d | wc -l)
        ext_count=$((ext_count - 1))  # Exclude parent directory
        if [[ $ext_count -gt 0 ]]; then
            echo "  ✓ Found $ext_count extension directories"
        fi
    fi
else
    echo "  ⚠ Chrome workspace not found at $CHROME_WORKSPACE"
    echo "    Set BLACKJACKAL_CHROME_PATH environment variable to override"
fi

# Check git repository
cd "$PROJECT_ROOT"
if [[ -d .git ]]; then
    echo "  ✓ Git repository initialized"
    # Show current branch
    branch=$(git branch --show-current 2>/dev/null || echo "unknown")
    echo "    Branch: $branch"
else
    echo "  ⚠ Not a git repository"
fi

echo ""
echo "=== Setup Complete ==="
echo "Next steps:"
echo "  1. make verify    # Verify project structure"
echo "  2. make sync      # Sync Chrome workspace state"
echo "  3. Begin development in src/"
