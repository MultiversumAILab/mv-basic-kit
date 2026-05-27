#!/bin/sh
set -eu

MV_HOST_LAN_IP="${MV_HOST_LAN_IP:-172.16.20.20}"
MV_REPO_NAME="${MV_REPO_NAME:-wlalq01.git}"
MV_CLIENT_DIR="${MV_CLIENT_DIR:-$HOME/projects/${MV_REPO_NAME%.git}}"
MV_GIT_USER_NAME="${MV_GIT_USER_NAME:-}"
MV_GIT_USER_EMAIL="${MV_GIT_USER_EMAIL:-}"

REMOTE_URL="git://$MV_HOST_LAN_IP:9418/$MV_REPO_NAME"

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

echo "OK"
echo "Local repo: $MV_CLIENT_DIR"
echo "Remote:     $REMOTE_URL"
echo "Next:"
echo "  cd \"$MV_CLIENT_DIR\""
echo "  git add ."
echo "  git commit -m \"Update slides\""
echo "  git push origin main"

