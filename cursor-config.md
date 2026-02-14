---
tag: CURSOR-CONFIG
scope: global
---
# AI Assistant Configuration Reference

How rules, commands, and agents are organized across Cursor and Claude Code. Use tags for cross-references.

---

## Platform Comparison

| Concept | Cursor | Claude Code |
|---------|--------|-------------|
| Project context | `CLAUDE.md` | `CLAUDE.md` |
| Global config dir | `~/.cursor/` | `~/.claude/` |
| Auto-loaded rules | `.mdc` with frontmatter | `CLAUDE.md` (repo root + parents) |
| Structured questions | `ask_question` | `AskUserQuestion` |
| File operations | `read_file`, `list_dir` | `Read`, `Glob`, `Grep` |
| Ignore file | `.cursorignore` | `.claudeignore` |
| Commands | `@command` / `/command` | `/slash-commands`, hooks |
| Agents | `agents/*.mdc` | Subagents via Task tool |
| Conditional rules | `.mdc` with `globs` | Not applicable (use CLAUDE.md) |

---

## Tag Reference

Cross-reference rules with `#TAG` and commands with `@path`.

### Rules (#)

| Tag | File | Description |
|-----|------|-------------|
| `#CORE` | `core.mdc` | Always-applied safety, structured questions, style |
| `#INIT` | `init.md` | Session initialization |
| `#ALWAYS` | `always.md` | Operational procedures |
| `#ETIQUETTE` | `etiquette.md` | Communication patterns |
| `#WORKFLOW` | `workflow.md` | Git and handover patterns |
| `#CODE-STYLE` | `code-style.md` | Formatting rules |
| `#ASK-QUESTION` | `ask-question.md` | Structured question tool enforcement |
| `#CURSOR-CONFIG` | `cursor-config.md` | This file - config structure reference |
| `#CONTEXT` | `context-gathering.md` | Environment detection |
| `#DISCOVERY` | `command-discovery.md` | Command suggestions |
| `#GIT-WORKTREE` | `git-worktree.md` | Worktree patterns |
| `#DIR-SRC` | `dir-src.mdc` | Production code patterns |
| `#DIR-EXPERIMENTS` | `dir-experiments.mdc` | ML experiment patterns |
| `#DIR-NOTEBOOKS` | `dir-notebooks.mdc` | Jupyter notebook patterns |
| `#DIR-SCRIPTS` | `dir-scripts.mdc` | Utility script patterns |
| `#DIR-TESTS` | `dir-tests.mdc` | Test file patterns |
| `#DIR-CURSOR` | `dir-cursor.mdc` | AI config authoring patterns |

### Commands (@)

| Tag | Path | Description |
|-----|------|-------------|
| `@git/commit` | `git/commit.md` | Staging and committing |
| `@git/pr` | `git/pr.md` | PR via worktrees |
| `@git/cherry-pick` | `git/cherry-pick.md` | Cherry-pick commits |
| `@git/worktree` | `git/worktree.md` | Create worktree |
| `@git/worktrees` | `git/worktrees.md` | Discover worktrees |
| `@session/continue` | `session/continue.md` | Context recovery |
| `@session/agentic` | `session/agentic.md` | Autonomous execution |
| `@session/handover` | `session/handover.md` | Session handover |
| `@session/eod` | `session/eod.md` | End of day |
| `@session/catch-up` | `session/catch-up.md` | Quick orientation |
| `@session/summarize` | `session/summarize.md` | Generate startup prompt |
| `@session/read-only` | `session/read-only.md` | Observer mode |
| `@sync/remote` | `sync/remote.md` | Remote sync |
| `@sync/chezmoi` | `sync/chezmoi.md` | Dotfile sync |
| `@config/review` | `config/review.md` | Review AI config |
| `@setup/agentic` | `setup/agentic.md` | Agentic config setup |
| `@update` | `update.md` | Status check |
| `@audit` | `audit.md` | Committee review |
| `@ideate` | `ideate.md` | Improvement ideas |
| `@note` | `note.md` | Persist notes |
| `@todo` | `todo.md` | Task management |
| `@slack` | `slack.md` | Slack replies |
| `@access-files` | `access-files.md` | File access helpers |

---

## Cursor Directory Structure

```
.cursor/
├── rules/          # Always-active behavior (*.mdc for auto-load, *.md for reference)
├── commands/       # User-triggered workflows (*.md)
└── agents/         # Specialized personas (*.mdc)
```

