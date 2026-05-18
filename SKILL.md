---
name: multiversum-brand
description: Use when creating presentations, proposals, pitch decks, reports, or DOCX documents for Multiversum GmbH clients or internal use. Covers CI-compliant HTML slide generation, DOCX logo/style rules, DSGVO/TISAX compliance classification, and brand guidelines. Triggers on any Multiversum content creation request.
---

# Multiversum Brand & Content System

## Overview

Unified reference for creating Multiversum-CI-compliant content. Every deliverable — PPT/HTML presentation, DOCX report, or proposal — follows this system. Covers visual CI, slide generation, DOCX templates, and mandatory compliance checks.

## When to Use

- Creating a presentation, pitch deck, or proposal
- Generating a DOCX report or client document
- Any output that will be shared with a client or internally
- Anytime content contains company data, personal data, or project information

**Mandatory on every content task:** Load `compliance.md` and apply data classification before sharing any document.

## Core CI Quick Reference

| Token | Value | Use |
|-------|-------|-----|
| `--y` | `#F2FF62` | Highlight, badges, active dots, accent |
| `--c` | `#333333` | Primary text, dark backgrounds |
| `--o` | `#3C6E89` | Secondary accent, CTAs, takeaway borders |
| `--w` | `#FFFFFF` | White slide background |
| `--t` | `#3C6E89` | Teal — links, data viz, tertiary |
| `--s` | `#5D6269` | Steel — secondary text |
| `--sv` | `#A4A7AB` | Silver — muted/captions |
| `--l` | `#F5F5F3` | Light gray background |
| Font | Arial, Helvetica Neue, sans-serif | All text, all weights |

**Rule:** Max ONE `--y` element and ONE `--o` element per slide/screen. Never use `--y` as text background with dark text on slide headers.

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

Alle Logos, Icons, Fotos: **`http://172.16.20.20/catalog/catalog.html`**
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

## Supporting References

- `ci.md` — Full CI specification (typography, spacing, all components)
- `ppt-system.md` — HTML slide CSS framework + component library
- `docx-rules.md` — DOCX generator docs, all styles, logo placement, callout patterns
- `docx-generator.py` — Python generator script (bundled, no install needed beyond python-docx)
- `compliance.md` — DSGVO + TISAX data classification + mandatory checklists
- `assets/Logo_MV_MVW.png` — M Symbol + Wordmark Kombination (1200×238px, schwarz, eingebettet)

## Workflow

1. **Classify the content** → run compliance check (see `compliance.md`)
2. **Choose format:**
   - PPT/HTML → see `ppt-system.md`
   - DOCX → run `docx-generator.py` (see above + `docx-rules.md`)
3. **Apply CI** → use tokens from this file and `ci.md`
4. **Verify** → logo top-right sichtbar, Steckbrief ausgefüllt, TOC aktualisiert (F9), Klassifizierung im Footer
