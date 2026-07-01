---
name: multiversum-brand
description: Use when creating presentations, proposals, pitch decks, reports, or DOCX documents for Multiversum GmbH clients or internal use. Covers CI-compliant HTML slide generation, DOCX logo/style rules, DSGVO/TISAX compliance classification, and brand guidelines. Triggers on any Multiversum content creation request.
---

# Multiversum Brand & Content System

## Overview

Unified reference for creating Multiversum-CI-compliant content. Every deliverable — PPT/HTML presentation, DOCX report, or proposal — follows this system. Covers visual CI, slide generation, DOCX templates, and mandatory compliance checks.

## Quick Start

### Standard Skill Use

1. Classify first via `compliance.md`
2. Build PPT/HTML with `ppt-system.md` and CI tokens from this file
3. Build DOCX with `docx-generator.py` and `docx-rules.md`

### LAN Editing (Mac Mini)

1. Host setup (one-time on Mac Mini):
   - `bash scripts/setup_lan_repo_and_deploy.sh`
2. Client setup (each colleague):
   - `bash scripts/connect_lan_client.sh`
3. Day-to-day:
   - `git add . && git commit -m "Update" && git push origin main`

Deployment convention:
- Decks: `/ppt/<projekt>/`
- Overview: `/ppt/index.html`

Details and variables: `lan-collab.md`

## When to Use

- Creating a presentation, pitch deck, or proposal
- Generating a DOCX report or client document
- Any output that will be shared with a client or internally
- Anytime content contains company data, personal data, or project information

**Mandatory on every content task:** Load `compliance.md` and apply data classification before sharing any document.

## Datei-Eigenschaften — Autor = Multiversum GmbH (verbindlich)

**Für JEDES hier erzeugte Office-Dokument** (`.docx`, `.doc`, `.pptx`, `.ppt`, `.xlsx`, `.xls` und alle weiteren Office-Formate) MUSS in den Datei-Eigenschaften als **Autor `Multiversum GmbH`** eingetragen sein — global und für alle User, ohne Ausnahme. Der verantwortliche Bearbeiter gehört in das Feld „Verantwortlich/Verfasser" (Dokumentensteckbrief, `--responsible`), niemals in die Datei-Eigenschaft „Autor".

Konkret beim Erzeugen:
- **DOCX** (`docx-generator.py`): passiert automatisch — `doc.core_properties.author` und `last_modified_by` werden immer auf `Multiversum GmbH` gesetzt. `--author` ist nur der Verfasser im Steckbrief.
- **PPTX** (`python-pptx`): `prs.core_properties.author = "Multiversum GmbH"` sowie `last_modified_by = "Multiversum GmbH"` setzen.
- **XLSX** (`openpyxl`): `wb.properties.creator = "Multiversum GmbH"` (und ggf. `lastModifiedBy`) setzen.
- **DOC / PPT / XLS** (Legacy): vor dem Speichern in `docProps/core.xml` bzw. den SummaryInformation-Stream den Autor auf `Multiversum GmbH` setzen; bei Konvertierung über LibreOffice/Pandoc `-core:author`/`--reference-doc` entsprechend vorbelegen.
- Bei Fremd-Generatoren (z. B. pandoc, LibreOffice headless) den Autor-Parameter explizit auf `Multiversum GmbH` setzen.

Vor der Auslieferung immer prüfen: Datei-Eigenschaften → Autor == `Multiversum GmbH`.

## Core CI Quick Reference

| Token | Value | Use |
|-------|-------|-----|
| `--y` | `#F2FF62` | Highlight, badges, active dots, accent |
| `--c` | `#333333` | Primary text, dark backgrounds |
| `--o` | `#3C6E89` | Teal — secondary accent, CTAs, takeaway borders (NO orange) |
| `--w` | `#FFFFFF` | White slide background |
| `--t` | `#3C6E89` | Teal — links, data viz |
| `--t2` | `#2D5570` | Deep blue — tertiary accent, stack tiers, charts |
| `--bl` | `#8AA8B8` | Light blue-grey — accents/captions on dark |
| `--s` | `#5D6269` | Steel — secondary text |
| `--sv` | `#A4A7AB` | Silver — muted/captions |
| `--l` | `#F5F5F3` | Light gray background |
| Font | Arial, Helvetica Neue, sans-serif | All text, all weights |

**Rule:** Max ONE `--y` element per slide/screen. Never use `--y` as text background with dark text on slide headers. **Never use `#F26B43` (orange) — it is not in the CI; teal/blue/grey are the secondary palette.**
**Dark layout rule (mandatory):** no blue highlight backgrounds on dark slides. Use white highlight styling instead.

## Mandatory PPT Background Assets

- Dark layouts (`.bg-d`, `.bg-g`) must use **Orbit.png** in the lower-right quadrant.
- Light layouts (`.bg-w`, `.bg-l`, `.bg-y`) must use **gestrichelter Kreis PNG** in the upper-left quadrant.
- Mandatory asset source for PPT build work: **`http://172.16.20.20/catalog/catalog.html`**
- Default direct asset URLs:
  - `http://172.16.20.20/catalog/uploads/20260528T152331_Orbit.png`
  - `http://172.16.20.20/catalog/uploads/20260528T173500_KreisgrauWeiss.png`

