#!/bin/bash
# Sync relevant runtime state from Chrome workspace
# NEVER commit sensitive browser data
# This script is deterministic: same input produces same output structure

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source configuration if available
CONFIG_FILE="$PROJECT_ROOT/config/chrome-workspace.conf"
if [[ -f "$CONFIG_FILE" ]]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE" 2>/dev/null || true
fi

# Use environment variable, config file, or default
CHROME_WORKSPACE="${BLACKJACKAL_CHROME_PATH:-${CHROME_WORKSPACE_PATH:-/Users/aribs/.blackjackal-chrome}}"
RUNTIME_DIR="$PROJECT_ROOT/runtime"
SYNC_MODE="${SYNC_MODE:-metadata-only}"

echo "=== Blackjackal Runtime Sync ==="
echo "Chrome workspace: $CHROME_WORKSPACE"
echo "Project runtime dir: $RUNTIME_DIR"
echo "Sync mode: $SYNC_MODE"
echo ""

# Ensure runtime directory exists
mkdir -p "$RUNTIME_DIR/chrome-profile"

# Check if Chrome workspace exists
if [[ ! -d "$CHROME_WORKSPACE" ]]; then
    echo "ERROR: Chrome workspace not found at $CHROME_WORKSPACE"
    echo "Set BLACKJACKAL_CHROME_PATH environment variable to override"
    exit 1
fi

# Validate sync mode
if [[ "$SYNC_MODE" != "metadata-only" && "$SYNC_MODE" != "full" ]]; then
    echo "ERROR: Invalid SYNC_MODE: $SYNC_MODE (must be 'metadata-only' or 'full')"
    exit 1
fi

# Track sync statistics
declare -i synced_count=0
skipped_count=0

# Sync only non-sensitive metadata
echo "Syncing extension manifest versions..."

# Extract extension info (safe metadata only)
if [[ -d "$CHROME_WORKSPACE/Default/Extensions" ]]; then
    while IFS= read -r -d '' f; do
        target="$RUNTIME_DIR/chrome-profile/$(basename "$f")"
        # Only sync manifest.json files (safe metadata)
        if [[ "$(basename "$f")" == "manifest.json" ]]; then
            if cp "$f" "$target" 2>/dev/null; then
                synced_count=$((synced_count + 1))
            fi
        else
            skipped_count=$((skipped_count + 1))
        fi
    done < <(find "$CHROME_WORKSPACE/Default/Extensions" -maxdepth 3 -name "*.json" -print0 2>/dev/null || true)
fi

# Capture last sync timestamp and metadata
{
    echo "timestamp: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    echo "source: $CHROME_WORKSPACE"
    echo "mode: $SYNC_MODE"
    echo "synced_files: $synced_count"
    echo "skipped_files: $skipped_count"
} > "$RUNTIME_DIR/last_sync.txt"

echo ""
echo "=== Sync Complete ==="
echo "Files synced: $synced_count"
echo "Files skipped: $skipped_count"
echo "Timestamp: $(grep "^timestamp:" "$RUNTIME_DIR/last_sync.txt" | cut -d' ' -f2)"
echo ""
echo "WARNING: Review runtime/ before committing."
echo "Only commit non-sensitive metadata."
