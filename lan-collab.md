# LAN Collaboration for HTML Decks (Mac Mini)

This guide adds a reusable Git-based collaboration flow for presentation editing in the local network.

## Goal

- Colleagues can edit from another Codex console in LAN.
- Pushes deploy automatically into `/ppt/<user>/<repo>/`.
- `/ppt/index.html` is regenerated on every push as a live overview.
- Setup is repeatable and can be reused in `mv-basic-kit`.

## Architecture

1. Mac Mini hosts a bare Git repository (`shared-git/<name>.git`)
2. `post-receive` hook deploys `main` branch to `ppt/<user>/<repo>`
3. `git daemon` exposes repository in LAN (`git://<host-ip>:9418/<name>.git`)
4. Hook regenerates `/ppt/index.html` overview
5. Colleagues clone, edit, commit, push

## Host Setup (Mac Mini)

Run:

```bash
bash scripts/setup_lan_repo_and_deploy.sh
```

Optional environment overrides:

```bash
MV_HOST_LAN_IP=172.16.20.20
MV_REPO_NAME=wlalq01.git
MV_WORKTREE_DIR="$HOME/Documents/wlalq01-presentation"
MV_SOURCE_DIR="$HOME/2026-05-15_Internationales-Industrieunternehmen_Angebot_VERTRAULICH_v1"
MV_NGINX_HTML_ROOT="$HOME/.docker/.../nginx_html"
```

## Client Setup (Another Codex console in LAN)

Run:

```bash
bash scripts/connect_lan_client.sh
```

Optional environment overrides:

```bash
MV_HOST_LAN_IP=172.16.20.20
MV_REPO_NAME=wlalq01.git
MV_CLIENT_DIR="$HOME/projects/wlalq01"
MV_GIT_USER_NAME="Firstname Lastname"
MV_GIT_USER_EMAIL="firstname.lastname@multiversum.consulting"
```

## Daily Editing Flow

```bash
cd "$MV_CLIENT_DIR"
git pull --rebase
# edit files
git add .
git commit -m "Update slide content"
git push origin main
```

Deployment is automatic after push.

Final URL pattern:

```text
http://<host-ip>/ppt/<user>/<repo>/
```

## Quick Verification

On host:

```bash
git ls-remote "git://$MV_HOST_LAN_IP:9418/$MV_REPO_NAME"
curl -I "http://$MV_HOST_LAN_IP/ppt/"
```

## Security Note

`git://` is unencrypted and unauthenticated. Use this only in trusted LAN segments.  
If required, switch later to SSH + keys while keeping the same repository/hook layout.