## Slide Backgrounds

| Class | Background | Text Color |
|-------|-----------|------------|
| `.bg-d` | `linear-gradient(145deg, #464646 0%, #1c1c1c 100%)` | `#FFFFFF` |
| `.bg-w` | `#FFFFFF` | `#333333` |
| `.bg-l` | `#F5F5F3` | `#333333` |
| `.bg-y` | `#F2FF62` | `#333333` |
| `.bg-g` | `linear-gradient(145deg, #404040 0%, #1a1a1a 100%)` | `#FFFFFF` |

**Standard deck pattern:** Cover → bg-d | Overview → bg-l | Content → alternate bg-w / bg-d | Chapter → bg-d | Closing → bg-d

## Logo Usage — MANDATORY

Every presentation **must** include both logos below. No generic placeholders, no omission.

### 1 · M-Symbol oben links (jede Folie, fixed)

```html
<div class="logo">
  <div style="width:38px;height:38px;background:#F2FF62;border-radius:8px;display:flex;align-items:center;justify-content:center;overflow:hidden">
    <svg width="26" height="26" viewBox="0 0 375 375" xmlns="http://www.w3.org/2000/svg">
      <path fill="#333333" fill-rule="evenodd" d="M 11.925781 4.878906 L 11.925781 371.6875 L 57.816406 371.6875 L 57.816406 108.164062 L 185.253906 223.113281 L 366.136719 41.214844 L 333.742188 8.671875 L 183.359375 159.957031 Z"/>
      <path fill="#333333" fill-rule="evenodd" d="M 203.136719 250.046875 L 235.519531 282.507812 L 322.113281 195.699219 L 322.113281 370.121094 L 367.707031 370.121094 L 367.707031 84.824219 Z"/>
    </svg>
  </div>
</div>
```

CSS `.logo` (in CSS Foundation): `position:fixed;top:20px;left:28px;z-index:100`

### 2 · Wordmark MULTIVERSUM (Deckblatt, prominent)

PNG liegt im Skill-Repo unter `assets/` — plain einbinden, **kein overflow:hidden, kein clip, kein filter**:

```html
<div style="margin-bottom:32px;overflow:visible;line-height:0">
  <img src="assets/Multiversum_gelb.png"
       alt="MULTIVERSUM" height="32"
       style="display:block;overflow:visible;clip:auto;max-width:none;filter:none">
</div>
```

**Pfad anpassen** je nach Ausgabe-Verzeichnis: `assets/Multiversum_gelb.png` (relativ) oder absoluter Pfad zum Skill-Ordner.
**LAN-Fallback:** `http://172.16.20.20/catalog/brand/official/Multiversum_gelb.png`

### Asset-Katalog (lokales Netzwerk)

Alle Logos, Icons, Fotos und Hintergründe: **`http://172.16.20.20/catalog/catalog.html`**
Direkte Datei-URLs: `http://172.16.20.20/catalog/brand/official/<dateiname>`

Falls ein Logo fehlt oder eine andere Variante gebraucht wird → Katalog öffnen, Datei finden, URL direkt einbetten. Der Katalog wird laufend aktualisiert.

- **DOCX top-right header:** `assets/Logo_MV_MVW.png` — M Symbol + Wordmark Kombination (schwarz, eingebettet)

## DOCX Document Generation — Quick Guide

**For any DOCX request:** Use the bundled generator. Never build a document from scratch.

```bash
python3 ~/.claude/skills/multiversum-brand/docx-generator.py \
  --out "YYYY-MM-DD_[Kunde]_[Typ]_v1.docx" \
  --title "Titel" --subtitle "Untertitel" \
  --classification intern --responsible "Name"
```

**What gets generated automatically:**
- Logo_MV_MVW.png top-right im Header (eingebettet, kein Netzwerk)
- Dokumentensteckbrief mit 7 Word Content Controls (ausfüllbar)
- Änderungshistorie-Tabelle
- Natives Word-Inhaltsverzeichnis (Heading 1–3, F9 zum Aktualisieren)
- Alle Stile vordefiniert: Heading 1–4, MV Body, MV Label, MV Value, Caption, TOC 1–3
- Footer: Multiversum GmbH · Hamburg | [KLASSIFIZIERUNG] | Seite/Gesamt

**After generation:** User opens in Word → F9 → TOC wird aktualisiert → Content Controls anklicken und ausfüllen.

**Python module import** (for programmatic use):
```python
import sys; sys.path.insert(0, str(Path.home() / ".claude/skills/multiversum-brand"))
from docx_generator import create_mv_document
doc = create_mv_document(title="Titel", classification="intern")
doc.add_heading("1. Einleitung", level=1)
doc.add_paragraph("Text.")
doc.save("output.docx")
```

Full reference: `docx-rules.md`