| Folder | Extension | Activation | Purpose |
|--------|-----------|------------|---------|
| `rules/` | `.mdc` | Auto-loaded (with frontmatter) | Enforced constraints, style rules |
| `rules/` | `.md` | Reference only (not auto-loaded) | Documentation, extended examples |
| `commands/` | `.md` | User invokes (`/command`) | Task-specific workflows |
| `agents/` | `.mdc` | User selects | Specialized personas with model config |

## Claude Code Configuration

Claude Code reads `CLAUDE.md` files from the repo root (and parent directories) automatically. To use these rules with Claude Code:

1. **Copy behavioral content** from rule files into your repo's `CLAUDE.md`
2. **Reference this repo** as a source of patterns and conventions
3. **Use hooks** (in `~/.claude/settings.json`) for automated checks

Claude Code has no equivalent of `.mdc` conditional rules — put all context in `CLAUDE.md`.

---

## Rules (Cursor: `rules/*.mdc`)

**Cursor-specific:** Only `.mdc` files with YAML frontmatter are auto-loaded by Cursor.

### Rule Types

| Type | Extension | Frontmatter | When Applied |
|------|-----------|-------------|--------------|
| Always-on | `.mdc` | `alwaysApply: true` | Every interaction |
| Conditional | `.mdc` | `globs: [...]` | When file pattern matches |
| Reference | `.md` | `tag`/`scope` only | Never auto-loaded (documentation only) |

### Frontmatter Format

```yaml
---
name: 'Rule Name'
description: 'One-line purpose'
alwaysApply: true  # OR use globs for conditional
# globs: ["**/src/**/*"]  # Optional: only apply to matching files
---
```

### Naming Convention
- Lowercase with hyphens: `core.mdc`, `dir-src.mdc`
- Prefix with `dir-` for directory-conditional rules
- Names should be self-descriptive

### Current Rules

| File | alwaysApply | Purpose |
|------|-------------|---------|
| `core.mdc` | true | Safety, structured question enforcement, style |
| `dir-src.mdc` | false (globs) | Production code patterns |
| `dir-experiments.mdc` | false (globs) | ML experiment patterns |
| `dir-notebooks.mdc` | false (globs) | Jupyter notebook patterns |
| `dir-scripts.mdc` | false (globs) | Utility script patterns |
| `dir-tests.mdc` | false (globs) | Test file patterns |

### Reference Files (Not Auto-Loaded)

| File | Purpose |
|------|---------|
| `always.md` | Operational procedures |
| `etiquette.md` | Communication patterns |
| `workflow.md` | Git and handover patterns |
| `ask-question.md` | Structured question tool reference |

---

## Commands (`commands/*.md`)

Commands are user-triggered workflows.

> Cursor: invoke with `@command-name` · Claude Code: use `/slash-commands` or describe the workflow

### Naming Convention
- Lowercase with hyphens: `commit.md`, `sweep.md`
- Use hierarchical folders: `git/`, `ml/`, `session/`, `sync/`

### Required Sections

```markdown
# Command Name

You are a [role]. [One-line purpose].

## Session Scope
[What this command handles / redirects]

## Think Before Acting
[Plan before executing - what, how, risks]

## Workflow
[Step-by-step process]

## Never Do
[Command-specific restrictions]

## Always End With a Follow-Up Question
[Keep momentum with relevant questions]

## Related Commands
| Situation | Suggest |
|-----------|---------|
| Need X | → **other-command** |
```

### Current Commands

| Path | Purpose |
|------|---------|
| `git/commit` | Staging, committing, branching |
| `git/pr` | Split changes into PRs via worktrees |
| `git/cherry-pick` | Cherry-pick commits between branches |
| `git/worktree` | Create isolated worktrees |
| `session/handover` | Session handover with unique keys |
| `session/continue` | Resume previous work |
| `session/eod` | End of day summary |
| `sync/remote` | Sync config to remote servers |
| `config/review` | Review AI config |
| `update` | Comprehensive status check |
| `ideate` | Brainstorming/planning mode |
| `note` | Persist notes to CLAUDE/ |
| `todo` | Manage todos |

---

## Agents (Cursor: `agents/*.mdc`)

Agents are specialized personas with model configuration. Cursor uses `.mdc` extension (markdown with frontmatter). Claude Code uses subagents via the Task tool.

