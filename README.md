# multiversum-brand — Claude Code Skill

CI, PPT-System, DOCX-Regeln und DSGVO/TISAX-Compliance für Multiversum GmbH.

## Was ist drin?

| Datei | Inhalt |
|-------|--------|
| `SKILL.md` | Skill-Einstieg, Quick Reference CI-Tokens, Logo-Pfade |
| `ci.md` | Vollständige CI-Spezifikation (Farben, Typo, Spacing, Komponenten) |
| `ppt-system.md` | HTML-Slide-CSS-Framework + Slide-Templates + Navigation JS |
| `docx-rules.md` | DOCX-Formatierungsregeln, Logo-Placement, Compliance-Wasserzeichen |
| `compliance.md` | DSGVO-Checklisten, TISAX-Klassifikation, Verantwortliche |
| `CLAUDE-template.md` | Default `CLAUDE.md` für neue Team-Kolleg:innen |

## Installation (1 Befehl)

```bash
# Skill installieren
mkdir -p ~/.claude/skills/multiversum-brand && \
curl -fsSL https://raw.githubusercontent.com/[ORG]/multiversum-brand-skill/main/{SKILL,ci,ppt-system,docx-rules,compliance}.md \
  -o "~/.claude/skills/multiversum-brand/#1.md" 2>/dev/null || \
git clone https://github.com/[ORG]/multiversum-brand-skill /tmp/mv-skill && \
cp /tmp/mv-skill/*.md ~/.claude/skills/multiversum-brand/

echo "✓ multiversum-brand Skill installiert"
```

## CLAUDE.md für neue Kolleg:innen

```bash
# CLAUDE.md in Projekt-Ordner kopieren
curl -fsSL https://raw.githubusercontent.com/[ORG]/multiversum-brand-skill/main/CLAUDE-template.md \
  > ~/Documents/[PROJEKT-ORDNER]/CLAUDE.md
```

## Manuell (Copy-Paste)

1. Dieses Repository klonen oder ZIP herunterladen
2. Alle `.md` Dateien nach `~/.claude/skills/multiversum-brand/` kopieren
3. `CLAUDE-template.md` als `CLAUDE.md` in den Projekt-Ordner kopieren und anpassen

## Verwendung

Nach Installation aktiviert Claude den Skill automatisch bei CI/Dokument-Anfragen.

**Präsentation erstellen:**
> "Erstelle eine Multiversum-Präsentation für [Kunde] über [Thema]"

**DOCX-Dokument:**
> "Erstelle ein Word-Dokument für [Zweck] in Multiversum CI"

**Compliance-Check:**
> "Prüfe dieses Projekt auf DSGVO/TISAX-Konformität"

## CI-Schnellreferenz

```css
--y: #F2FF62  /* Gelb — Highlight */
--o: #F26B43  /* Orange — Akzent */
--c: #333333  /* Dunkel — Text */
--w: #FFFFFF  /* Weiß */
--t: #3C6E89  /* Teal — Links */
Font: Arial, Helvetica Neue, sans-serif
```

**Slide-Muster:** Cover (dark) → Agenda (light) → Content (weiß/dunkel abwechselnd) → Closing (dark)

## Voraussetzungen

- Claude Code CLI oder Desktop-App
- Logo-Dateien lokal verfügbar (intern: `/Users/[USER]/Documents/Bilder/Logos/`)

## Lizenz

Intern — Multiversum GmbH. Nicht für externe Weitergabe.
