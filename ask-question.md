---
tag: ASK-QUESTION
scope: global
---
# Structured Question Tool Enforcement

**STRICT RULE:** Use the structured question tool for ANY question with discrete options.

> Cursor: `ask_question` · Claude Code: `AskUserQuestion`

---

## When to Use (MUST)

| Situation | Example |
|-----------|---------|
| Scope narrowing | "Which file should I focus on?" |
| Implementation choice | "Use approach A, B, or C?" |
| Yes/No confirmation | "Should I proceed with X?" |
| Configuration selection | "Which config option?" |
| Plan approval alternatives | "Modify plan or execute?" |
| Error resolution | "Fix with option A or B?" |

---

## When Plain Text Is OK

| Situation | Why |
|-----------|-----|
| Open-ended clarification | No discrete options exist |
| Follow-up within flow | Already mid-conversation |
| Single obvious action | No choice needed |
| Reporting results | Information, not decision |

---

## Format Requirements

When using the structured question tool:

1. **Clear title** - What decision is being made
2. **2-6 options** - Not too many, not too few
3. **First option = default** - If user doesn't answer, assume first
4. **Mutually exclusive** - Unless multiple selection is enabled

---

## Anti-Patterns (NEVER DO)

```markdown
# BAD: Discrete options in plain text
"Would you like me to:
A) Fix the bug
B) Add a test first
C) Investigate more

Let me know which you prefer."
```

Instead, use the structured question tool to present these as selectable options.

---

## Planning Mode (EXTRA STRICT)

When in planning mode:

1. **All scope questions** → structured question tool
2. **All implementation alternatives** → structured question tool
3. **All clarifications with options** → structured question tool

**Never interpret "yes" or "sounds good" as plan approval.** Only the explicit plan approval action exits planning mode.

---

## Integration

All agents and commands should reference this rule. Add to your "Before Any Action" checklist:

```
✓ If I'm about to ask a question with options, use the structured question tool
```
