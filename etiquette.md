---
tag: ETIQUETTE
scope: global
---
# Agent Etiquette & Rules

Communication style and interaction patterns. For safety constraints, see #CORE. For operational procedures, see #ALWAYS.

---

## First: Read Init

Before starting any session, read #INIT to:
- Identify your role (command/agent/general)
- Understand context hierarchy
- Know what to check before acting

---

## Safety Rules

**See #CORE** for the authoritative safety table.

---

## Code Style & Git Workflow

**See #CODE-STYLE** and **#WORKFLOW**.

Core principles:
- Write human-like code (avoid LLM patterns)
- Fail fast (research code needs visibility)
- Never commit/push without explicit request

---

## Available Commands

| Command | Purpose |
|---------|---------|
| **git/commit** | Committing code (when explicitly asked) |
| **git/pr** | Splitting changes into PRs using worktrees |
| **git/cherry-pick** | Cherry-picking commits between branches |
| **git/worktrees** | Discover worktrees and visibility context |
| **git/worktree** | Create new worktree for feature isolation |
| **session/continue** | Planning mode context recovery |
| **session/agentic** | Autonomous execution with context recovery |
| **session/handover** | Session handover with unique keys |
| **session/eod** | End of day summary and handover |
| **session/summarize** | Generate copy-paste startup prompt |
| **session/catch-up** | Read-only context ingestion |
| **session/read-only** | Observer mode (no edits) |
| **sync/remote** | Syncing cursor config to remote servers |
| **sync/chezmoi** | Chezmoi dotfile sync management |
| **config/agentic** | Audit/maintain repo-local .cursor/ config |
| **config/review** | Review cursor config for inconsistencies and improvements |
| **update** | General status check across everything |
| **ideate** | Generate improvement ideas from codebase |
| **note** | Persist notes for this repo (CLAUDE/notes/) |
| **todo** | Manage todos for this repo |
| **slack** | Draft Slack replies about your codebase |
| **audit** | Committee review of cursor config |

**Suggest commands when relevant:** "I can help with that using [command] - want me to switch?"

---

## Response Style

### Do
- Be concise and direct
- Show commands before running them
- Ask clarifying questions if ambiguous
- End with a follow-up question (see #ALWAYS for examples)

### Don't
- Over-explain or add unnecessary commentary
- Add excessive comments to code
- Create documentation unless asked
- Use emojis unless the context calls for it

---

## Asking Questions

**Prefer the `ask_question` tool** for structured choices - it creates clickable buttons.

**Use `ask_question` for:**
- Multiple-choice decisions (A/B/C options)
- Yes/no confirmations
- Configuration selections
- Any question with discrete, predefined answers

**Use plain text for:**
- Open-ended questions requiring explanation
- Follow-up clarifications within a conversation flow

**Fallback:** If using plain text for options, prefix with letters (A, B, C) so users can respond quickly.

See #ASK-QUESTION for enforcement details.
