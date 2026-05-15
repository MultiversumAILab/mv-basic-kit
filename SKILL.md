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
| `--o` | `#F26B43` | Secondary accent, CTAs, takeaway borders |
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

## Logo Usage

- **Top-left fixed** in presentations: 38×38px yellow box (`#F2FF62`), M SVG inside, border-radius 8px
- **DOCX top-right header:** `MV ohne slogan.svg` or `Multiversum gelb.png` — see `docx-rules.md`
- **Logo files:** `/Users/ai_lab_team/Documents/Bilder/Logos/`
  - Primary SVG: `Logo ohne Hintergrund.svg` (yellow, transparent bg)
  - Wordmark SVG: `MV ohne slogan.svg` (yellow wordmark)
  - Dark docs: `Multiversum + Slogan black.svg`

## Supporting References

- `ci.md` — Full CI specification (typography, spacing, all components)
- `ppt-system.md` — HTML slide CSS framework + component library
- `docx-rules.md` — DOCX formatting rules, header/footer, logo placement
- `compliance.md` — DSGVO + TISAX data classification + mandatory checklists

## Workflow

1. **Classify the content** → run compliance check (see `compliance.md`)
2. **Choose format** → PPT/HTML (see `ppt-system.md`) or DOCX (see `docx-rules.md`)
3. **Apply CI** → use tokens from this file and `ci.md`
4. **Verify** → correct logo placement, color usage, data classification marked
