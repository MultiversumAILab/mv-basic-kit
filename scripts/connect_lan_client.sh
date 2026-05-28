#!/bin/sh
set -eu

MV_HOST_LAN_IP="${MV_HOST_LAN_IP:-172.16.20.20}"
MV_REPO_NAME="${MV_REPO_NAME:-wlalq01.git}"
MV_CLIENT_DIR="${MV_CLIENT_DIR:-$HOME/projects/${MV_REPO_NAME%.git}}"
MV_GIT_USER_NAME="${MV_GIT_USER_NAME:-}"
MV_GIT_USER_EMAIL="${MV_GIT_USER_EMAIL:-}"
MV_PROJECT_MODE="${MV_PROJECT_MODE:-}"
MV_PROJECT_NAME="${MV_PROJECT_NAME:-}"
MV_NONINTERACTIVE="${MV_NONINTERACTIVE:-0}"

REMOTE_URL="git://$MV_HOST_LAN_IP:9418/$MV_REPO_NAME"
PPT_DIR_REL="ppt"

slugify() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9._-]/-/g' | sed 's/-\{2,\}/-/g' | sed 's/^-//' | sed 's/-$//'
}

list_projects() {
  if [ -d "$MV_CLIENT_DIR/$PPT_DIR_REL" ]; then
    find "$MV_CLIENT_DIR/$PPT_DIR_REL" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
  fi
}

echo "[1/4] Check remote availability: $REMOTE_URL"
git ls-remote "$REMOTE_URL" >/dev/null

echo "[2/4] Clone if missing"
if [ -d "$MV_CLIENT_DIR/.git" ]; then
  echo "Repo already exists: $MV_CLIENT_DIR"
  git -C "$MV_CLIENT_DIR" remote set-url origin "$REMOTE_URL"
else
  mkdir -p "$(dirname "$MV_CLIENT_DIR")"
  git clone "$REMOTE_URL" "$MV_CLIENT_DIR"
fi

echo "[3/4] Configure identity (optional)"
if [ -n "$MV_GIT_USER_NAME" ]; then
  git -C "$MV_CLIENT_DIR" config user.name "$MV_GIT_USER_NAME"
fi
if [ -n "$MV_GIT_USER_EMAIL" ]; then
  git -C "$MV_CLIENT_DIR" config user.email "$MV_GIT_USER_EMAIL"
fi

echo "[4/4] Pull latest main"
git -C "$MV_CLIENT_DIR" checkout main
git -C "$MV_CLIENT_DIR" pull --rebase origin main

mkdir -p "$MV_CLIENT_DIR/$PPT_DIR_REL"

PROJECT_NAME=""
MODE="$MV_PROJECT_MODE"

if [ "$MV_NONINTERACTIVE" != "1" ]; then
  echo
  echo "Projektmodus wählen:"
  echo "  1) Neues Projekt anlegen (/ppt/<name>/)"
  echo "  2) Bestehendes Projekt bearbeiten"
  printf "Auswahl [1/2]: "
  read -r answer
  case "$answer" in
    1) MODE="new" ;;
    2) MODE="existing" ;;
    *) echo "Ungültige Auswahl. Bitte erneut starten."; exit 1 ;;
  esac
fi

case "$MODE" in
  new)
    if [ -n "$MV_PROJECT_NAME" ]; then
      raw_name="$MV_PROJECT_NAME"
    else
      printf "Name für neuen Projektordner: "
      read -r raw_name
    fi
    PROJECT_NAME="$(slugify "$raw_name")"
    if [ -z "$PROJECT_NAME" ]; then
      echo "Projektname ungültig."
      exit 1
    fi
    mkdir -p "$MV_CLIENT_DIR/$PPT_DIR_REL/$PROJECT_NAME"
    if [ ! -f "$MV_CLIENT_DIR/$PPT_DIR_REL/$PROJECT_NAME/index.html" ]; then
      cat > "$MV_CLIENT_DIR/$PPT_DIR_REL/$PROJECT_NAME/index.html" <<EOF
<!DOCTYPE html>
<html lang="de">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$PROJECT_NAME</title>
</head>
<body>
  <h1>$PROJECT_NAME</h1>
  <p>Startseite des Projekts. Ersetze diesen Inhalt durch die Präsentation.</p>
</body>
</html>
EOF
    fi
    ;;
  existing)
    if [ -n "$MV_PROJECT_NAME" ]; then
      PROJECT_NAME="$(slugify "$MV_PROJECT_NAME")"
    else
      projects="$(list_projects)"
      if [ -z "$projects" ]; then
        echo "Keine bestehenden Projekte gefunden. Bitte zuerst ein neues Projekt anlegen."
        exit 1
      fi
      echo
      echo "Bestehende Projekte:"
      i=1
      for p in $projects; do
        echo "  $i) $p"
        i=$((i + 1))
      done
      printf "Projekt-Nummer wählen: "
      read -r selection
      i=1
      for p in $projects; do
        if [ "$i" = "$selection" ]; then
          PROJECT_NAME="$p"
          break
        fi
        i=$((i + 1))
      done
    fi
    if [ -z "$PROJECT_NAME" ] || [ ! -d "$MV_CLIENT_DIR/$PPT_DIR_REL/$PROJECT_NAME" ]; then
      echo "Projekt nicht gefunden: $PROJECT_NAME"
      exit 1
    fi
    ;;
  *)
    if [ "$MV_NONINTERACTIVE" = "1" ]; then
      echo "MV_PROJECT_MODE muss 'new' oder 'existing' sein."
      exit 1
    fi
    ;;
esac

echo "OK"
echo "Local repo: $MV_CLIENT_DIR"
echo "Remote:     $REMOTE_URL"
if [ -n "$PROJECT_NAME" ]; then
  echo "Project:    $PROJECT_NAME"
  echo "Project dir: $MV_CLIENT_DIR/$PPT_DIR_REL/$PROJECT_NAME"
  echo "Live URL:   http://$MV_HOST_LAN_IP/ppt/$PROJECT_NAME/"
fi
echo "Next:"
if [ -n "$PROJECT_NAME" ]; then
  echo "  cd \"$MV_CLIENT_DIR/$PPT_DIR_REL/$PROJECT_NAME\""
else
  echo "  cd \"$MV_CLIENT_DIR\""
fi
echo "  git add ."
echo "  git commit -m \"Update slides\""
echo "  git push origin main"
