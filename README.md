# Blackjackal

Tracked project repo for Blackjackal.

## Project Structure

```
blackjackal/
├── src/                    # Source code (extension, scripts, tools)
├── scripts/                # Automation and utility scripts
├── docs/                   # Documentation
├── config/                 # Configuration templates
├── runtime/                # Runtime data (gitignored - synced from Chrome workspace)
│   └── chrome-profile/     # Chrome extension state (local only)
└── tests/                  # Test suites
```

## Chrome Workspace

The canonical runtime data source remains at:
`/Users/aribs/.blackjackal-chrome`

This Chrome profile workspace is **not** committed to git. Use the sync script to extract relevant state.

## Development Workflow

1. Source code lives in `src/` - this is version controlled
2. Chrome profile data lives in the local workspace - **never** commit this
3. Use `scripts/sync_runtime.sh` to extract relevant state from Chrome workspace
4. Use `scripts/setup_dev.sh` to initialize a fresh development environment

## Quick Start

```bash
# Clone and setup
git clone https://github.com/arigatoexpress/blackjackal.git
cd blackjackal
./scripts/setup_dev.sh

# Sync runtime state from Chrome workspace
./scripts/sync_runtime.sh
```
