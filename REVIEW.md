# Cursor Rules Review

Review of all 21 rule files across core rules, directory-conditional rules, reference docs, and dialogue templates.

---

## Summary

This is a well-structured system for governing AI agent behavior in Cursor IDE. The organization into core (always-on), directory-conditional, reference, and dialogue layers is sound. However, the rules suffer from significant redundancy across files, a few contradictions, some missing references, and several prescriptions that are overly absolute.

---

## 1. Redundancy (High Priority)

The same concepts are restated in multiple files with slightly different wording, which creates maintenance burden and confusion about which version is authoritative.

### "Always End With a Question"

Appears with its own table in three separate files:

| File | Lines | Variant |
|------|-------|---------|
| `core.mdc` | 64-74 | 3-row table |
| `always.md` | 160-187 | Extended table with domain-specific examples |
| `etiquette.md` | 139-148 | 4-row table |

**Recommendation:** Keep the full version in `always.md` only. `core.mdc` should have a one-liner with a `#ALWAYS` reference. Remove from `etiquette.md` entirely.

### Safety Rules

| File | What it says |
|------|-------------|
| `core.mdc` | Authoritative safety table (lines 33-48) |
| `always.md` | "See #CORE" but also has its own "Before ANY Action" section (line 124-128) |
| `etiquette.md` | ASCII art "Quick Reference Card" that partially duplicates core safety (lines 111-135) |

**Recommendation:** `core.mdc` should be the single source of truth (it already claims to be). Other files should reference it without restating. The etiquette Quick Reference Card duplicates rather than references.

### Response Style

| File | Content |
|------|---------|
| `core.mdc` | "Be concise and direct / Show commands before running / Max 4 indentation levels / Match existing repo patterns" |
| `always.md` | "Be concise and direct / Show commands before running / No excessive comments or over-explanation" |
| `etiquette.md` | Do/Don't lists covering the same ground |

**Recommendation:** Consolidate into one location. Reference from others.

### "Before ANY Action" / Check CLAUDE.md

Repeated in `core.mdc` (lines 51-55), `always.md` (lines 124-128), `etiquette.md` (Quick Reference Card), and `dir-src.mdc` (lines 55-58).

### Max 4 Indentation Levels

Appears in `core.mdc`, `always.md`, `code-style.md`, and `etiquette.md`.

---

## 2. Contradictions and Inconsistencies

### try/catch Policy

`core.mdc` safety table (line 44) states flatly:

> | try/catch blocks | Hides errors | Let errors propagate (fail fast) |

But `code-style.md` (lines 60-83) and `dir-src.mdc` (lines 23-37) present a nuanced view: try/catch is appropriate at system boundaries (API endpoints, file I/O, external calls). The `core.mdc` table gives no indication of this exception, making it misleading. A reader who only sees `core.mdc` (which is auto-loaded) would conclude try/catch is always wrong.

**Recommendation:** Update the `core.mdc` safety table entry to: "try/catch in internal code | Hides errors | Handle only at system boundaries (see #CODE-STYLE)"

### Rule Writing Style vs. Actual Content

`always.md` (lines 86-96) says:

> **Prefer:** "Check if CLAUDE.md exists in the repo root"
> **Avoid:** Bash one-liners with `ls` or `test`

Yet the same file (lines 21-23, 46-48) and all four dialogue templates contain extensive bash scripts as the primary instructions. The dialogue templates are predominantly bash one-liners wrapped in code blocks.

**Recommendation:** Clarify that the "Rule Writing Style" section applies to rule *instructions* (the prose the agent follows), while code blocks are examples of what to run. The current wording is ambiguous.

### Frontmatter in .md Files

`dir-cursor.mdc` "Never Do" section (line 72) says:

> Use frontmatter in plain `.md` rules

But `always.md`, `etiquette.md`, `init.md`, `code-style.md`, `context-gathering.md`, `command-discovery.md`, `cursor-config.md`, `workflow.md`, `git-worktree.md`, `ask-question.md`, and all dialogue templates have YAML frontmatter (`tag:`, `scope:`). These are all `.md` files.

