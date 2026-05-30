# Blackjackal

A Chrome extension and automation toolkit for browser-based workflow assistance.

## What This Does

Blackjackal is a Chrome extension project with supporting scripts and tooling. It provides browser-side automation, workflow helpers, and integration utilities that run inside Chrome via an extension manifest.

The project keeps source code in `src/` (version controlled) and runtime state in a local Chrome workspace (gitignored, synced via `make sync`).

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

## Project Structure

```
src/              # Extension source code (version controlled)
scripts/          # Automation and utility scripts
docs/             # Documentation
config/           # Configuration templates
runtime/          # Runtime data (gitignored — synced from Chrome workspace)
tests/            # Test suites
```

## Development Workflow

1. Source code lives in `src/` — this is version controlled
2. Chrome profile data lives in the local workspace — **never** commit this
3. Use `make sync` to extract relevant state from Chrome workspace
4. Use `make setup` to initialize a fresh development environment
5. Use `make verify` to verify project structure and environment

## Make Targets

| Target | Description |
|--------|-------------|
| `make setup` | Initialize development environment |
| `make sync` | Sync runtime state from Chrome workspace |
| `make verify` | Verify project structure and environment |
| `make check-env` | Check environment prerequisites |
| `make clean` | Clean runtime artifacts (safe) |
| `make help` | Show available targets |

## Configuration

- `BLACKJACKAL_CHROME_PATH` — Override default Chrome workspace path
- `config/chrome-workspace.conf` — Workspace and sync settings

## Tech Stack

- JavaScript (Chrome Extension Manifest V3)
- Shell scripts (automation)
- Makefile (build orchestration)

## Status

Active development. Extension is local-only; no store deployment yet.

---

*See [AGENTS.md](AGENTS.md) for agent collaboration notes.*
