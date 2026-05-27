#!/bin/sh
set -eu

# -------- configurable defaults --------
MV_HOST_LAN_IP="${MV_HOST_LAN_IP:-172.16.20.20}"
MV_REPO_NAME="${MV_REPO_NAME:-wlalq01.git}"
MV_GIT_ROOT="${MV_GIT_ROOT:-$HOME/shared-git}"
MV_WORKTREE_DIR="${MV_WORKTREE_DIR:-$HOME/Documents/wlalq01-presentation}"
MV_SOURCE_DIR="${MV_SOURCE_DIR:-$HOME/2026-05-15_Internationales-Industrieunternehmen_Angebot_VERTRAULICH_v1}"
MV_NGINX_HTML_ROOT="${MV_NGINX_HTML_ROOT:-$HOME/.docker/cagent/working_directories/docker-gordon-v4/8336e58d-392e-4e8e-afa9-cf6338e421fb/default/nginx_html}"

MV_BARE_REPO="$MV_GIT_ROOT/$MV_REPO_NAME"
MV_PPT_ROOT="$MV_NGINX_HTML_ROOT/ppt"
MV_REPO_SLUG="${MV_REPO_NAME%.git}"

MV_LAUNCH_AGENT_LABEL="${MV_LAUNCH_AGENT_LABEL:-com.ai_lab_team.${MV_REPO_SLUG}.git-daemon}"
MV_LAUNCH_AGENT_PLIST="$HOME/Library/LaunchAgents/$MV_LAUNCH_AGENT_LABEL.plist"
MV_GIT_DAEMON_RUNNER="$MV_GIT_ROOT/bin/run-git-daemon-${MV_REPO_SLUG}.sh"
MV_GIT_DAEMON_LOG="$MV_GIT_ROOT/git-daemon-${MV_REPO_SLUG}.log"
MV_GIT_DAEMON_ERR="$MV_GIT_ROOT/git-daemon-${MV_REPO_SLUG}.err"
MV_PPT_INDEX_RENDERER="$MV_GIT_ROOT/bin/render-ppt-index.sh"

echo "[1/8] Prepare directories"
mkdir -p "$MV_GIT_ROOT" "$MV_WORKTREE_DIR" "$MV_PPT_ROOT" "$MV_GIT_ROOT/bin" "$HOME/Library/LaunchAgents"

echo "[2/8] Create bare repository if missing"
if [ ! -d "$MV_BARE_REPO" ]; then
  git init --bare "$MV_BARE_REPO"
fi
git -C "$MV_BARE_REPO" symbolic-ref HEAD refs/heads/main

echo "[3/8] Sync source deck into worktree"
if [ -d "$MV_SOURCE_DIR" ]; then
  rsync -a --delete --exclude ".git" "$MV_SOURCE_DIR"/ "$MV_WORKTREE_DIR"/
else
  echo "WARN: MV_SOURCE_DIR not found: $MV_SOURCE_DIR"
  echo "WARN: continuing with current MV_WORKTREE_DIR contents."
fi

echo "[4/8] Initialize worktree and push initial state"
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

echo "[5/8] Install PPT index renderer"
cat > "$MV_PPT_INDEX_RENDERER" <<EOF
#!/bin/sh
set -eu

NGINX_HTML_ROOT="\${NGINX_HTML_ROOT:-$MV_NGINX_HTML_ROOT}"
PPT_ROOT="\$NGINX_HTML_ROOT/ppt"
INDEX_FILE="\$PPT_ROOT/index.html"
TMP_FILE="\$(mktemp /tmp/ppt-index.XXXXXX)"
ENTRIES_FILE="\$(mktemp /tmp/ppt-entries.XXXXXX)"
trap 'rm -f "\$TMP_FILE" "\$ENTRIES_FILE"' EXIT

mkdir -p "\$PPT_ROOT"

find "\$PPT_ROOT" -mindepth 3 -maxdepth 3 -type f -name index.html | while IFS= read -r file; do
  rel="\${file#\$PPT_ROOT/}"
  user="\${rel%%/*}"
  rest="\${rel#*/}"
  project="\${rest%%/*}"
  url="/ppt/\$user/\$project/"
  mtime="\$(stat -f '%Sm' -t '%Y-%m-%d %H:%M' "\$file" 2>/dev/null || date '+%Y-%m-%d %H:%M')"
  printf '%s|%s|%s|%s\\n' "\$user" "\$project" "\$mtime" "\$url"
