# MV Basic Kit — Installation

## In Codex installieren

Den `$skill-installer` in Codex aufrufen und folgende Parameter angeben:

| Feld | Wert |
|------|------|
| **Quelle** | `https://github.com/MultiversumAILab/mv-basic-kit` |
| **Git-Ref** | `main` |
| **Sparse-Pfad** | `.` *(Root des Repos — alle Skill-Dateien liegen dort)* |

### Per URL (einfachste Methode)

Im Codex-Chat eingeben:

```
$skill-installer install https://github.com/MultiversumAILab/mv-basic-kit/tree/main
```

Danach **Codex neu starten** — der Skill `multiversum-brand` ist dann aktiv.

---

## In Claude Code installieren

```bash
git clone https://github.com/MultiversumAILab/mv-basic-kit \
  ~/.claude/skills/multiversum-brand
```

---

## CLAUDE.md für neues Projekt anlegen

```bash
cp ~/.claude/skills/multiversum-brand/CLAUDE-template.md ./CLAUDE.md
```

---

## Was ist im Skill enthalten?

| Datei | Inhalt |
|-------|--------|
| `SKILL.md` | CI-Quick-Reference, Logo-Pfade, Workflow |
| `ci.md` | Farben, Typo, Spacing, alle Komponenten |
| `ppt-system.md` | HTML-Slide-Framework, Templates, Navigation JS |
| `docx-rules.md` | DOCX-Regeln, Logo oben rechts, Header/Footer |
| `compliance.md` | DSGVO-Checklisten, TISAX-Klassifikation |
| `CLAUDE-template.md` | Default CLAUDE.md für neue Projekte |

## Verwendung nach Installation

> „Erstelle eine Multiversum-Präsentation für [Kunde] über [Thema]"  
> „Erstelle ein Word-Dokument für [Zweck] in Multiversum CI"  
> „Prüfe dieses Projekt auf DSGVO/TISAX-Konformität"

---

## LAN-Editing Setup (Mac Mini + Kolleg:innen)

Wenn Präsentationen von mehreren Codex-Consoles im LAN bearbeitet werden sollen:

```bash
# auf dem Mac Mini (Host)
bash scripts/setup_lan_repo_and_deploy.sh

# auf der Kolleg:innen-Konsole (Client)
bash scripts/connect_lan_client.sh
```

Der Client-Command fragt anschließend:
- Neues Projekt anlegen (`/ppt/<projekt>/`)
- oder bestehendes Projekt bearbeiten (gemeinsamer Ordner für mehrere Personen)

Vollständige Anleitung inkl. Variablen und Security-Hinweis:
- `lan-collab.md`

---

## mv-code Push Setup

Ermöglicht das Hochladen lokaler Projekte in mv-code ohne GitHub-Account.

### 1. Token + Name setzen (~/.zshrc)

```bash
export MV_PUSH_API_KEY="<Token vom Admin erhalten>"
export MV_CODE_OWNER="dein-name"
source ~/.zshrc
```

### 2. Script nutzen

```bash
cd /dein/projekt
bash ~/.claude/skills/multiversum-brand/scripts/push.sh
# oder mit explizitem Namen:
bash ~/.claude/skills/multiversum-brand/scripts/push.sh "Projektname" --private
```

### 3. Projekt in mv-code sehen

`https://172.16.20.20/mv-code` → Projekte-Tab
