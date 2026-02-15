# cursor-rules

A composable rule and configuration system for AI coding assistants (Cursor, Claude Code, GitHub Copilot). Provides reusable rules, agent personas, dialogue templates, and a bundling system to generate platform-specific rule sets from a single source of truth.

## Repository Structure

```
cursor-rules/
├── CLAUDE.md               # This file — repo context for AI assistants
├── Makefile                 # Build system for bundling rules
├── scripts/
│   └── bundle.sh           # Generates portable markdown bundles
├── profiles/               # Profile definitions (one filename per line)
│   ├── ios.txt             # Compact iOS profile (5 files)
│   ├── claude-code.txt     # Claude Code drop-in CLAUDE.md (8 files)
│   └── full.txt            # Full bundle with all rules (21 files)
├── .github/
│   └── agents/             # GitHub agent personas
│       ├── swe.md
│       ├── research-engineer.md
│       ├── writer.md
│       ├── editor.md
│       └── scientist.md
├── dialogue/               # Interactive dialogue templates
│   ├── morning-standup.md
│   ├── catch-up.md
│   ├── micro-handover.md
│   └── worktree-handover.md
├── Core Rules (always-active or reference)
│   ├── core.mdc            # Safety, structured questions, style (auto-loaded)
│   ├── init.md             # Session initialization
│   ├── always.md           # Operational procedures, handover, CLAUDE.md discovery
│   ├── etiquette.md        # Communication patterns, available commands
│   ├── code-style.md       # Formatting, error handling, git commits
│   ├── workflow.md         # Git workflow, worktree patterns, execution style
│   ├── ask-question.md     # Structured question tool enforcement
│   ├── context-gathering.md # Repo/session context collection patterns
│   ├── command-discovery.md # When to suggest specialized commands
│   ├── cursor-config.md    # Configuration reference for Cursor + Claude Code
│   └── git-worktree.md     # Worktree management patterns
└── Directory-Specific Rules (conditional, glob-based)
    ├── dir-src.mdc         # Production source code (src/, lib/, pkg/)
    ├── dir-experiments.mdc # ML experiment patterns (experiments/, exp/)
    ├── dir-notebooks.mdc   # Jupyter notebook guidelines (*.ipynb)
    ├── dir-scripts.mdc     # Utility script patterns (scripts/, bin/, tools/)
    ├── dir-tests.mdc       # Pytest conventions (test_*.py, tests/)
    └── dir-cursor.mdc      # AI config authoring (.cursor/, CLAUDE.md)
```

## Infrastructure

- **Build:** Makefile (`make bundle-ios`, `make bundle-claude-code`, `make bundle-full`, `make help`)
- **Bundler:** `scripts/bundle.sh` — strips YAML frontmatter, concatenates rule files per profile, outputs to `dist/`
- **Output:** `dist/` directory (gitignored)
- **No CI/CD** — validation is manual via review
- **No package manager** — plain markdown + shell scripts

## Key Commands

```bash
make help                  # List all available targets
make bundle-ios            # Build compact iOS bundle → dist/rules-ios.md
make bundle-claude-code    # Build Claude Code bundle → dist/CLAUDE.md
make bundle-full           # Build full bundle → dist/rules-full.md
make bundle-all            # Build all profiles
make list                  # Show files included in each profile
make clean                 # Remove dist/
```

## File Conventions

| Extension | Auto-loaded by Cursor | Purpose |
|-----------|----------------------|---------|
| `.mdc` | Yes (with frontmatter) | Rules with `alwaysApply: true` or `globs: [...]` |
| `.md` | No (reference only) | Documentation, dialogue templates, commands |

- **Naming:** lowercase with hyphens (`git-worktree.md`, not `GitWorktree.md`)
- **Directory rules:** prefixed with `dir-` (`dir-src.mdc`, `dir-tests.mdc`)
- **Tags:** `#TAGNAME` for cross-references between rules (e.g., `#CORE`, `#ALWAYS`)
- **Commands:** `@path` notation (e.g., `@git/commit`, `@session/handover`)

## YAML Frontmatter Format

Rules use frontmatter for metadata:

```yaml
---
name: 'Rule Name'
tag: TAGNAME
scope: global
description: 'One-line purpose'
alwaysApply: true          # or use globs for conditional
# globs: ["**/src/**/*"]   # optional: only apply when matching
---
```

## Tag Reference

| Tag | File | Description |
|-----|------|-------------|
| `#CORE` | `core.mdc` | Safety, structured questions, response style |
| `#INIT` | `init.md` | Session initialization |
| `#ALWAYS` | `always.md` | Operational procedures, handover |
| `#ETIQUETTE` | `etiquette.md` | Communication patterns |
| `#WORKFLOW` | `workflow.md` | Git and handover patterns |
| `#CODE-STYLE` | `code-style.md` | Formatting, error handling, commits |
| `#ASK-QUESTION` | `ask-question.md` | Structured question enforcement |
| `#CURSOR-CONFIG` | `cursor-config.md` | Config structure reference |
| `#CONTEXT` | `context-gathering.md` | Environment detection |
| `#DISCOVERY` | `command-discovery.md` | Command suggestions |
| `#GIT-WORKTREE` | `git-worktree.md` | Worktree patterns |
| `#DIR-SRC` | `dir-src.mdc` | Production code patterns |
| `#DIR-EXPERIMENTS` | `dir-experiments.mdc` | ML experiment patterns |
| `#DIR-NOTEBOOKS` | `dir-notebooks.mdc` | Jupyter notebook patterns |
| `#DIR-SCRIPTS` | `dir-scripts.mdc` | Utility script patterns |
| `#DIR-TESTS` | `dir-tests.mdc` | Test file patterns |
| `#DIR-CURSOR` | `dir-cursor.mdc` | AI config authoring patterns |

## Adding New Content

### New Rule
1. Create `<name>.mdc` with YAML frontmatter (`name`, `description`, `alwaysApply` or `globs`)
2. Add `#TAG` for cross-references
3. Include "Never Do" section if applicable
4. Add to relevant profile(s) in `profiles/*.txt`

### New Profile
1. Create `profiles/<name>.txt` with a `#` comment on line 1 describing the profile
2. List one filename per line (paths relative to repo root)
3. Add a `make bundle-<name>` target in `Makefile`

### New Dialogue Template
1. Create `dialogue/<name>.md` with `tag` and `scope` frontmatter
2. Include: When to Use, Gather (bash), Output Format, Fallbacks, Follow-Up, Related
3. Add to the `full` profile in `profiles/full.txt`

### New Agent (GitHub)
1. Create `.github/agents/<role>.md`
2. Define role, core principles, domain sections, and constraints
3. Follow the existing pattern in `.github/agents/`

## Development Workflow

- **Commit format:** `[tag] lowercase description under 72 chars`
- **Tags:** `[feat]`, `[fix]`, `[ref]`, `[docs]`, `[test]`, `[init]`, `[cfg]`
- **Atomic commits** — one concern per commit, cherry-pick-able
- **No push without explicit request**
- **Reference, don't duplicate** — point to other rules with `#TAG` instead of copying content

## Design Principles

1. **Single source of truth** — one set of rules, bundled per platform
2. **Composable** — rules cross-reference each other, profiles mix and match
3. **Portable** — same content works across Cursor, Claude Code, GitHub Copilot, iOS
4. **Self-documenting** — clear naming, frontmatter, tag system
5. **Minimal tooling** — Makefile + shell script, no build dependencies