done | sort -t '|' -k1,1 -k2,2 > "\$ENTRIES_FILE"

cat > "\$TMP_FILE" <<'HTML_TOP'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Multiversum - PPT Collaboration Index</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    :root {
      --dark: #191919;
      --dark-card: #222222;
      --dark-hover: #2a2a2a;
      --accent: #f2ff62;
      --accent-dim: rgba(242, 255, 98, 0.15);
      --light: #f7f7f5;
      --gray: #363636;
      --gray-mid: #4f4f4f;
      --gray-text: #999;
      --white: #ffffff;
    }
    body {
      font-family: -apple-system, 'Segoe UI', Helvetica, Arial, sans-serif;
      background: var(--dark);
      color: var(--light);
      min-height: 100vh;
    }
    .page-wrapper {
      max-width: 1280px;
      margin: 0 auto;
      padding: 40px 30px 60px;
    }
    .header {
      display: flex;
      align-items: center;
      gap: 24px;
      margin-bottom: 16px;
    }
    .header img { height: 52px; width: auto; }
    .header-text h1 {
      font-size: 1.8em;
      font-weight: 700;
      letter-spacing: -0.02em;
      color: var(--white);
    }
    .header-text p {
      font-size: 0.95em;
      color: var(--gray-text);
      margin-top: 2px;
    }
    .divider {
      height: 1px;
      background: var(--gray);
      margin: 24px 0 36px;
    }
    .section-label {
      font-size: 0.75em;
      font-weight: 600;
      letter-spacing: 0.12em;
      text-transform: uppercase;
      color: var(--accent);
      margin-bottom: 18px;
    }
    .services-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 20px;
      margin-bottom: 48px;
    }
    .service-card {
      background: var(--dark-card);
      border: 1px solid var(--gray);
      border-radius: 12px;
      padding: 24px 22px;
      text-decoration: none;
      color: inherit;
      display: flex;
      flex-direction: column;
      transition: border-color 0.25s ease, background 0.25s ease, transform 0.2s ease;
      min-height: 170px;
    }
    .service-card:hover {
      border-color: var(--accent);
      background: var(--dark-hover);
      transform: translateY(-3px);
    }
    .card-top {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 10px;
    }
    .card-icon {
      font-size: 1.3em;
      width: 38px;
      height: 38px;
      display: flex;
      align-items: center;
      justify-content: center;
      background: var(--accent-dim);
      border-radius: 10px;
      flex-shrink: 0;
    }
    .card-top h2 {
      font-size: 1.07em;
      font-weight: 600;
      color: var(--white);
      line-height: 1.2;
    }
    .service-card p {
      color: var(--gray-text);
      font-size: 0.88em;
      line-height: 1.5;
      flex: 1;
    }
    .meta {
      margin-top: 10px;
      color: var(--gray-mid);
      font-size: 0.78em;
      display: flex;
      justify-content: space-between;
      gap: 8px;
    }
    .card-url {
      display: inline-block;
      margin-top: 10px;
      font-size: 0.8em;
      font-family: 'SF Mono', 'Fira Code', 'Consolas', monospace;
      color: var(--accent);
      opacity: 0.8;
      transition: opacity 0.2s;
      word-break: break-all;
    }
    .service-card:hover .card-url { opacity: 1; }
    .empty {
      border: 1px dashed var(--gray-mid);
      border-radius: 12px;
      padding: 26px;
      color: var(--gray-text);
      background: var(--dark-card);
    }
    .footer {
      text-align: center;
      margin-top: 48px;
      padding-top: 24px;
      border-top: 1px solid var(--gray);
      color: var(--gray-mid);
      font-size: 0.78em;
    }
    @media (max-width: 768px) {
      .page-wrapper { padding: 24px 16px 40px; }
      .header { flex-direction: column; text-align: center; gap: 16px; }
      .services-grid { grid-template-columns: 1fr; }
      .meta { flex-direction: column; }
    }
  </style>
</head>
<body>
  <div class="page-wrapper">
    <div class="header">
      <img src="https://multiversum.consulting/wp-content/uploads/2021/10/multiversum-logo-83.png" alt="Multiversum">
      <div class="header-text">
        <h1>PPT Collaboration Index</h1>
        <p>Alle per LAN-Collab gepushten Präsentationen auf dem Mac Mini</p>
      </div>
    </div>
    <div class="divider"></div>
    <div class="section-label">Presentations</div>
    <div class="services-grid">
