#!/usr/bin/env bash
# Render README.md from template/README.template.md.
# Mechanical replacements only. Content tokens stay for the agent to fill.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: render.sh --owner-repo OWNER/REPO [options]

Options:
  --owner-repo OWNER/REPO   Target repo slug (required)
  --branch NAME             Default branch (default: main)
  --target-dir DIR          Where to write README.md (default: .)
  --template FILE           Template to use (default: template/README.template.md
                            relative to this script, else ./template/README.template.md)
  --preview-url URL         Override {{PREVIEW_URL}} (default: base v1.0.0 preview.jpg)
  --holder NAME             LICENSE holder (default: git config user.name)
  --year YYYY               LICENSE year (default: current year)
  --help                    Show this help
EOF
}

OWNER_REPO=""
BRANCH="main"
TARGET_DIR="."
TEMPLATE=""
PREVIEW_URL="https://raw.githubusercontent.com/NikolaM-Dev/base-repo_tmpl/v1.0.0/docs/assets/preview.jpg"
HOLDER=""
YEAR="$(date +%Y)"

while [[ $# -gt 0 ]]; do
  case "$1" in
  --owner-repo)
    OWNER_REPO="${2:?}"
    shift 2
    ;;
  --branch)
    BRANCH="${2:?}"
    shift 2
    ;;
  --target-dir)
    TARGET_DIR="${2:?}"
    shift 2
    ;;
  --template)
    TEMPLATE="${2:?}"
    shift 2
    ;;
  --preview-url)
    PREVIEW_URL="${2:?}"
    shift 2
    ;;
  --holder)
    HOLDER="${2:?}"
    shift 2
    ;;
  --year)
    YEAR="${2:?}"
    shift 2
    ;;
  --help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown flag: $1" >&2
    usage >&2
    exit 1
    ;;
  esac
done

if [[ -z "$OWNER_REPO" ]]; then
  echo "Missing --owner-repo OWNER/REPO" >&2
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "$TEMPLATE" ]]; then
  if [[ -f "$SCRIPT_DIR/README.template.md" ]]; then
    TEMPLATE="$SCRIPT_DIR/README.template.md"
  else
    TEMPLATE="$SCRIPT_DIR/../template/README.template.md"
  fi
  if [[ ! -f "$TEMPLATE" ]]; then
    TEMPLATE="./template/README.template.md"
  fi
fi

REPO_NAME="${OWNER_REPO##*/}"
OUT="$TARGET_DIR/README.md"
mkdir -p "$TARGET_DIR"
cp "$TEMPLATE" "$OUT"

replace() {
  python3 - "$1" "$2" "$3" <<'EOF'
import sys
path, old, new = sys.argv[1], sys.argv[2], sys.argv[3]
s = open(path, encoding="utf-8").read()
s = s.replace(old, new)
open(path, "w", encoding="utf-8").write(s)
EOF
}

replace "$OUT" "{{OWNER_REPO}}" "$OWNER_REPO"
replace "$OUT" "{{REPO_NAME}}" "$REPO_NAME"
replace "$OUT" "{{DEFAULT_BRANCH}}" "$BRANCH"
replace "$OUT" "{{PREVIEW_URL}}" "$PREVIEW_URL"

# LICENSE holder update when LICENSE exists next to output.
if [[ -f "$TARGET_DIR/LICENSE" ]]; then
  if [[ -z "$HOLDER" ]]; then
    HOLDER="$(git config user.name 2>/dev/null || true)"
  fi
  if [[ -n "$HOLDER" ]]; then
    python3 - "$TARGET_DIR/LICENSE" "$HOLDER" "$YEAR" <<'EOF'
import sys, re
path, holder, year = sys.argv[1], sys.argv[2], sys.argv[3]
s = open(path, encoding="utf-8").read()
s2 = re.sub(r"Copyright \(c\) \d{4} .*", f"Copyright (c) {year} {holder}", s, count=1)
open(path, "w", encoding="utf-8").write(s2)
EOF
  else
    echo "WARN: no holder found, LICENSE untouched" >&2
  fi
fi

echo "Wrote $OUT for $OWNER_REPO (branch $BRANCH)"
# List remaining content tokens for the agent to fill.
LEFT="$(grep -o '{{[A-Z_]*}}' "$OUT" | sort -u || true)"
if [[ -n "$LEFT" ]]; then
  echo "Remaining content tokens:"
  echo "$LEFT"
else
  echo "No tokens remain."
fi
