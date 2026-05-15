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