HTML_TOP

if [ -s "\$ENTRIES_FILE" ]; then
  while IFS='|' read -r user project mtime url; do
    cat >> "\$TMP_FILE" <<HTML_CARD
      <a href="\$url" class="service-card">
        <div class="card-top">
          <div class="card-icon">&#128196;</div>
          <h2>\$project</h2>
        </div>
        <p>Collab-Deployment unter <strong>/ppt/\$user/\$project/</strong></p>
        <div class="meta">
          <span>User: \$user</span>
          <span>Updated: \$mtime</span>
        </div>
        <span class="card-url">\$url</span>
      </a>
HTML_CARD
  done < "\$ENTRIES_FILE"
else
  cat >> "\$TMP_FILE" <<'HTML_EMPTY'
      <div class="empty">
        Noch keine Präsentationen vorhanden. Sobald ein Repository auf den Mac Mini gepusht wird,
        erscheint es hier automatisch.
      </div>
HTML_EMPTY
fi

cat >> "\$TMP_FILE" <<'HTML_BOTTOM'
    </div>
    <div class="footer">Multiversum Collaboration · /ppt/ Index</div>
  </div>
</body>
</html>
HTML_BOTTOM

mv "\$TMP_FILE" "\$INDEX_FILE"
chmod 644 "\$INDEX_FILE"
echo "[ppt-index] updated \$INDEX_FILE"
EOF
chmod +x "$MV_PPT_INDEX_RENDERER"

echo "[6/8] Install post-receive deploy hook"
cat > "$MV_BARE_REPO/hooks/post-receive" <<EOF
#!/bin/sh
set -eu

NGINX_HTML_ROOT="$MV_NGINX_HTML_ROOT"
PPT_ROOT="\$NGINX_HTML_ROOT/ppt"
REPO_NAME="\$(basename \"\$(pwd)\" .git)"
TMP_DIR="\$(mktemp -d /tmp/\${REPO_NAME}-deploy.XXXXXX)"
trap 'rm -rf "\$TMP_DIR"' EXIT

LAST_NEWREV=""
while read -r oldrev newrev refname; do
  LAST_NEWREV="\$newrev"
done

AUTHOR_EMAIL=""
if [ -n "\$LAST_NEWREV" ] && [ "\$LAST_NEWREV" != "0000000000000000000000000000000000000000" ]; then
  AUTHOR_EMAIL="\$(git --git-dir=\"\$(pwd)\" show -s --format='%ae' \"\$LAST_NEWREV\" 2>/dev/null || true)"
fi

if [ -n "\$AUTHOR_EMAIL" ]; then
  USER_FOLDER="\$(printf '%s' \"\$AUTHOR_EMAIL\" | awk -F'@' '{print \$1}' | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9._-')"
else
  USER_FOLDER="unknown"
fi
[ -n "\$USER_FOLDER" ] || USER_FOLDER="unknown"

DEPLOY_DIR="\$PPT_ROOT/\$USER_FOLDER/\$REPO_NAME"
mkdir -p "\$DEPLOY_DIR"

git --git-dir=\"\$(pwd)\" archive main | tar -x -C "\$TMP_DIR"
rsync -a --delete --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r "\$TMP_DIR"/ "\$DEPLOY_DIR"/
chmod -R u+rwX,go+rX "\$PPT_ROOT/\$USER_FOLDER"

NGINX_HTML_ROOT="\$NGINX_HTML_ROOT" "$MV_PPT_INDEX_RENDERER"
echo "[\$REPO_NAME] deployed to \$DEPLOY_DIR"
EOF
chmod +x "$MV_BARE_REPO/hooks/post-receive"

echo "[7/8] Install git daemon runner and launch agent"
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

echo "[8/8] Verify"
sleep 1
git ls-remote "git://127.0.0.1:9418/$MV_REPO_NAME" >/dev/null
"$MV_PPT_INDEX_RENDERER"
curl -fsS -I "http://127.0.0.1/ppt/" >/dev/null

echo "OK"
echo "LAN remote: git://$MV_HOST_LAN_IP:9418/$MV_REPO_NAME"
echo "PPT index:  http://$MV_HOST_LAN_IP/ppt/"
echo "Live deck path after push: /ppt/<user>/<repo>/"

