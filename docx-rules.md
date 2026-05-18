# Multiversum DOCX — Document Rules

## Quick Start

```bash
# Generate a CI-compliant DOCX in one command:
python3 ~/.claude/skills/multiversum-brand/docx-generator.py \
  --out "Mein_Dokument.docx" \
  --title "Dokumententitel" \
  --subtitle "Untertitel / Abteilung" \
  --classification intern \
  --valid-from "01.06.2026" \
  --responsible "Name" \
  --approved-by "Name"

# With sample content sections (useful as starter template):
python3 ~/.claude/skills/multiversum-brand/docx-generator.py --out output.docx --title "Titel" --sample
```

Or use as Python module:
```python
import sys
sys.path.insert(0, str(Path.home() / ".claude/skills/multiversum-brand"))
from docx_generator import create_mv_document

doc = create_mv_document(
    title="ISMS Richtlinie — Zugangskontrolle",
    classification="intern",
    responsible="Max Mustermann",
)
doc.add_heading("1. Einleitung", level=1)
doc.add_paragraph("Ihr Inhalt hier.")
doc.save("output.docx")
```

## What the Generator Creates

Every generated DOCX contains:

1. **Header** — Logo_MV_MVW.png top-right (eingebettet, kein Netzwerk nötig), Dokumententitel links in grau, Trennlinie unten
2. **Titelbereich** — Titel 24pt fett, optionaler Untertitel 14pt grau, Teal-Trennbalken
3. **Dokumentensteckbrief** — 7 ausfüllbare Felder mit Word Content Controls (SDT), Klassifizierung, Verantwortlicher etc.
4. **Änderungshistorie** — vordefinierte Tabelle, erweiterbar per `changelog_entries`
5. **Inhaltsverzeichnis** — natives Word TOC-Feld (F9 zum Aktualisieren), TOC-Stile CI-konform
6. **Vordefinierte Stile** — Heading 1–4, MV Body, MV Label, MV Value, Caption, TOC 1–3
7. **Footer** — Multiversum GmbH · Hamburg | [KLASSIFIZIERUNG] | Seite / Gesamtseiten

## Logo

**Datei:** `~/.claude/skills/multiversum-brand/assets/Logo_MV_MVW.png`
- M Symbol + Wordmark Kombination (1200×238px, RGBA, schwarze Version)
- Eingebettet im Skill — kein Netzwerkzugriff zur Laufzeit
- Quelle: `http://172.16.20.20/catalog/brand/official/Logo_MV_MVW.png`
- Im Header: 0.9cm Höhe, rechts ausgerichtet

**Andere Logo-Varianten** (für spezielle Fälle):
- `assets/Multiversum_gelb.png` — gelber Wordmark (für dunkle Hintergründe / PPT)
- `assets/Logo_ohne_Hintergrund.svg` — SVG ohne Hintergrund (für Web)
- Vollständiger Katalog: `http://172.16.20.20/catalog/catalog.html`

## Typography

| Style | Font | Größe | Gewicht | Farbe |
|-------|------|-------|---------|-------|
| Dokumententitel | Arial | 24pt | Bold | `#333333` |
| Heading 1 | Arial | 18pt | Bold | `#333333` + Teal-Unterlinie |
| Heading 2 | Arial | 14pt | Bold | `#333333` |
| Heading 3 | Arial | 12pt | Bold | `#5D6269` |
| Heading 4 | Arial | 11pt | Bold Italic | `#5D6269` |
| Body Text / Normal | Arial | 11pt | Regular | `#333333` |
| MV Label (Steckbrief) | Arial | 10pt | Bold | `#006DB0` |
| MV Value (Steckbrief) | Arial | 10pt | Regular | `#333333` |
| Caption | Arial | 9pt | Italic | `#5D6269` |
| Footer / Header | Arial | 9pt | Regular | `#A4A7AB` |
| TOC 1 | Arial | 10pt | Bold | `#333333` |
| TOC 2 | Arial | 9pt | Regular | `#333333` |
| TOC 3 | Arial | 8pt | Regular | `#333333` |

## Color Usage in DOCX

| Element | Farbe | Hinweis |
|---------|-------|---------|
| Primärtext | `#333333` | Alle Fließtexte |
| Überschriften-Akzent | `#3C6E89` (Teal) | H1-Unterlinie, Trennbalken |
| Label-Farbe | `#006DB0` (Blau) | Steckbrief-Labels, Abschnittstitel |
| Callout-Highlight | `#F2FF62` Hintergrund | Sparsam — max. 1× pro Seite |
| Tabellen-Header | `#333333` Bg, `#FFFFFF` Text | Alle formalen Tabellen |
| Tabellen-Alt-Zeilen | `#F5F5F3` / `#FFFFFF` | Alternierend |
| Trennlinien | `#E1E2E3` | 0.5pt, Hellgrau |
| Muted / Footer | `#A4A7AB` | Footer, Captions, Metadaten |

