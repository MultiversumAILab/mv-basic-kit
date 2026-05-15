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

```html
<div style="margin-bottom:32px">
  <svg width="220" height="27" viewBox="0 0 1082 133" xmlns="http://www.w3.org/2000/svg" overflow="hidden">
    <g transform="translate(-1081 -1347)">
      <path d="M1304.84 1440.25C1304.84 1452.17 1298.53 1460.11 1285.89 1460.11 1272.47 1460.11 1266.16 1452.17 1266.16 1440.25 1266.16 1391 1248 1391 1248 1391 1248 1441.05 1248 1461.7 1260.63 1476 1285.89 1476 1311.16 1476 1323 1461.7 1323 1441.05 1323 1391 1304.84 1391 1304.84 1440.25Z" fill="#F2FF62"/>
      <path d="M1375.46 1391 1357 1391 1357 1474 1411 1474 1411 1458.27 1375.46 1458.27Z" fill="#F2FF62"/>
      <path d="M1423 1406.73 1447.7 1406.73 1447.7 1474 1465.97 1474 1465.97 1406.73 1490 1406.73 1490 1391 1423 1391Z" fill="#F2FF62"/>
      <rect x="1520" y="1391" width="18" height="83" fill="#F2FF62"/>
      <path d="M1607.5 1454.25 1584.41 1391 1564 1391 1596.46 1474 1618.54 1474 1650 1391 1630.26 1391Z" fill="#F2FF62"/>
      <path d="M1676 1474 1736 1474 1736 1458.27 1694.64 1458.27 1694.64 1439.19 1734.64 1439.19 1734.64 1424.13 1694.64 1424.13 1694.64 1406.73 1736 1406.73 1736 1391 1676 1391Z" fill="#F2FF62"/>
      <path d="M1835.2 1417.88C1835.2 1402.07 1824 1391 1807.2 1391L1768 1391 1768 1474 1785.6 1474 1785.6 1444.75 1798.4 1444.75 1815.2 1474 1836 1474 1816.8 1442.38C1825.6 1440.01 1835.2 1432.1 1835.2 1417.88ZM1804 1428.94L1785.6 1428.94 1785.6 1406.81 1804 1406.81C1811.2 1406.81 1816.8 1410.76 1816.8 1417.88 1816.8 1424.99 1811.2 1428.94 1804 1428.94Z" fill="#F2FF62"/>
      <path d="M1882.56 1413.74C1882.56 1408.16 1887.3 1404.96 1894.42 1404.96 1903.12 1404.96 1911.81 1408.16 1918.93 1414.54L1928.42 1400.97C1920.51 1392.99 1909.44 1389 1896 1389 1876.23 1389 1864.37 1400.97 1864.37 1414.54 1864.37 1446.47 1912.6 1436.09 1912.6 1450.46 1912.6 1455.25 1907.86 1460.04 1897.58 1460.04 1886.51 1460.04 1877.81 1454.45 1871.49 1448.86L1862 1462.43C1869.91 1470.41 1880.98 1476 1896.79 1476 1919.72 1476 1930 1464.03 1930 1448.86 1930 1417.73 1882.56 1426.51 1882.56 1413.74Z" fill="#F2FF62"/>
      <path d="M2017.68 1440.25C2017.68 1452.17 2010.6 1460.11 1998 1460.11 1985.4 1460.11 1979.11 1452.17 1979.11 1440.25 1979.11 1391 1961 1391 1961 1391 1961 1441.05 1961 1461.7 1972.81 1476 1998 1476 2023.19 1476 2035 1461.7 2035 1441.05 2035 1391 2017.68 1391 2017.68 1440.25Z" fill="#F2FF62"/>
      <path d="M2136.39 1391 2115.49 1443.21 2095.61 1391 2071 1391 2071 1474 2088.53 1474 2088.53 1413.76 2112.46 1474 2119.54 1474 2143.47 1413.76 2143.47 1474 2161 1474 2161 1391Z" fill="#F2FF62"/>
      <path d="M1195.91 1349.68 1143.48 1402.09 1084 1348 1084 1475 1099.79 1475 1099.79 1383.95 1144.16 1423.6 1207 1360.77Z" fill="#F2FF62"/>
      <path d="M1161.06 1443.59 1191.24 1413.18 1191.24 1474 1207 1474 1207 1375 1150 1432.44Z" fill="#F2FF62"/>
    </g>
  </svg>
</div>
```

### Asset-Katalog (lokales Netzwerk)

Alle Logos, Icons, Fotos: **`http://172.16.20.20/catalog/catalog.html`**
Direkte Datei-URLs: `http://172.16.20.20/catalog/brand/official/<dateiname>`

Falls ein Logo fehlt oder eine andere Variante gebraucht wird → Katalog öffnen, Datei finden, URL direkt einbetten. Der Katalog wird laufend aktualisiert.

- **DOCX top-right header:** `MV_ohne_slogan.svg` oder `Multiversum_gelb.png` — siehe `docx-rules.md`

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
