# Multiversum DOCX — Document Rules

## Mandatory Elements (Every DOCX)

### Header — Top Right Logo
Every Multiversum DOCX must have the logo in the **top-right corner of the header**.

**Logo file to use:**
- Primary: `/Users/ai_lab_team/Documents/Bilder/Logos/MV ohne slogan.svg`
- Fallback PNG: `/Users/ai_lab_team/Documents/Bilder/Logos/Multiversum gelb.png`
- Dark docs (printed): `/Users/ai_lab_team/Documents/Bilder/Logos/Multiversum + Slogan black.svg`

**Header setup:**
- Header height: ~1.5cm
- Logo position: right-aligned, top-right corner
- Logo height: 1cm (maintain aspect ratio)
- Background: white (logo is yellow on white = visible as black/dark shape; use dark variant for print)
- Left side of header: blank or document title in light gray (rgba(0,0,0,.4))

**When generating via python-docx or similar:**
```python
from docx.shared import Cm, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH

# Add header with logo
header = doc.sections[0].header
header_para = header.paragraphs[0]
header_para.alignment = WD_ALIGN_PARAGRAPH.RIGHT
run = header_para.add_run()
run.add_picture('path/to/Multiversum gelb.png', height=Cm(1))
```

### Footer
- Left: `Multiversum GmbH · Hamburg` in 9pt, color `#A4A7AB`
- Center: empty
- Right: Page number `{PAGE} / {NUMPAGES}` in 9pt, color `#A4A7AB`

## Typography

| Style | Font | Size | Weight | Color |
|-------|------|------|--------|-------|
| Document Title | Arial | 24pt | Bold (700) | `#333333` |
| Heading 1 | Arial | 18pt | Bold (700) | `#333333` |
| Heading 2 | Arial | 14pt | Bold (700) | `#333333` |
| Heading 3 | Arial | 12pt | SemiBold (600) | `#333333` |
| Body Text | Arial | 11pt | Regular (400) | `#333333` |
| Caption | Arial | 9pt | Regular (400) | `#5D6269` |
| Footer/Header | Arial | 9pt | Regular (400) | `#A4A7AB` |

## Color Usage in DOCX

| Element | Color | Notes |
|---------|-------|-------|
| H1 underline accent | `#F26B43` | Bottom border on H1 paragraphs (optional) |
| Highlight/callout box | `#F2FF62` background, `#333333` text | Use sparingly — 1 per page max |
| Table header row | `#333333` background, `#FFFFFF` text | |
| Table alternating rows | `#F5F5F3` / `#FFFFFF` | |
| Divider lines | `#E1E2E3` | 0.5pt, light gray |
| Important text | `#F26B43` | Bold only, never entire paragraphs |

## Page Layout

- **Page size:** A4 (210×297mm)
- **Margins:** Top 2.5cm, Bottom 2.5cm, Left 2.5cm, Right 2.5cm
- **Header height:** 1.5cm
- **Footer height:** 1.2cm
- **Line spacing:** 1.15 (headings), 1.5 (body)
- **Paragraph spacing after:** 6pt (body), 12pt (headings)

## Callout Box Pattern

For important information boxes (like takeaways in PPT):
```
Left border: 4pt, color #F26B43 (orange) or #F2FF62 (yellow)
Background: light tint of border color (10% opacity)
Padding: 12pt all sides
Font: Italic, 11pt, color matching border
```

## Cover Page Pattern (for formal proposals/reports)

```
Background: #333333 (full page, dark)
Top-left: Multiversum M logo (yellow version), 3cm × 3cm
Center-left: Document title in white, 28pt bold
Below title: Subtitle/client name in rgba(255,255,255,.6), 16pt light
Bottom-left: Date + "Multiversum GmbH" in 11pt, opacity .5
Bottom-right: Multiversum wordmark in yellow
```

## Compliance Watermark (Confidential Docs)

For CONFIDENTIAL or INTERNAL classified documents:
- Add watermark text: `VERTRAULICH` (German) or `CONFIDENTIAL`
- Color: `rgba(242,107,67,.15)` (light orange, 15% opacity)
- Diagonal, centered, 60pt Arial Bold
- TISAX classification marker in footer-right: `[VERTRAULICH]` or `[INTERN]`

## Quick Generation Checklist

- [ ] Logo in header top-right (correct variant for print/screen)
- [ ] Footer with company name + page number
- [ ] Font is Arial throughout (no exceptions)
- [ ] Document title uses H1 style
- [ ] Table headers use dark bg (#333333) + white text
- [ ] TISAX classification marked if document contains sensitive data
- [ ] File named: `YYYY-MM-DD_[Client]_[DocumentType]_v[N].docx`
