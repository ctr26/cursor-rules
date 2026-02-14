#!/usr/bin/env bash
set -euo pipefail

# Bundle rule files into a single portable markdown document.
# Usage: ./scripts/bundle.sh <profile> [--out <file>]
#
# Profiles live in profiles/<name>.txt — one filename per line.
# Frontmatter is stripped. Sections are separated by horizontal rules.

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROFILE=""
OUT=""

usage() {
  echo "Usage: $0 <profile> [--out <file>]"
  echo ""
  echo "Profiles:"
  for f in "$REPO_ROOT/profiles/"*.txt; do
    name="$(basename "$f" .txt)"
    desc="$(head -1 "$f" | sed -n 's/^# *//p')"
    printf "  %-16s %s\n" "$name" "$desc"
  done
  echo ""
  echo "Options:"
  echo "  --out <file>   Write to file instead of stdout"
  echo "  --list         List files that would be included"
  exit 1
}

# Parse args
LIST_ONLY=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --out)   OUT="$2"; shift 2 ;;
    --list)  LIST_ONLY=true; shift ;;
    --help|-h) usage ;;
    -*)      echo "Unknown option: $1" >&2; usage ;;
    *)       PROFILE="$1"; shift ;;
  esac
done

if [[ -z "$PROFILE" ]]; then
  echo "Error: profile required" >&2
  usage
fi

PROFILE_FILE="$REPO_ROOT/profiles/${PROFILE}.txt"
if [[ ! -f "$PROFILE_FILE" ]]; then
  echo "Error: profile not found: $PROFILE_FILE" >&2
  usage
fi

# Read file list from profile (skip comments and blank lines)
FILES=()
while IFS= read -r line; do
  line="${line%%#*}"        # strip inline comments
  line="${line// /}"        # trim whitespace
  [[ -z "$line" ]] && continue
  FILES+=("$line")
done < "$PROFILE_FILE"

if $LIST_ONLY; then
  for f in "${FILES[@]}"; do
    echo "$f"
  done
  exit 0
fi

# Strip YAML frontmatter from a file
strip_frontmatter() {
  local file="$1"
  awk '
    BEGIN { in_front=0; seen_end=0 }
    NR==1 && /^---/ { in_front=1; next }
    in_front && /^---/ { in_front=0; seen_end=1; next }
    in_front { next }
    # skip blank line right after frontmatter
    seen_end && /^$/ { seen_end=0; next }
    { seen_end=0; print }
  ' "$file"
}

# Build the bundle
bundle() {
  local profile_desc
  profile_desc="$(head -1 "$PROFILE_FILE" | sed -n 's/^# *//p')"

  cat <<HEADER
# AI Assistant Rules — ${PROFILE} profile

> ${profile_desc}
> Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)
> Source: $(cd "$REPO_ROOT" && git remote get-url origin 2>/dev/null || echo "local")
> Commit: $(cd "$REPO_ROOT" && git rev-parse --short HEAD 2>/dev/null || echo "unknown")

HEADER

  local count=0
  for f in "${FILES[@]}"; do
    local filepath="$REPO_ROOT/$f"
    if [[ ! -f "$filepath" ]]; then
      echo "Warning: skipping missing file: $f" >&2
      continue
    fi

    if [[ $count -gt 0 ]]; then
      echo ""
      echo "---"
      echo ""
    fi

    strip_frontmatter "$filepath"
    count=$((count + 1))
  done

  cat <<FOOTER

---

*${count} rule files bundled from ${PROFILE} profile.*
FOOTER
}

if [[ -n "$OUT" ]]; then
  mkdir -p "$(dirname "$OUT")"
  bundle > "$OUT"
  echo "Wrote: $OUT ($(wc -c < "$OUT") bytes, $(wc -l < "$OUT") lines)" >&2
else
  bundle
fi
