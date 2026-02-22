#!/bin/bash
# Setup development environment for Blackjackal

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=== Blackjackal Dev Environment Setup ==="

# Create directory structure
echo "Creating project structure..."
mkdir -p "$PROJECT_ROOT/src"
mkdir -p "$PROJECT_ROOT/tests"
mkdir -p "$PROJECT_ROOT/docs"
mkdir -p "$PROJECT_ROOT/config"
mkdir -p "$PROJECT_ROOT/runtime"

# Make scripts executable
chmod +x "$PROJECT_ROOT/scripts/"*.sh 2>/dev/null || true

# Verify Chrome workspace
CHROME_WORKSPACE="${BLACKJACKAL_CHROME_PATH:-/Users/aribs/.blackjackal-chrome}"
if [[ -d "$CHROME_WORKSPACE" ]]; then
    echo "✓ Chrome workspace found: $CHROME_WORKSPACE"
else
    echo "⚠ Chrome workspace not found at $CHROME_WORKSPACE"
    echo "  Set BLACKJACKAL_CHROME_PATH if using a different location"
fi

# Check git hooks
cd "$PROJECT_ROOT"
if [[ -d .git ]]; then
    echo "✓ Git repository initialized"
else
    echo "⚠ Not a git repository. Run: git init"
fi

echo ""
echo "=== Setup Complete ==="
echo "Next steps:"
echo "  1. ./scripts/sync_runtime.sh  # Sync Chrome workspace state"
echo "  2. Begin development in src/"
