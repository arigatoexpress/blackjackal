# Blackjackal — Agent Notes

## What This Is

Chrome extension + automation toolkit. Source in `src/`, runtime state synced from local Chrome workspace.

## Key Paths

| Path | Purpose |
|------|---------|
| `src/` | Extension source code (committed) |
| `scripts/` | Automation utilities |
| `config/` | Configuration templates |
| `runtime/` | Chrome profile state (gitignored) |
| `tests/` | Test suites |
| `Makefile` | Build targets |

## Dev Commands

```bash
make setup    # Initialize dev environment
make sync     # Sync from Chrome workspace
make verify   # Validate structure
make clean    # Clean runtime artifacts
```

## Safety Boundaries

- `runtime/` and `chrome-profile/` must stay gitignored.
- Do not commit real Chrome profile data, cookies, or credentials.
- Extension is local-only; no production store keys should be added.

## Status

Active. Safe to iterate on extension source and scripts.
