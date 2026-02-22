#!/bin/bash
# Sync relevant runtime state from Chrome workspace
# NEVER commit sensitive browser data

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CHROME_WORKSPACE="${BLACKJACKAL_CHROME_PATH:-/Users/aribs/.blackjackal-chrome}"
RUNTIME_DIR="$PROJECT_ROOT/runtime"

echo "=== Blackjackal Runtime Sync ==="
echo "Chrome workspace: $CHROME_WORKSPACE"
echo "Project runtime dir: $RUNTIME_DIR"

# Ensure runtime directory exists
mkdir -p "$RUNTIME_DIR/chrome-profile"

# Check if Chrome workspace exists
if [[ ! -d "$CHROME_WORKSPACE" ]]; then
    echo "ERROR: Chrome workspace not found at $CHROME_WORKSPACE"
    echo "Set BLACKJACKAL_CHROME_PATH to override"
    exit 1
fi

# Sync only non-sensitive metadata
echo "Syncing extension manifest versions..."

# Extract extension info (safe metadata only)
if [[ -d "$CHROME_WORKSPACE/Default/Extensions" ]]; then
    find "$CHROME_WORKSPACE/Default/Extensions" -maxdepth 2 -name "*.json" 2>/dev/null | while read -r f; do
        target="$RUNTIME_DIR/chrome-profile/$(basename "$f")"
        cp "$f" "$target" 2>/dev/null || true
    done
fi

# Capture last sync timestamp
date -u +"%Y-%m-%dT%H:%M:%SZ" > "$RUNTIME_DIR/last_sync.txt"

echo "Sync complete. Timestamp: $(cat "$RUNTIME_DIR/last_sync.txt")"
echo ""
echo "WARNING: Review runtime/ before committing."
echo "Only commit non-sensitive metadata."
