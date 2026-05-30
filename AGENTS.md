# Blackjackal — Agent Notes

A reproducible development workspace for Chrome extension projects. Keeps source code version-controlled while ensuring sensitive browser profile data never reaches git.

## What this repo does

Blackjackal separates Chrome extension source code (`src/`) from local Chrome runtime state (`.blackjackal-chrome/`). It provides Makefile targets and bash scripts for setup, verification, and safe metadata sync.

## Key directories and files

| Path | Purpose |
|------|---------|
| `src/` | Extension source code (version controlled) |
| `scripts/` | Bash automation: `setup_dev.sh`, `sync_runtime.sh` |
| `config/chrome-workspace.conf` | Workspace path, allowed/blocked sync paths, sync mode |
| `Makefile` | Deterministic targets: `setup`, `sync`, `verify`, `clean`, `check-env` |
| `docs/` | Project documentation |
| `tests/` | Test suites |
| `runtime/` | Gitignored local runtime state synced from Chrome workspace |

## How to run / develop

```bash
make setup      # Initialize dirs and check Chrome workspace
make verify     # Validate structure and permissions
make sync       # Sync safe metadata from Chrome workspace
make clean      # Remove generated artifacts (preserves runtime/)
```

## Safety boundaries

- **Do NOT** commit the Chrome profile workspace or `runtime/` directory.
- **Do NOT** sync cookies, login data, web data, or `.db`/`.pma` files.
- Default sync mode is `metadata-only`. Changing to `full` requires explicit human review.
- Keep `BLACKJACKAL_CHROME_PATH` local; do not hardcode personal paths in committed files.

## Current status

Active scaffold. Makefile and scripts are functional. Extension implementation is expected in `src/`.