## PPTX Presentation Generation — Quick Guide

**For any native PowerPoint (.pptx) request:** Use the bundled generator. Never build a deck from scratch.
(The HTML slide system in `ppt-system.md` remains the default for web/PDF decks; use `pptx-generator.py` when the deliverable must be an editable `.pptx`.)

```bash
python3 ~/.claude/skills/multiversum-brand/pptx-generator.py \
  --out "YYYY-MM-DD_[Kunde]_[Typ].pptx" \
  --title "Titel" --subtitle "Untertitel" \
  --client "Kunde" --classification intern \
  --responsible "Name" --sample
```

**What gets generated automatically:**
- Datei-Eigenschaft **Autor = Multiversum GmbH** (`core_properties.author` + `last_modified_by`, verbindlich)
- 16:9 widescreen, Arial, full Multiversum color palette (kein Orange)
- 5 Hintergrund-Layouts wie das HTML-System: bg-d / bg-g (Dark-Gradient), bg-w / bg-l / bg-y (Light)
- M-Symbol+Wordmark-Logo oben links auf jeder Inhaltsfolie, gelber Wordmark prominent auf dem Deckblatt
- Footer: Multiversum GmbH · Hamburg | [KLASSIFIZIERUNG] | Folie/Gesamt
- Wiederverwendbare Folien-Bausteine: Cover, Agenda, Section-Divider, Two-Column, Architecture-Stack, Stats, Takeaway, Text
- `--responsible` → Verfasser landet in den Metadaten (Comments), nie in der Datei-Eigenschaft „Autor"

**Slide builders (for programmatic use):**
```python
import sys; sys.path.insert(0, str(Path.home() / ".claude/skills/multiversum-brand"))
from pptx_generator import (create_mv_presentation, add_cover_slide,
    add_agenda_slide, add_two_col_slide, add_stack_slide,
    add_stats_slide, add_takeaway_slide, add_section_divider, add_text_slide)

prs = create_mv_presentation(title="Titel", classification="intern")
add_section_divider(prs, chapter_no=1, title="Ausgangslage", index=2, total=4)
add_two_col_slide(prs, title="Lösung", eyebrow="APPROACH",
                  left_title="Links", left_body="Text",
                  right_title="Rechts", right_body="Text",
                  dark=False, index=3, total=4)
add_takeaway_slide(prs, title="Fazit.", body="CTA-Text.", index=4, total=4)
prs.save("output.pptx")
```

**After generation:** User öffnet in PowerPoint → Inhalte prüfen → ggf. Folien ergänzen. Logo + Footer sind fest verankert.

Full reference: `ppt-system.md` (CI tokens, slide layouts, background assets)

## Supporting References

- `coding-guidelines.md` — General coding behavior (Karpathy guidelines: think-before-coding, simplicity, surgical changes, goal-driven). Always-on; mirrored into `CLAUDE-template.md` / `AGENTS-template.md`.
- `ci.md` — Full CI specification (typography, spacing, all components)
- `ppt-system.md` — HTML slide CSS framework + component library
- `docx-rules.md` — DOCX generator docs, all styles, logo placement, callout patterns
- `docx-generator.py` — Python generator script (bundled, no install needed beyond python-docx)
- `pptx-generator.py` — Python PPTX generator script (bundled, no install needed beyond python-pptx; editable `.pptx` decks, same CI as `ppt-system.md`)
- `compliance.md` — DSGVO + TISAX data classification + mandatory checklists
- `assets/Logo_MV_MVW.png` — M Symbol + Wordmark Kombination (1200×238px, schwarz, eingebettet)
- `lan-collab.md` — LAN collaboration workflow (Mac Mini host + colleague clients)
- `scripts/setup_lan_repo_and_deploy.sh` — host setup for Git + auto deploy to NGINX path
- `scripts/connect_lan_client.sh` — client-side connect/clone/pull bootstrap

## Workflow

1. **Classify the content** → run compliance check (see `compliance.md`)
2. **Choose format:**
   - PPT/HTML → see `ppt-system.md`
   - DOCX → run `docx-generator.py` (see above + `docx-rules.md`)
3. **Apply CI** → use tokens from this file and `ci.md`
4. **Verify** → logo top-right sichtbar, Steckbrief ausgefüllt, TOC aktualisiert (F9), Klassifizierung im Footer
5. **PPTX** → `pptx-generator.py` für native `.pptx`-Decks; Datei-Eigenschaft „Autor" = Multiversum GmbH prüfen

## LAN Editing Mode (Mac Mini)

If users ask for collaborative editing from other Codex consoles in local network:

1. Run host bootstrap:
   - `bash scripts/setup_lan_repo_and_deploy.sh`
2. Share client bootstrap with colleagues:
   - `bash scripts/connect_lan_client.sh`
   - script asks: `Neues Projekt` oder `Bestehendes Projekt`
3. Confirm two endpoints:
   - Git remote: `git://<host-ip>:9418/<repo>.git`
   - PPT index: `http://<host-ip>/ppt/`