### Frontmatter Format (Cursor)

```yaml
---
name: 'Agent Name'
model: claude-opus-4-20250514  # update to latest version
description: 'One-line purpose'
---
```

### Model Selection
| Task Type | Model | Reasoning |
|-----------|-------|-----------|
| Complex/safety-critical | `claude-opus-4-*` | Best reasoning |
| Standard coding | `claude-sonnet-4-*` | Good balance |
| Simple tasks | `claude-haiku-4-*` | Fast/cheap |

### Agent Structure

```markdown
---
name: 'Engineering'
model: claude-opus-4-20250514
description: 'Production engineering - robust code'
---

# Engineering Agent

You are a [role]. [Context].

## Core Principles
[What this agent prioritizes]

## Before Any Action
[Pre-flight checks specific to domain]

## [Domain-Specific Sections]
[Tables, checklists, examples]

## CLAUDE.md
[How this agent uses CLAUDE.md]

## Never Do
[Agent-specific restrictions]
```

### Current Agents
| File | Purpose | Model |
|------|---------|-------|
| `engineering.mdc` | Production code, system design | opus |
| `research.mdc` | Research/ML experimentation | opus |
| `sweep-ops.mdc` | Slurm/WandB sweep operations | opus |
| `git-ops.mdc` | Git operations specialist | opus |
| `reviewer.mdc` | Code review | opus |
| `games-builder.mdc` | Game development | opus |

---

## Common Patterns

### Tables for Quick Reference
```markdown
| Action | Command | Notes |
|--------|---------|-------|
| Commit | `git add && git commit` | Atomic |
```

### Good/Bad Examples
```markdown
### Bad Examples
```bash
# Don't do this
sleep 30 && echo "done"
```

### Good Examples
```bash
# Do this instead
timeout 10 some_command
```
```

### Verification Checklists
```markdown
### Before Committing
- [ ] User explicitly said "commit"
- [ ] Commit message follows [tag] format
- [ ] One concern per commit
```

### Follow-Up Question Tables
```markdown
| Situation | Example Questions |
|-----------|-------------------|
| After task | "Should I commit this?" |
| Unclear | "Could you clarify?" |

**Default:** "What would you like to do next?"
```

---

## Creating New Configurations

### New Rule (Cursor Auto-Loaded)
1. Create `rules/my-rule.mdc` (note: `.mdc` extension required for Cursor)
2. Add YAML frontmatter with `name`, `description`, and either:
   - `alwaysApply: true` for always-on rules
   - `globs: ["pattern"]` for conditional rules
3. Add "Never Do" and "Always Do" sections
4. Include verification checklists if applicable

### New Rule (Claude Code)
1. Add the rule content to `CLAUDE.md` in the repo root
2. Use markdown headers to organize sections
3. Claude Code reads this file automatically on every session

### New Reference Doc (Not Auto-Loaded)
1. Create `rules/my-reference.md` (plain `.md`)
2. May use `tag`/`scope` frontmatter for organization
3. Reference from `.mdc` files or `CLAUDE.md` as needed

### New Command
1. Create `commands/category/my-command.md` (use folder hierarchy)
2. Include required sections (Scope, Think Before Acting, Workflow, Follow-Up)
3. Add "Related Commands" cross-references
4. No frontmatter needed

### New Agent (Cursor)
1. Create `agents/my-agent.mdc`
2. Add YAML frontmatter with `name`, `model`, `description`
3. Define domain-specific behavior
4. Reference how it uses CLAUDE.md

---

## File Conventions

- **Cursor rules: `.mdc` for auto-load** - plain `.md` files are reference only
- **Claude Code: `CLAUDE.md`** - single file, auto-loaded
- **Lowercase with hyphens** - `git/commit.md` not `GitCommit.md`
- **Hierarchical folders** - `commands/git/`, `commands/ml/`, etc.
- **Self-documenting names** - purpose clear from filename
- **Cross-reference** - link to related commands/rules

---

## Key Invariants Across All Configs

**Authoritative Safety table:** #CORE

All rules/commands/agents must respect the Safety section in #CORE. Key points:

- Never `git push/commit` without explicit request
- Never `rm` user/source files (backup first)
- Handle try/catch only at system boundaries, max 4 indent levels
- End with follow-up question, check CLAUDE.md first
