# CLAUDE.md — cursor-rules

> Portable AI assistant ruleset for Cursor IDE and Claude Code.

## Infrastructure

- **Build:** `Makefile` → `scripts/bundle.sh`
  - `make bundle-ios` — compact behavioral core → `dist/rules-ios.md`
  - `make bundle-claude-code` — drop-in CLAUDE.md → `dist/CLAUDE.md`
  - `make bundle-full` — all rules + dialogues → `dist/rules-full.md`
  - `make bundle-all` — build all profiles
  - `make list` — show files in each profile
  - `make clean` — remove `dist/`
- **Profiles:** `profiles/*.txt` (one filename per line, comments with `#`)
- **Output:** `dist/` (gitignored)
- **No runtime deps** — pure Bash + awk

## Project Structure

| Path | Purpose |
|------|---------|
| `*.md`, `*.mdc` | Rule files (YAML frontmatter + markdown) |
| `profiles/` | Bundle definitions (ios, claude-code, full) |
| `scripts/bundle.sh` | Concatenates rules, strips frontmatter |
| `dialogue/` | Session handover/standup templates |
| `Makefile` | Build targets |

## Tag Cross-Reference

| Tag | File |
|-----|------|
| `#CORE` | `core.mdc` |
| `#INIT` | `init.md` |
| `#ALWAYS` | `always.md` |
| `#ETIQUETTE` | `etiquette.md` |
| `#WORKFLOW` | `workflow.md` |
| `#CODE-STYLE` | `code-style.md` |
| `#ASK-QUESTION` | `ask-question.md` |
| `#CURSOR-CONFIG` | `cursor-config.md` |
| `#CONTEXT` | `context-gathering.md` |
| `#DISCOVERY` | `command-discovery.md` |
| `#GIT-WORKTREE` | `git-worktree.md` |

## Tasks

### Documentation

- [ ] Add a README.md with project overview, usage instructions, and profile descriptions
- [ ] Add a CONTRIBUTING.md covering: rule file format (YAML frontmatter fields), `.mdc` vs `.md` extension choice, tag naming conventions, profile creation, and how to test bundles
- [ ] Add a changelog or release notes workflow for tracking rule changes

### Build & CI

- [ ] Add CI pipeline (GitHub Actions) to validate bundles build cleanly on push/PR
- [ ] Add a `make check` target that verifies all files referenced in profiles exist
- [ ] Add a `make validate` target that checks YAML frontmatter format in `.mdc`/`.md` files

### Content

- [ ] Update `cursor-config.md` to clearly separate "rules bundled in this repo" from "commands/agents that live in the destination `.cursor/` folder" (e.g., `@git/commit`, `agents/engineering.mdc`), so users know which parts ship here vs. which are set up per-project
- [ ] Add a profile for Claude Code that omits Cursor-specific instructions (current `claude-code` profile still includes Cursor references like `ask_question`)
- [ ] Consider adding a minimal/starter profile for onboarding new projects

### Testing

- [ ] Add a smoke test that runs `make bundle-all` and checks output files exist with expected content markers
- [ ] Validate that `bundle.sh` handles edge cases (empty profile, missing file, file without frontmatter)

### Maintenance

- [ ] Audit rule files for stale cross-references (tags that point to missing files)
- [ ] Consider versioning strategy for bundled rules (semver tags, generated header version)
- [ ] Archive or document the relationship between this repo and destination `.cursor/` config

## Lessons Learned

- `.mdc` extension is required for Cursor auto-loading; `.md` files are reference-only
- The `bundle.sh` script strips YAML frontmatter — rule content must work without it
- Each profile is just a list of filenames; order matters for the bundled output
