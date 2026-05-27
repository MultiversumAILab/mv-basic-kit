#!/bin/sh
set -eu

# -------- configurable defaults --------
MV_HOST_LAN_IP="${MV_HOST_LAN_IP:-172.16.20.20}"
MV_REPO_NAME="${MV_REPO_NAME:-wlalq01.git}"
MV_GIT_ROOT="${MV_GIT_ROOT:-$HOME/shared-git}"
MV_WORKTREE_DIR="${MV_WORKTREE_DIR:-$HOME/Documents/wlalq01-presentation}"
MV_SOURCE_DIR="${MV_SOURCE_DIR:-$HOME/2026-05-15_Internationales-Industrieunternehmen_Angebot_VERTRAULICH_v1}"
MV_DEPLOY_DIR="${MV_DEPLOY_DIR:-$HOME/.docker/cagent/working_directories/docker-gordon-v4/8336e58d-392e-4e8e-afa9-cf6338e421fb/default/nginx_html/WLALQ01}"
MV_DEPLOY_URL_PATH="${MV_DEPLOY_URL_PATH:-/WLALQ01/}"

MV_BARE_REPO="$MV_GIT_ROOT/$MV_REPO_NAME"
MV_LAUNCH_AGENT_LABEL="${MV_LAUNCH_AGENT_LABEL:-com.ai_lab_team.${MV_REPO_NAME%.git}.git-daemon}"
MV_LAUNCH_AGENT_PLIST="$HOME/Library/LaunchAgents/$MV_LAUNCH_AGENT_LABEL.plist"
MV_GIT_DAEMON_RUNNER="$MV_GIT_ROOT/bin/run-git-daemon-${MV_REPO_NAME%.git}.sh"
MV_GIT_DAEMON_LOG="$MV_GIT_ROOT/git-daemon-${MV_REPO_NAME%.git}.log"
MV_GIT_DAEMON_ERR="$MV_GIT_ROOT/git-daemon-${MV_REPO_NAME%.git}.err"

echo "[1/7] Prepare directories"
mkdir -p "$MV_GIT_ROOT" "$MV_WORKTREE_DIR" "$MV_DEPLOY_DIR" "$MV_GIT_ROOT/bin" "$HOME/Library/LaunchAgents"

echo "[2/7] Create bare repository if missing"
if [ ! -d "$MV_BARE_REPO" ]; then
  git init --bare "$MV_BARE_REPO"
fi
git -C "$MV_BARE_REPO" symbolic-ref HEAD refs/heads/main

echo "[3/7] Sync source deck into worktree"
if [ -d "$MV_SOURCE_DIR" ]; then
  rsync -a --delete --exclude ".git" "$MV_SOURCE_DIR"/ "$MV_WORKTREE_DIR"/
else
  echo "WARN: MV_SOURCE_DIR not found: $MV_SOURCE_DIR"
  echo "WARN: continuing with current MV_WORKTREE_DIR contents."
fi

echo "[4/7] Initialize worktree and push initial state"
if [ ! -d "$MV_WORKTREE_DIR/.git" ]; then
  git -C "$MV_WORKTREE_DIR" init -b main
fi

if git -C "$MV_WORKTREE_DIR" remote get-url origin >/dev/null 2>&1; then
  git -C "$MV_WORKTREE_DIR" remote set-url origin "$MV_BARE_REPO"
else
  git -C "$MV_WORKTREE_DIR" remote add origin "$MV_BARE_REPO"
fi

if ! git -C "$MV_WORKTREE_DIR" config --get user.name >/dev/null 2>&1; then
  git -C "$MV_WORKTREE_DIR" config user.name "mv-lan-host"
fi
if ! git -C "$MV_WORKTREE_DIR" config --get user.email >/dev/null 2>&1; then
  git -C "$MV_WORKTREE_DIR" config user.email "mv-lan-host@local.lan"
fi

git -C "$MV_WORKTREE_DIR" add .
if ! git -C "$MV_WORKTREE_DIR" diff --cached --quiet; then
  git -C "$MV_WORKTREE_DIR" commit -m "Initialize LAN collaboration repository"
fi
git -C "$MV_WORKTREE_DIR" push -u origin main

echo "[5/7] Install post-receive deploy hook"
cat > "$MV_BARE_REPO/hooks/post-receive" <<EOF
#!/bin/sh
set -eu

DEPLOY_DIR="$MV_DEPLOY_DIR"
TMP_DIR="\$(mktemp -d /tmp/${MV_REPO_NAME%.git}-deploy.XXXXXX)"
trap 'rm -rf "\$TMP_DIR"' EXIT

mkdir -p "\$DEPLOY_DIR"
GIT_DIR="\$(pwd)"
git --git-dir="\$GIT_DIR" archive main | tar -x -C "\$TMP_DIR"
rsync -a --delete "\$TMP_DIR"/ "\$DEPLOY_DIR"/
echo "[${MV_REPO_NAME%.git}] deployed to \$DEPLOY_DIR"
EOF
chmod +x "$MV_BARE_REPO/hooks/post-receive"

echo "[6/7] Install git daemon runner and launch agent"
cat > "$MV_GIT_DAEMON_RUNNER" <<EOF
#!/bin/sh
set -eu
exec /usr/bin/git daemon \\
  --reuseaddr \\
  --base-path="$MV_GIT_ROOT" \\
  --export-all \\
  --enable=receive-pack \\
  --informative-errors \\
  --verbose \\
  --listen=0.0.0.0 \\
  --port=9418 \\
  "$MV_GIT_ROOT"
EOF
chmod +x "$MV_GIT_DAEMON_RUNNER"

cat > "$MV_LAUNCH_AGENT_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$MV_LAUNCH_AGENT_LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>$MV_GIT_DAEMON_RUNNER</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>WorkingDirectory</key>
  <string>$MV_GIT_ROOT</string>
  <key>StandardOutPath</key>
  <string>$MV_GIT_DAEMON_LOG</string>
  <key>StandardErrorPath</key>
  <string>$MV_GIT_DAEMON_ERR</string>
</dict>
</plist>
EOF

launchctl unload "$MV_LAUNCH_AGENT_PLIST" 2>/dev/null || true
launchctl load "$MV_LAUNCH_AGENT_PLIST"

echo "[7/7] Verify"
sleep 1
git ls-remote "git://127.0.0.1:9418/$MV_REPO_NAME" >/dev/null
curl -fsS -I "http://127.0.0.1$MV_DEPLOY_URL_PATH" >/dev/null

echo "OK"
echo "LAN remote: git://$MV_HOST_LAN_IP:9418/$MV_REPO_NAME"
echo "Live URL:    http://$MV_HOST_LAN_IP$MV_DEPLOY_URL_PATH"