## Page Layout

- **Format:** DIN A4 (21,0 × 29,7 cm)
- **Ränder:** alle 2,5 cm
- **Kopfzeilenabstand:** 1,25 cm
- **Fußzeilenabstand:** 1,25 cm
- **Zeilenabstand:** 1.15× (Überschriften), 1.5× (Fließtext)
- **Absatzabstand nach:** 6pt (Text), 12pt (Überschriften)

## Dokumentensteckbrief — Felder

| Feld | Content Control Tag | Verwendung |
|------|---------------------|------------|
| Dateiname | `steckbrief_filename` | Entspricht dem Dokumententitel |
| Klassifizierung | `steckbrief_class` | öffentlich / intern / vertraulich / streng vertraulich |
| Gültig ab | `steckbrief_valid` | Datum der Gültigkeit |
| Dokumentenverantwortlich | `steckbrief_responsible` | Name der verantwortlichen Person |
| Freigegeben von | `steckbrief_approved_by` | Name des Freigebenden |
| Freigegeben am | `steckbrief_approved_on` | Freigabedatum |
| Ablageort | `steckbrief_storage` | Pfad / SharePoint / DMS |

Content Controls sind echte Word-SDT-Felder — in Word direkt anklicken und ausfüllen.

## Änderungshistorie erweitern

```python
from docx_generator import create_mv_document

doc = create_mv_document(
    title="Mein Dokument",
    changelog_entries=[
        {"version": "0.1", "date": "15.05.2026", "chapter": "alle",
         "description": "Erstellung", "reviewed_by": "M. Mustermann"},
        {"version": "1.0", "date": "01.06.2026", "chapter": "alle",
         "description": "Freigabe nach Review", "reviewed_by": "F. Monti"},
    ]
)
doc.save("output.docx")
```

## Inhaltsverzeichnis

Das TOC ist ein natives Word-Feld (`TOC \o "1-3" \h \z \u`):
- Erfasst automatisch Heading 1–3
- **F9** in Word zum Aktualisieren
- Beim ersten Öffnen fragt Word ggf. nach Aktualisierung → "Gesamtes Inhaltsverzeichnis aktualisieren"

## Callout Box (manuell hinzufügen)

```python
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Pt

def add_callout(doc, text):
    para = doc.add_paragraph()
    pPr = para._p.get_or_add_pPr()
    pBdr = OxmlElement("w:pBdr")
    left = OxmlElement("w:left")
    left.set(qn("w:val"), "single")
    left.set(qn("w:sz"), "24")
    left.set(qn("w:space"), "12")
    left.set(qn("w:color"), "3C6E89")
    pBdr.append(left)
    pPr.append(pBdr)
    run = para.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(11)
    run.font.italic = True
```

## Compliance Watermark (Vertraulich)

Für Dokumente der Klassifizierung `vertraulich` oder `streng vertraulich`:
- Wasserzeichen: `VERTRAULICH` diagonal, Schriftgröße 60pt, Farbe `rgba(242,107,67,0.15)`
- TISAX-Marker in Footer-Mitte: `[VERTRAULICH]` / `[INTERN]`
- Der Generator setzt den Footer-Marker automatisch anhand der `--classification`

## Dateinamen-Konvention

```
YYYY-MM-DD_[Projekt/Kunde]_[Dokumenttyp]_v[N].docx

Beispiele:
2026-06-01_Intern_ISMS-Zugangskontrolle_v1.docx
2026-06-01_Mustermann-GmbH_Angebot_v2.docx
2026-06-01_Intern_DSGVO-Verfahrensverzeichnis_v1.docx
```

## Quick Generation Checklist

- [ ] `python3 docx-generator.py` ausgeführt
- [ ] Logo im Header top-right sichtbar (Logo_MV_MVW.png)
- [ ] Dokumentensteckbrief ausgefüllt (alle 7 Felder)
- [ ] Klassifizierung korrekt gesetzt + im Footer sichtbar
- [ ] Inhaltsverzeichnis aktualisiert (F9 in Word)
- [ ] Schrift Arial durchgehend (kein Times New Roman / Calibri)
- [ ] Dateiname nach Konvention `YYYY-MM-DD_..._v[N].docx`
- [ ] TISAX-Check: enthält das Dokument personenbezogene Daten? → compliance.md
