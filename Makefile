# Blackjackal - Reproducible Workflow Makefile
# Provides deterministic targets for setup, sync, and verification

.PHONY: help setup sync verify clean check-env

# Default target
help:
	@echo "Blackjackal - Available targets:"
	@echo "  make setup    - Initialize development environment"
	@echo "  make sync     - Sync runtime state from Chrome workspace"
	@echo "  make verify   - Verify project structure and environment"
	@echo "  make check-env - Check environment prerequisites"
	@echo "  make clean    - Clean runtime artifacts (safe)"

# Setup development environment
setup: check-env
	@echo "=== Running setup ==="
	./scripts/setup_dev.sh

# Sync runtime from Chrome workspace
sync: check-env
	@echo "=== Running sync ==="
	./scripts/sync_runtime.sh

# Verify project structure and reproducibility
verify: check-env
	@echo "=== Verifying project structure ==="
	@bash -c '\
		errors=0; \
		echo "Checking directory structure..."; \
		for dir in src tests docs config scripts; do \
			if [[ -d "$$dir" ]]; then \
				echo "  ✓ $$dir/"; \
			else \
				echo "  ✗ $$dir/ MISSING"; \
				errors=$$((errors + 1)); \
			fi; \
		done; \
		echo "Checking runtime directory..."; \
		if [[ -d "runtime" ]]; then \
			echo "  ✓ runtime/ (gitignored, local only)"; \
		else \
			echo "  ⚠ runtime/ does not exist (run: make setup)"; \
		fi; \
		echo "Checking scripts are executable..."; \
		for script in scripts/*.sh; do \
			if [[ -x "$$script" ]]; then \
				echo "  ✓ $$script"; \
			else \
				echo "  ✗ $$script not executable"; \
				errors=$$((errors + 1)); \
			fi; \
		done; \
		echo "Checking Chrome workspace..."; \
		chrome_path="$${BLACKJACKAL_CHROME_PATH:-/Users/aribs/.blackjackal-chrome}"; \
		if [[ -d "$$chrome_path" ]]; then \
			echo "  ✓ Chrome workspace: $$chrome_path"; \
		else \
			echo "  ⚠ Chrome workspace not found: $$chrome_path"; \
			echo "    Set BLACKJACKAL_CHROME_PATH to override"; \
		fi; \
		echo ""; \
		if [[ $$errors -eq 0 ]]; then \
			echo "=== Verification PASSED ==="; \
			exit 0; \
		else \
			echo "=== Verification FAILED ($$errors errors) ==="; \
			exit 1; \
		fi; \
	'

# Check environment prerequisites
check-env:
	@echo "Checking prerequisites..."
	@command -v bash >/dev/null 2>&1 || { echo "ERROR: bash required"; exit 1; }
	@command -v git >/dev/null 2>&1 || { echo "ERROR: git required"; exit 1; }
	@echo "  ✓ bash"
	@echo "  ✓ git"

# Clean runtime artifacts (safe - only removes generated files)
clean:
	@echo "=== Cleaning runtime artifacts ==="
	@if [[ -d runtime ]]; then \
		rm -f runtime/last_sync.txt; \
		echo "  ✓ Cleaned runtime/last_sync.txt"; \
	fi
	@echo "=== Clean complete ==="
	@echo "Note: runtime/ directory preserved (contains local state)"
