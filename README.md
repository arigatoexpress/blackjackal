# Blackjackal

> A reproducible development workspace for tracking and managing Chrome extension projects — without leaking sensitive browser data into version control.

**Tech stack:** Bash · Make · Chrome Extension APIs

*[Agent collaborators: see [AGENTS.md](AGENTS.md)]*

## What this does

Blackjackal provides a clean, safe boundary between your Chrome extension source code and your local Chrome profile data. Source lives in `src/` and is version-controlled; runtime browser state stays in a local Chrome workspace and is never committed. Use `make sync` to extract only safe metadata (like extension manifest versions) when you need to inspect your runtime environment.

## Quick start

```bash
# Clone
git clone https://github.com/arigatoexpress/blackjackal.git
cd blackjackal

# Initialize dev environment (idempotent)
make setup

# Verify structure and prerequisites
make verify

# Sync safe metadata from Chrome workspace
make sync
```

## Available commands

| Command | What it does |
|---------|--------------|
| `make setup` | Create directories, make scripts executable, check Chrome workspace |
| `make verify` | Validate directory structure, script permissions, and Chrome workspace |
| `make sync` | Copy safe metadata (e.g., `manifest.json`) from Chrome workspace to `runtime/` |
| `make clean` | Remove generated runtime artifacts (safe — local state is preserved) |
| `make check-env` | Confirm bash and git are available |
| `make help` | Show all targets |

## Project structure

```text
blackjackal/
├── src/              # Source code (version controlled)
├── scripts/          # Automation and utility scripts
├── docs/             # Documentation
├── config/           # Configuration templates
├── runtime/          # Runtime data (gitignored — synced from Chrome workspace)
└── tests/            # Test suites
```

## Configuration

- **Environment variable:** `BLACKJACKAL_CHROME_PATH` — override the default Chrome workspace path (`/Users/aribs/.blackjackal-chrome`)
- **Config file:** `config/chrome-workspace.conf` — workspace path, allowed sync paths, blocked paths, and sync mode

## Safety notes

- The Chrome profile workspace (`runtime/`, `.blackjackal-chrome/`) is **gitignored** and must never be committed.
- `make sync` runs in `metadata-only` mode by default. It copies only `manifest.json` and other non-sensitive files.
- Blocked paths include cookies, login data, and local databases.

## Status

Active scaffold. Makefile, scripts, and config are functional. Extension source code is expected in `src/`.
