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
3. Use `make sync` to extract relevant state from Chrome workspace
4. Use `make setup` to initialize a fresh development environment
5. Use `make verify` to verify project structure and environment

## Quick Start

```bash
# Clone and setup
git clone https://github.com/arigatoexpress/blackjackal.git
cd blackjackal
make setup

# Verify everything is in place
make verify

# Sync runtime state from Chrome workspace
make sync
```

## Available Make Targets

| Target | Description |
|--------|-------------|
| `make setup` | Initialize development environment |
| `make sync` | Sync runtime state from Chrome workspace |
| `make verify` | Verify project structure and environment |
| `make check-env` | Check environment prerequisites |
| `make clean` | Clean runtime artifacts (safe) |
| `make help` | Show available targets |

## Configuration

Environment variables:
- `BLACKJACKAL_CHROME_PATH` - Override default Chrome workspace path

Configuration file:
- `config/chrome-workspace.conf` - Workspace and sync settings

## Reproducibility

This project uses deterministic build targets via Makefile:
- `make setup` is idempotent - can be run multiple times safely
- `make verify` validates all expected directories and files
- `make sync` produces consistent output structure given the same input