**Recommendation:** Either remove frontmatter from `.md` files (since Cursor doesn't auto-load them based on it), or update `dir-cursor.mdc` to clarify that `.md` reference docs may use `tag`/`scope` frontmatter for organizational purposes but not `alwaysApply`/`globs`.

---

## 3. Missing References

### ml-hpc.md Does Not Exist

`cursor-config.md` tag reference (line 36) lists:

> `#ML-HPC` | `ml-hpc.md` | ML/HPC patterns (reference doc)

This file is referenced by:
- `core.mdc:49` - "See #ML-HPC for Slurm, WandB, and training safety rules"
- `always.md:120` - "See #ML-HPC for Slurm, WandB, and training infrastructure patterns"
- `context-gathering.md:55` - "See #ML-HPC for WandB environment gathering patterns"
- `workflow.md:57` - "See #ML-HPC for Slurm, WandB, training, and sweep patterns"
- `morning-standup.md:83` - "See #ML-HPC for overnight job analysis patterns"

But `ml-hpc.md` does not exist in the repository.

**Recommendation:** Either create `ml-hpc.md` or remove all dangling references to it.

### Command Files Not Present

`etiquette.md` lists 18+ commands (git/commit, git/pr, session/handover, etc.) and `cursor-config.md` lists 24 command paths. None of these command files exist in this repository. This is presumably intentional (they live in `~/.cursor/commands/`), but it makes this repo incomplete as a standalone reference.

**Recommendation:** Add a note in the README or `cursor-config.md` clarifying that command and agent files are maintained separately and this repo contains only the rules layer.

---

## 4. Overly Prescriptive Rules

Several rules in `core.mdc` are stated as absolutes but have legitimate exceptions that aren't acknowledged:

| Rule | Stated As | Legitimate Exceptions |
|------|-----------|----------------------|
| No `rm` anything | "Data loss risk" → "mv to backup location" | Deleting known temp files, build artifacts, `__pycache__`, `.pyc` |
| No `sleep` | "Wastes time, can hang" | Rate limiting, polling with backoff, integration test timing |
| No `sed` | "Error-prone, no diff" | CI pipelines, automation scripts, non-interactive contexts |
| No try/catch | "Hides errors" | System boundaries (contradicted by code-style.md) |
| No unbounded scans | "Hangs forever" | Small repos where `find .` is appropriate |

**Recommendation:** Add "Unless" qualifiers or move toward guidance rather than absolutes. Example: "Avoid `rm` for user data — OK for build artifacts and temp files."

### "Always End With a Question"

Requiring every response to end with a question can feel forced when a task is definitively complete (e.g., "Done. The file has been committed." doesn't need a question). Consider softening to "prefer" or adding an exception for terminal actions.

---

## 5. Structural Issues

### core.mdc Is Too Sparse

`core.mdc` is the only auto-loaded rule (via `alwaysApply: true`), making it the only file guaranteed to be read. But it's 74 lines and defers heavily to `#ALWAYS`, `#ETIQUETTE`, and `#CODE-STYLE` — which are `.md` files that are NOT auto-loaded.

This means the auto-loaded behavior depends on the agent voluntarily reading reference docs. If the agent doesn't follow up on the `#TAG` references, it misses most of the system.

**Recommendation:** Either make `core.mdc` more self-contained (at the cost of some duplication), or convert the most critical reference docs (`always.md`, `etiquette.md`) to `.mdc` with `alwaysApply: true`.

### Three "Core" Files With Overlapping Scope

`core.mdc`, `always.md`, and `etiquette.md` all claim to be foundational:

| File | Self-description |
|------|-----------------|
| `core.mdc` | "These rules apply to EVERY interaction. They are non-negotiable." |
| `always.md` | "These rules apply to EVERY interaction, regardless of context." |
| `etiquette.md` | "These rules are non-negotiable and apply to ALL interactions." |

A newcomer cannot easily tell what's unique to each file vs. what's duplicated.

**Recommendation:** Clearly delineate responsibilities:
- `core.mdc` = machine-enforced constraints (auto-loaded, minimal, authoritative)
- `always.md` = operational procedures (what to check, how to document, workflow)
- `etiquette.md` = communication style and interaction patterns

---

## 6. Scope / Audience Assumptions

### Python/ML-Centric

The rules are heavily oriented toward Python/ML workflows:
- `code-style.md` references black/ruff (Python formatters)
- `dir-tests.mdc` is pytest-specific
- `dir-experiments.mdc` is ML-specific (WandB, sweeps, GPU)
- Examples throughout are Python
- References to uv, poetry, pyproject.toml

No guidance exists for JavaScript/TypeScript, Go, Rust, or other languages that a general Cursor user might work with.

**Recommendation:** If this is intentionally Python/ML-scoped, state that explicitly. If it's meant to be general-purpose, add language-agnostic alternatives or per-language conditional rules.

### Cursor-Coupled

The rules assume Cursor-specific features:
- `.mdc` frontmatter format
- `ask_question` tool
- `create_plan` tool
- Cursor file tools vs terminal distinction
- `.specstory/history/` directory

This is fine if the rules are only for Cursor, but limits portability to other AI-assisted editors or Claude Code.

---

## 7. Dialogue Templates

### Strengths
- Well-structured with clear "When to Use", "Gather", "Output Format", "Fallbacks", and "Follow-Up" sections
- Good use of fallback tables for edge cases
- Useful "Related" sections pointing to alternative commands

### Issues
- `micro-handover.md` line 36: `find . -name "*.py" ... | xargs ls -lt` is fragile with filenames containing spaces and may be slow on large repos
- Bash scripts in dialogue templates contradict the "Rule Writing Style" guidance in `always.md` favoring prose over bash
- `morning-standup.md` uses `pgrep -af python` which may produce noisy output on systems with many Python processes
- `worktree-handover.md` script (lines 42-51) uses `git worktree list --porcelain` piped through while-read loops with subshell git commands — complex and fragile

---

## 8. Minor Issues

| File | Issue |
|------|-------|
| `cursor-config.md:201` | References `claude-opus-4-20250514` model — will become outdated as models are updated |
| `always.md:228-230` | "Chat Heading Format" (lowercase, underscores, 1-2 words) is an oddly specific micro-rule for a global rules file |
| `code-style.md:87-89` | Commit tag list includes both `[fix]` and `[bug]` — unclear how these differ |
| `dir-cursor.mdc:18` | Lists `rules/` with both `.md` and `.mdc` extensions but the purpose column says "Always-active behavior" which is only true for `.mdc` |
| `context-gathering.md:93-106` | Agent Name Derivation uses `$CURSOR_COMMAND` env var that may not exist in all contexts |

---

## 9. Positive Observations

- **Tag-based cross-referencing** (`#TAG`, `@command`) is a good convention that enables modularity
- **Directory-conditional rules** via globs is well-designed — different rules for src/, tests/, experiments/ is practical
- **Safety table** in `core.mdc` is a quick, scannable format
- **Context hierarchy** (command > CLAUDE.md > global rules > .specstory > general) is well-thought-out
- **Handover key format** (`HO-{date}-{time}-{hash}`) enables session tracking
- **Worktree patterns** are thorough and cover a real pain point in multi-feature development
- **"Learn from Mistakes"** section in `always.md` is a genuinely useful feedback loop
- **Error handling philosophy** in `code-style.md` with the boundary/internal/research distinction is good (just needs to be consistent with `core.mdc`)
- **Atomic commits** guidance with `git add -p` and the "embrace hunks" philosophy is solid

---

## 10. Recommended Priority Actions

1. **Deduplicate** — Establish single authoritative locations for repeated content (safety, response style, follow-up questions, indentation limits). Other files should reference, not restate.
2. **Fix core.mdc try/catch entry** — Add the system-boundary exception to match `code-style.md`.
3. **Create or remove ml-hpc.md** — Five files reference it; it doesn't exist.
4. **Clarify .md frontmatter policy** — Either remove frontmatter from `.md` files or update `dir-cursor.mdc` to allow it.
5. **Soften absolute rules** — Add qualifiers to `rm`, `sleep`, `sed`, `try/catch` rules where exceptions are reasonable.
6. **Differentiate the three core files** — Make the unique purpose of `core.mdc` vs `always.md` vs `etiquette.md` explicit and non-overlapping.
