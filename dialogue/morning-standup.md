---
tag: DIALOGUE-STANDUP
scope: global
---
# Morning Standup Dialogue Template

Start of day orientation. Complements @session/eod for end of day.

---

## When to Use

- First thing in the morning
- Returning after days away
- Planning the day's work

---

## Gather

```bash
echo "=== Morning Standup ==="

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

# Yesterday's work
echo -e "\n--- Yesterday ---"
git log --oneline --since="yesterday 6am" --until="today 6am" 2>/dev/null | head -10
YESTERDAY_COMMITS=$(git log --oneline --since="yesterday 6am" --until="today 6am" 2>/dev/null | wc -l | tr -d ' ')
echo "Commits yesterday: $YESTERDAY_COMMITS"

# Current branch and state
echo -e "\n--- Current State ---"
git branch --show-current
git status --short
git stash list | head -3

# Background processes
echo -e "\n--- Background Processes ---"
pgrep -af python 2>/dev/null | grep -v "cursor\|code" | head -5
tmux list-sessions 2>/dev/null || echo "No tmux sessions"

# Today's priorities from CLAUDE.md
echo -e "\n--- Priorities ---"
if [ -f "$REPO_ROOT/CLAUDE.md" ]; then
  grep -E "^- \[ \]|^1\. \[ \]|^## Pending|^## Next|^## Today" "$REPO_ROOT/CLAUDE.md" 2>/dev/null | head -8
else
  echo "No CLAUDE.md - set priorities?"
fi

# Disk check
echo -e "\n--- Disk ---"
df -h / 2>/dev/null | tail -1
```

---

## Output Format

```markdown
## Morning Standup

**Date:** Monday, Jan 18, 2026
**Branch:** `feat/data-loader`

### Yesterday
- 5 commits on `feat/data-loader`
- Last: "abc123 [feat] add batch processing"

### Blockers
- None / [List blockers]

### Today's Priorities
1. [ ] [From CLAUDE.md pending items]
2. [ ] [Yesterday's incomplete work]
3. [ ] [Stashed changes to address]

### System Health
- Disk: 45% used
- Background: 2 processes running
```

> **ML/HPC users:** See #ML-HPC for overnight job analysis patterns.

---

## Priority Sources

Check these in order for today's priorities:

1. CLAUDE.md pending items (`- [ ]` checkboxes)
2. Yesterday's incomplete work
3. Stashed changes to address
4. EOD handover from previous day

---

## Fallbacks

| Missing | Show Instead |
|---------|--------------|
| No commits yesterday | "No commits yesterday" |
| No CLAUDE.md | "No priorities set - what's the focus?" |
| No background processes | "No processes running" |

---

## Follow-Up

| Situation | Question |
|-----------|----------|
| Has pending priorities | "Start with [first priority]?" |
| Has stashed changes | "Address the stashed changes first?" |
| Clean slate | "What's the focus for today?" |

---

## Related

| Need | Use Instead |
|------|-------------|
| End of day wrap-up | → @session/eod |
| Quick context recovery | → #DIALOGUE-CATCHUP |
| Full planning mode | → @session/continue |

