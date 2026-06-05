#!/usr/bin/env bash
# mv-basic-kit: Push local project to mv-code
# Usage: push.sh [project-name] [--private]
#
# Required env vars (set once in ~/.zshrc):
#   MV_PUSH_API_KEY   — Token vom Admin erhalten
#   MV_CODE_OWNER     — Dein Name (z.B. "max" oder "anna")
#
# Optional env vars:
#   MV_CODE_URL       — URL des mv-code servers (default: https://172.16.20.20/mv-code)
#   MV_VISIBILITY     — "public" | "private" (default: public)

set -euo pipefail

MV_CODE_URL="${MV_CODE_URL:-https://172.16.20.20/mv-code}"
OWNER="${MV_CODE_OWNER:-}"
TOKEN="${MV_PUSH_API_KEY:-}"
PROJECT_NAME="${1:-}"
VISIBILITY="public"

# Parse --private flag
for arg in "$@"; do
  if [[ "$arg" == "--private" ]]; then
    VISIBILITY="private"
  fi
done

# If project name not given, use current directory name
if [[ -z "$PROJECT_NAME" || "$PROJECT_NAME" == "--private" ]]; then
  PROJECT_NAME="$(basename "$(pwd)")"
fi

# Validation
if [[ -z "$TOKEN" ]]; then
  echo "❌ MV_PUSH_API_KEY ist nicht gesetzt."
  echo "   Füge folgendes zu deiner ~/.zshrc hinzu:"
  echo "   export MV_PUSH_API_KEY=\"<Token vom Admin>\""
  exit 1
fi

if [[ -z "$OWNER" ]]; then
  echo "❌ MV_CODE_OWNER ist nicht gesetzt."
  echo "   Füge folgendes zu deiner ~/.zshrc hinzu:"
  echo "   export MV_CODE_OWNER=\"dein-name\""
  exit 1
fi

if ! command -v curl &>/dev/null; then
  echo "❌ curl ist nicht installiert."
  exit 1
fi

if ! command -v zip &>/dev/null; then
  echo "❌ zip ist nicht installiert."
  exit 1
fi

echo "📦 Projekt: $PROJECT_NAME"
echo "👤 Owner:   $OWNER"
echo "🔒 Sichtbarkeit: $VISIBILITY"
echo "🌐 Server:  $MV_CODE_URL"
echo ""

# Create temp zip
TMP_ZIP="$(mktemp /tmp/mv-push-XXXXXX).zip"
trap 'rm -f "$TMP_ZIP"' EXIT

# Zip current directory, respecting .gitignore if git is available
if command -v git &>/dev/null && git rev-parse --git-dir &>/dev/null 2>&1; then
  echo "🗜  Erstelle ZIP (via git ls-files)..."
  git ls-files -z | xargs -0 zip -q "$TMP_ZIP" --
  # Include untracked non-ignored files too
  git ls-files --others --exclude-standard -z 2>/dev/null | xargs -0 zip -q "$TMP_ZIP" -- 2>/dev/null || true
else
  echo "🗜  Erstelle ZIP (alle Dateien)..."
  zip -qr "$TMP_ZIP" . \
    --exclude "*.DS_Store" \
    --exclude "node_modules/*" \
    --exclude ".git/*" \
    --exclude ".next/*" \
    --exclude "dist/*" \
    --exclude "*.log"
fi

ZIP_SIZE="$(du -sh "$TMP_ZIP" | cut -f1)"
echo "   Größe: $ZIP_SIZE"
echo ""
echo "🚀 Upload läuft..."

BODY_FILE="$(mktemp)"
curl -sk -X POST "${MV_CODE_URL}/api/v1/push" \
  -H "Authorization: Bearer ${TOKEN}" \
  -F "owner=${OWNER}" \
  -F "project=${PROJECT_NAME}" \
  -F "visibility=${VISIBILITY}" \
  -F "files=@${TMP_ZIP};type=application/zip" \
  --output "$BODY_FILE" \
  --write-out "%{http_code}" >"${BODY_FILE}.code" 2>/dev/null
HTTP_CODE="$(cat "${BODY_FILE}.code")"
BODY="$(cat "$BODY_FILE")"
rm -f "$BODY_FILE" "${BODY_FILE}.code"

if [[ "$HTTP_CODE" == "200" ]]; then
  PROJECT_URL="$(echo "$BODY" | python3 -c "import sys,json; d=json.loads(sys.stdin.read()); print(d.get('projectUrl',''))" 2>/dev/null || echo "")"
  echo "✅ Upload erfolgreich!"
  echo ""
  echo "🔗 Projekt-URL: $PROJECT_URL"
  echo ""
  echo "Das Projekt ist jetzt in mv-code sichtbar."
elif [[ "$HTTP_CODE" == "401" ]]; then
  echo "❌ Fehler 401: Token ungültig. Überprüfe MV_PUSH_API_KEY."
  exit 1
elif [[ "$HTTP_CODE" == "413" ]]; then
  echo "❌ Fehler 413: ZIP zu groß (max. 50 MB)."
  exit 1
else
  echo "❌ Fehler $HTTP_CODE: $BODY"
  exit 1
fi
