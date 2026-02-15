.PHONY: bundle bundle-ios bundle-claude-code bundle-full bundle-all list clean help

BUNDLE := ./scripts/bundle.sh
DIST   := dist

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

bundle: bundle-ios ## Default: build iOS bundle

bundle-ios: ## Bundle for Claude iOS (compact behavioral core)
	@$(BUNDLE) ios --out $(DIST)/rules-ios.md

bundle-claude-code: ## Bundle for Claude Code (drop-in CLAUDE.md)
	@$(BUNDLE) claude-code --out $(DIST)/CLAUDE.md

bundle-full: ## Bundle everything (all rules + directory patterns + dialogues)
	@$(BUNDLE) full --out $(DIST)/rules-full.md

bundle-all: bundle-ios bundle-claude-code bundle-full ## Build all profiles

list: ## List files in each profile
	@for p in profiles/*.txt; do \
		name=$$(basename $$p .txt); \
		echo "=== $$name ==="; \
		$(BUNDLE) $$name --list; \
		echo ""; \
	done

clean: ## Remove generated bundles
	rm -rf $(DIST)
