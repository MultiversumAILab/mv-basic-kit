"""
Multiversum PPTX Generator
=========================
Generates CI-compliant PowerPoint decks (.pptx) that mirror the Multiversum
HTML slide system (ppt-system.md): 5 background layouts (bg-d / bg-w / bg-l /
bg-y / bg-g), Arial typography, the full Multiversum color palette, M-Symbol
logo top-left on every slide, wordmark on the cover, classification + slide
number in the footer, and reusable slide builders (cover, agenda, two-column,
architecture stack, stats, takeaway, section divider).

Mandatory rule (global, see SKILL.md + AGENTS.md): the file-property "Autor"
is ALWAYS set to "Multiversum GmbH". The --responsible CLI flag may name an
individual "Verfasser" for the deck metadata, but never the file property.

Usage:
    python3 pptx-generator.py --out "Deck.pptx" --title "Projektvorschlag"
    python3 pptx-generator.py --out deck.pptx --title "Titel" --subtitle "Sub" \\
        --client "Kunde" --classification intern --sample

Or import the factory:
    from pptx_generator import create_mv_presentation
    prs = create_mv_presentation(title="My Deck")
    prs.save("output.pptx")

Requires: python-pptx (pip install python-pptx). Logos are bundled in assets/.
"""

import argparse
from datetime import date
from pathlib import Path

from pptx import Presentation
from pptx.dml.color import RGBColor
from pptx.enum.shapes import MSO_SHAPE
from pptx.enum.text import MSO_ANCHOR, PP_ALIGN
from pptx.oxml import parse_xml
from pptx.oxml.ns import qn
from pptx.util import Emu, Inches, Pt

# ── Logo paths (bundled with skill, always available) ──────────────────────────
SKILL_DIR = Path(__file__).parent
LOGO_COMBO_PATH = SKILL_DIR / "assets" / "Logo_MV_MVW.png"   # M + Wordmark, schwarz
LOGO_WORDMARK_PATH = SKILL_DIR / "assets" / "Multiversum_gelb.png"  # gelber Wordmark

# ── Mandatory file-property author (Multiversum GmbH) ─────────────────────────
# Every Office document generated here MUST list "Multiversum GmbH" as the author
# in its file properties (core:author / core:last_modified_by). This is a fixed
# global rule — see SKILL.md and the global AGENTS.md. The --responsible CLI flag
# may set an individual "Verfasser" in the deck metadata, but the file property
# author is always the company.
MV_AUTHOR = "Multiversum GmbH"

# ── CI Color palette (matches ppt-system.md / ci.md) ──────────────────────────
C_TEXT   = RGBColor(0x33, 0x33, 0x33)   # #333333 — primary text (light slides)
C_WHITE  = RGBColor(0xFF, 0xFF, 0xFF)   # #FFFFFF — text on dark slides
C_BLUE   = RGBColor(0x00, 0x6D, 0xB0)   # #006DB0 — Multiversum blue
C_TEAL   = RGBColor(0x3C, 0x6E, 0x89)   # #3C6E89 — teal accent / CTAs
C_DEEP   = RGBColor(0x2D, 0x55, 0x70)   # #2D5570 — deep blue (stack tiers)
C_STEEL  = RGBColor(0x5D, 0x62, 0x69)   # #5D6269 — secondary text
C_SILVER = RGBColor(0xA4, 0xA7, 0xAB)   # #A4A7AB — muted / footer
C_LGRAY  = RGBColor(0xF5, 0xF5, 0xF3)   # #F5F5F3 — light backgrounds
C_DGRAY  = RGBColor(0xE1, 0xE2, 0xE3)   # #E1E2E3 — dividers
C_YELLOW = RGBColor(0xF2, 0xFF, 0x62)   # #F2FF62 — Neon Gelb (accent only)

# Tinted backgrounds for dark-slide cards (approx. rgba over the dark gradient)
T_AL1 = RGBColor(0x2A, 0x2A, 0x20)   # yellow tint
T_AL2 = RGBColor(0x1C, 0x2A, 0x33)   # deep-blue tint
T_AL3 = RGBColor(0x2A, 0x2A, 0x2A)   # white tint
T_AL4 = RGBColor(0x21, 0x21, 0x21)   # silver tint
T_TAW = RGBColor(0x1C, 0x2A, 0x33)   # takeaway tint (teal)
C_CARD_LIGHT = RGBColor(0xEC, 0xEC, 0xEA)   # card bg on light slides

FONT_NAME = "Arial"

# Slide canvas: 16:9 widescreen
SLIDE_W = Inches(13.333)
SLIDE_H = Inches(7.5)

# Margins
M_LEFT = Inches(0.9)
M_RIGHT = Inches(0.9)
CONTENT_W = SLIDE_W - M_LEFT - M_RIGHT   # ~11.53in


# ─────────────────────────────────────────────────────────────────────────────
# Low-level helpers
# ─────────────────────────────────────────────────────────────────────────────

def _hex(rgb: RGBColor) -> str:
    return "{:02X}{:02X}{:02X}".format(rgb[0], rgb[1], rgb[2])


def _slide_bg_xml(kind: str) -> str:
    ns = ('xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" '
          'xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"')
    if kind == "d":
        return ('<p:bg %s><p:bgPr><a:gradFill rotWithShape="1"><a:gsLst>'
                '<a:gs pos="0"><a:srgbClr val="464646"/></a:gs>'
                '<a:gs pos="100000"><a:srgbClr val="1C1C1C"/></a:gs>'
                '</a:gsLst><a:lin ang="8700000" scaled="1"/></a:gradFill>'
                '<a:effectLst/></p:bgPr></p:bg>' % ns)
    if kind == "g":
        return ('<p:bg %s><p:bgPr><a:gradFill rotWithShape="1"><a:gsLst>'
                '<a:gs pos="0"><a:srgbClr val="404040"/></a:gs>'
                '<a:gs pos="100000"><a:srgbClr val="1A1A1A"/></a:gs>'
                '</a:gsLst><a:lin ang="8700000" scaled="1"/></a:gradFill>'
                '<a:effectLst/></p:bgPr></p:bg>' % ns)
    solid = {"w": "FFFFFF", "l": "F5F5F3", "y": "F2FF62"}[kind]
    return ('<p:bg %s><p:bgPr><a:solidFill><a:srgbClr val="%s"/></a:solidFill>'
            '<a:effectLst/></p:bgPr></p:bg>' % (ns, solid))


def set_slide_bg(slide, kind: str):
    """Set slide background. kind ∈ {d, g, w, l, y}."""
    if kind not in ("d", "g", "w", "l", "y"):
        raise ValueError("bg kind must be one of d/g/w/l/y")
    csld = slide._element.find(qn("p:cSld"))
    for bg in csld.findall(qn("p:bg")):
        csld.remove(bg)
    csld.insert(0, parse_xml(_slide_bg_xml(kind)))


def _is_dark(kind: str) -> bool:
    return kind in ("d", "g")


def _add_textbox(slide, left, top, width, height):
    tb = slide.shapes.add_textbox(left, top, width, height)
    tf = tb.text_frame
    tf.word_wrap = True
    tf.margin_left = Emu(0)
    tf.margin_right = Emu(0)
    tf.margin_top = Emu(0)
    tf.margin_bottom = Emu(0)
    return tb, tf


def _add_para(tf, text, *, size, color, bold=False, italic=False,
             align=PP_ALIGN.LEFT, space_after=Pt(6), space_before=Pt(0),
             font=FONT_NAME, first=False, line_spacing=1.15):
    p = tf.paragraphs[0] if first else tf.add_paragraph()
    p.alignment = align
    p.space_before = space_before
    p.space_after = space_after
    try:
        p.line_spacing = line_spacing
    except Exception:
        pass
    run = p.add_run()
    run.text = text
    f = run.font
    f.name = font
    f.size = size
    f.bold = bold
    f.italic = italic
    f.color.rgb = color
    return p, run


def _add_rounded(slide, left, top, width, height, fill=None, line=None,
                 line_width=Pt(1)):
    shp = slide.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE,
                                left, top, width, height)
    shp.shadow.inherit = False
    if fill is None:
        shp.fill.background()
    else:
        shp.fill.solid()
        shp.fill.fore_color.rgb = fill
    if line is None:
        shp.line.fill.background()
    else:
        shp.line.color.rgb = line
        shp.line.width = line_width
    # Clear the default placeholder text
    shp.text_frame.text = ""
    return shp


def _add_logo_top_left(slide):
    """M-Symbol + Wordmark combo, small, top-left on every content slide."""
    if not LOGO_COMBO_PATH.exists():
        return
    slide.shapes.add_picture(str(LOGO_COMBO_PATH),
                             Inches(0.35), Inches(0.28),
                             height=Inches(0.32))


def _add_footer(slide, classification: str, slide_index: int, total: int):
    """Footer line: Multiversum GmbH · Hamburg | [KLASS] | NN / total."""
    tb, tf = _add_textbox(slide, M_LEFT, Inches(7.02), CONTENT_W, Inches(0.35))
    _add_para(
        tf,
        "Multiversum GmbH · Hamburg   |   [%s]   |   %d / %d"
        % (classification.upper(), slide_index, total),
        size=Pt(9), color=C_SILVER, first=True, align=PP_ALIGN.LEFT,
        space_after=Pt(0),
    )


# ─────────────────────────────────────────────────────────────────────────────
# Slide builders
# ─────────────────────────────────────────────────────────────────────────────

def add_cover_slide(prs, *, title, subtitle="", eyebrow="PROPOSAL · 2026",
                    client="", date_str="", classification="intern",
                    index=1, total=1):
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    set_slide_bg(slide, "d")

    # Wordmark prominent (gelb), centered upper area
    if LOGO_WORDMARK_PATH.exists():
        slide.shapes.add_picture(str(LOGO_WORDMARK_PATH),
                                 Inches(4.97), Inches(1.5),
                                 height=Inches(0.55))

    # Eyebrow
    tb, tf = _add_textbox(slide, M_LEFT, Inches(2.5), CONTENT_W, Inches(0.4))
    _add_para(tf, eyebrow.upper(), size=Pt(12), color=C_YELLOW, bold=True,
              first=True, align=PP_ALIGN.CENTER, space_after=Pt(10))

    # Title
    tb, tf = _add_textbox(slide, M_LEFT, Inches(3.0), CONTENT_W, Inches(1.6))
    _add_para(tf, title, size=Pt(48), color=C_WHITE, bold=True,
              first=True, align=PP_ALIGN.CENTER, space_after=Pt(6),
              line_spacing=1.02)

    # Subtitle
    if subtitle:
        tb, tf = _add_textbox(slide, Inches(2.0), Inches(4.7), Inches(9.33), Inches(1.0))
        _add_para(tf, subtitle, size=Pt(18), color=C_WHITE, italic=True,
                  first=True, align=PP_ALIGN.CENTER, space_after=Pt(0))

    # Client · date row
    meta = "   ·   ".join(p for p in (client, date_str) if p)
    if meta:
        tb, tf = _add_textbox(slide, M_LEFT, Inches(6.1), CONTENT_W, Inches(0.4))
        _add_para(tf, meta, size=Pt(12), color=C_SILVER,
                  first=True, align=PP_ALIGN.CENTER, space_after=Pt(0))

    _add_footer(slide, classification, index, total)
    return slide


def add_agenda_slide(prs, *, items, title="Agenda", eyebrow="AGENDA",
                     classification="intern", index=2, total=1):
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    set_slide_bg(slide, "l")
    _add_logo_top_left(slide)

    tb, tf = _add_textbox(slide, M_LEFT, Inches(0.9), CONTENT_W, Inches(0.4))
    _add_para(tf, eyebrow.upper(), size=Pt(12), color=C_TEAL, bold=True,
              first=True, space_after=Pt(10))

    tb, tf = _add_textbox(slide, M_LEFT, Inches(1.35), CONTENT_W, Inches(0.9))
    _add_para(tf, title, size=Pt(34), color=C_TEXT, bold=True,
              first=True, space_after=Pt(24), line_spacing=1.05)

    tb, tf = _add_textbox(slide, M_LEFT, Inches(2.6), CONTENT_W, Inches(4.0))
    for i, item in enumerate(items, start=1):
        _add_para(tf, "%02d   %s" % (i, item), size=Pt(18), color=C_TEXT,
                  bold=False, first=(i == 1), space_after=Pt(12),
                  line_spacing=1.3)
    _add_footer(slide, classification, index, total)
    return slide


def add_section_divider(prs, *, chapter_no, title, eyebrow="CHAPTER",
                        classification="intern", index=3, total=1):
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    set_slide_bg(slide, "d")

    # Big chapter number watermark, bottom-right
    tb, tf = _add_textbox(slide, Inches(7.8), Inches(3.3), Inches(5.0), Inches(3.6))
    _add_para(tf, "%02d" % chapter_no, size=Pt(220), color=C_YELLOW, bold=True,
              first=True, align=PP_ALIGN.RIGHT, space_after=Pt(0),
              line_spacing=0.8)

    tb, tf = _add_textbox(slide, M_LEFT, Inches(2.7), CONTENT_W, Inches(0.4))
    _add_para(tf, eyebrow.upper(), size=Pt(12), color=C_YELLOW, bold=True,
              first=True, space_after=Pt(10))

    tb, tf = _add_textbox(slide, M_LEFT, Inches(3.2), Inches(9.0), Inches(1.6))
    _add_para(tf, title, size=Pt(40), color=C_WHITE, bold=True,
              first=True, space_after=Pt(0), line_spacing=1.05)

    _add_footer(slide, classification, index, total)
    return slide


def add_two_col_slide(prs, *, title, eyebrow, left_title, left_body,
                      right_title="", right_body="", dark=False,
                      classification="intern", index=4, total=1):
    kind = "d" if dark else "w"
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    set_slide_bg(slide, kind)
    if not dark:
        _add_logo_top_left(slide)

    text_main = C_WHITE if dark else C_TEXT
    eye_color = C_YELLOW if dark else C_TEAL

    tb, tf = _add_textbox(slide, M_LEFT, Inches(0.9), CONTENT_W, Inches(0.4))
    _add_para(tf, eyebrow.upper(), size=Pt(12), color=eye_color, bold=True,
              first=True, space_after=Pt(8))

    tb, tf = _add_textbox(slide, M_LEFT, Inches(1.35), CONTENT_W, Inches(0.9))
    _add_para(tf, title, size=Pt(30), color=text_main, bold=True,
              first=True, space_after=Pt(22), line_spacing=1.05)

    col_w = Inches(5.6)
    gap = Inches(0.33)
    left_x = M_LEFT
    right_x = left_x + col_w + gap

    # Left column
    tb, tf = _add_textbox(slide, left_x, Inches(2.7), col_w, Inches(4.0))
    _add_para(tf, left_title, size=Pt(18), color=text_main, bold=True,
              first=True, space_after=Pt(8))
    _add_para(tf, left_body, size=Pt(14), color=text_main,
              space_after=Pt(0), line_spacing=1.5)

    # Right column as a card
    if right_title or right_body:
        card_fill = C_CARD_LIGHT if not dark else T_AL3
        card_line = C_DGRAY if not dark else C_SILVER
        _add_rounded(slide, right_x, Inches(2.6), col_w, Inches(3.9),
                     fill=card_fill, line=card_line, line_width=Pt(1))
        tb, tf = _add_textbox(slide, right_x + Inches(0.3), Inches(2.9),
                             col_w - Inches(0.6), Inches(3.3))
        if right_title:
            _add_para(tf, right_title, size=Pt(18), color=text_main, bold=True,
                      first=True, space_after=Pt(8))
        if right_body:
            _add_para(tf, right_body, size=Pt(14), color=text_main,
                      first=not bool(right_title), space_after=Pt(0),
                      line_spacing=1.5)

    _add_footer(slide, classification, index, total)
    return slide


def add_stack_slide(prs, *, title, eyebrow, layers,
                    classification="intern", index=5, total=1):
    """layers: list of (title, description, accent) where accent ∈ {1,2,3,4}."""
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    set_slide_bg(slide, "d")

    tb, tf = _add_textbox(slide, M_LEFT, Inches(0.9), CONTENT_W, Inches(0.4))
    _add_para(tf, eyebrow.upper(), size=Pt(12), color=C_YELLOW, bold=True,
              first=True, space_after=Pt(8))

    tb, tf = _add_textbox(slide, M_LEFT, Inches(1.35), CONTENT_W, Inches(0.9))
    _add_para(tf, title, size=Pt(30), color=C_WHITE, bold=True,
              first=True, space_after=Pt(20), line_spacing=1.05)

    accent_fill = {1: T_AL1, 2: T_AL2, 3: T_AL3, 4: T_AL4}
    accent_line = {1: C_YELLOW, 2: C_DEEP, 3: C_WHITE, 4: C_SILVER}

    row_h = Inches(0.8)
    row_gap = Inches(0.12)
    top = Inches(2.7)
    col_w = Inches(8.0)
    for (layer_title, desc, accent) in layers:
        _add_rounded(slide, M_LEFT, top, col_w, row_h,
                     fill=accent_fill.get(accent, T_AL3),
                     line=accent_line.get(accent, C_WHITE), line_width=Pt(2))
        tb, tf = _add_textbox(slide, M_LEFT + Inches(0.3), top + Inches(0.12),
                             col_w - Inches(0.6), row_h - Inches(0.2))
        _add_para(tf, "%s — %s" % (layer_title, desc), size=Pt(15),
                  color=C_WHITE, bold=False, first=True, space_after=Pt(0),
                  line_spacing=1.25)
        top = Emu(int(top) + int(row_h) + int(row_gap))

    _add_footer(slide, classification, index, total)
    return slide


def add_stats_slide(prs, *, title, eyebrow, stats,
                    classification="intern", index=6, total=1):
    """stats: list of (value_str, label)."""
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    set_slide_bg(slide, "g")

    tb, tf = _add_textbox(slide, M_LEFT, Inches(0.9), CONTENT_W, Inches(0.4))
    _add_para(tf, eyebrow.upper(), size=Pt(12), color=C_YELLOW, bold=True,
              first=True, space_after=Pt(8))

    tb, tf = _add_textbox(slide, M_LEFT, Inches(1.35), CONTENT_W, Inches(0.9))
    _add_para(tf, title, size=Pt(30), color=C_WHITE, bold=True,
              first=True, space_after=Pt(28), line_spacing=1.05)

    n = max(1, len(stats))
    col_w = Inches(min(3.0, (13.333 - 1.8) / n))
    gap = Inches(0.4)
    total_w = col_w * n + gap * (n - 1)
    start_x = Emu(int((int(SLIDE_W) - int(total_w)) / 2))
    top = Inches(3.1)
    for i, (value, label) in enumerate(stats):
        x = Emu(int(start_x) + i * (int(col_w) + int(gap)))
        tb, tf = _add_textbox(slide, x, top, col_w, Inches(1.6))
        _add_para(tf, str(value), size=Pt(60), color=C_YELLOW, bold=True,
                  first=True, align=PP_ALIGN.CENTER, space_after=Pt(8),
                  line_spacing=1.0)
        tb, tf = _add_textbox(slide, x, top + Inches(1.5), col_w, Inches(0.6))
        _add_para(tf, label.upper(), size=Pt(11), color=C_SILVER, bold=False,
                  first=True, align=PP_ALIGN.CENTER, space_after=Pt(0))

    _add_footer(slide, classification, index, total)
    return slide


def add_takeaway_slide(prs, *, title, eyebrow="KEY TAKEAWAY", body="",
                       classification="intern", index=7, total=1):
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    set_slide_bg(slide, "d")

    tb, tf = _add_textbox(slide, Inches(2.0), Inches(2.2), Inches(9.33), Inches(0.4))
    _add_para(tf, eyebrow.upper(), size=Pt(12), color=C_YELLOW, bold=True,
              first=True, align=PP_ALIGN.LEFT, space_after=Pt(12))

    tb, tf = _add_textbox(slide, Inches(2.0), Inches(2.7), Inches(9.33), Inches(1.6))
    _add_para(tf, title, size=Pt(38), color=C_WHITE, bold=True,
              first=True, align=PP_ALIGN.LEFT, space_after=Pt(28), line_spacing=1.05)

    if body:
        _add_rounded(slide, Inches(2.0), Inches(4.5), Inches(9.33), Inches(1.4),
                     fill=T_TAW, line=C_TEAL, line_width=Pt(3))
        tb, tf = _add_textbox(slide, Inches(2.4), Inches(4.7), Inches(8.6), Inches(1.0))
        _add_para(tf, body, size=Pt(15), color=C_TEAL, italic=True,
                  first=True, space_after=Pt(0), line_spacing=1.4)

    _add_footer(slide, classification, index, total)
    return slide


def add_text_slide(prs, *, title, eyebrow, body, dark=False,
                   classification="intern", index=8, total=1):
    """Simple single-column text slide (bullets optional via list)."""
    kind = "d" if dark else "w"
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    set_slide_bg(slide, kind)
    if not dark:
        _add_logo_top_left(slide)
    text_main = C_WHITE if dark else C_TEXT
    eye_color = C_YELLOW if dark else C_TEAL

    tb, tf = _add_textbox(slide, M_LEFT, Inches(0.9), CONTENT_W, Inches(0.4))
    _add_para(tf, eyebrow.upper(), size=Pt(12), color=eye_color, bold=True,
              first=True, space_after=Pt(8))

    tb, tf = _add_textbox(slide, M_LEFT, Inches(1.35), CONTENT_W, Inches(0.9))
    _add_para(tf, title, size=Pt(30), color=text_main, bold=True,
              first=True, space_after=Pt(22), line_spacing=1.05)

    tb, tf = _add_textbox(slide, M_LEFT, Inches(2.7), CONTENT_W, Inches(4.0))
    if isinstance(body, str):
        body = [body]
    for i, line in enumerate(body):
        _add_para(tf, line, size=Pt(15), color=text_main,
                  first=(i == 0), space_after=Pt(8), line_spacing=1.5)

    _add_footer(slide, classification, index, total)
    return slide


# ─────────────────────────────────────────────────────────────────────────────
# Main factory
# ─────────────────────────────────────────────────────────────────────────────

def create_mv_presentation(
    title: str = "Präsentationstititel",
    subtitle: str = "",
    eyebrow: str = "PROPOSAL · 2026",
    client: str = "",
    date_str: str = "",
    classification: str = "intern",
    responsible: str = "",
    include_sample: bool = False,
) -> Presentation:
    """
    Creates and returns a Multiversum CI-compliant Presentation object.
    Call prs.save("filename.pptx") to write to disk.
    """
    prs = Presentation()
    prs.slide_width = SLIDE_W
    prs.slide_height = SLIDE_H

    # ── File properties: Autor immer Multiversum GmbH (globale Regel) ────────
    cp = prs.core_properties
    cp.author = MV_AUTHOR
    cp.last_modified_by = MV_AUTHOR
    cp.title = title
    cp.category = "Präsentation"
    cp.comments = ("Verfasser: %s — Multiversum GmbH" % responsible) if responsible else \
                  "Multiversum GmbH"

    if not date_str:
        date_str = date.today().strftime("%d.%m.%Y")

    # Footers are written with a placeholder total (the slide index); the real
    # total is patched in once the deck is fully assembled (see below).
    add_cover_slide(prs, title=title, subtitle=subtitle, eyebrow=eyebrow,
                    client=client, date_str=date_str,
                    classification=classification, index=1, total=1)

    if include_sample:
        add_agenda_slide(prs, items=[
            "Ausgangslage", "Lösung", "Architektur",
            "Nutzen", "Kennzahlen", "Nächste Schritte",
        ], classification=classification, index=2, total=2)

        add_two_col_slide(prs, title="Ausgangslage & Lösung",
                          eyebrow="CHALLENGE",
                          left_title="Herausforderung",
                          left_body="Kurze Beschreibung der Ausgangslage und "
                                    "des zu lösenden Problems.",
                          right_title="Unser Ansatz",
                          right_body="Beschreibung der Multiversum-Lösung in "
                                     "einem klaren, prägnanten Absatz.",
                          dark=True, classification=classification,
                          index=3, total=3)

        add_stack_slide(prs, title="Systemarchitektur", eyebrow="ARCHITECTURE",
                        layers=[
                            ("Frontend", "React, TypeScript", 1),
                            ("API Layer", "Node.js, REST/GraphQL", 2),
                            ("Data Layer", "PostgreSQL, Redis", 3),
                            ("Infrastructure", "Docker, nginx", 4),
                        ], classification=classification, index=4, total=4)

        add_stats_slide(prs, title="Kennzahlen", eyebrow="KEY METRICS",
                        stats=[("94 %", "Kundenzufriedenheit"),
                               ("3×", "Effizienz"),
                               ("24/7", "Verfügbarkeit"),
                               ("−40 %", "Kosten")],
                        classification=classification, index=5, total=5)

        add_takeaway_slide(prs, title="Bereit für den nächsten Schritt.",
                           eyebrow="KEY TAKEAWAY",
                           body="Kontaktieren Sie uns für ein unverbindliches "
                                "Gespräch zur Umsetzung.",
                           classification=classification, index=6, total=6)

    # Patch the real total into every footer ("NN / <idx>" → "NN / <total>").
    total = len(prs.slides._sldIdLst)
    for slide in prs.slides:
        _patch_footer_total(slide, total)

    return prs


def _patch_footer_total(slide, total):
    """Rewrite the footer's trailing '/ <idx>' to '/ <total>' on every slide."""
    import re
    for shp in slide.shapes:
        if not shp.has_text_frame:
            continue
        for p in shp.text_frame.paragraphs:
            full = "".join(r.text for r in p.runs)
            if "Multiversum GmbH" in full and re.search(r"/\s*\d+\s*$", full):
                new_text = re.sub(r"/\s*\d+\s*$", "/ %d" % total, full)
                if p.runs:
                    p.runs[0].text = new_text
                    for r in p.runs[1:]:
                        r.text = ""
                return


# ─────────────────────────────────────────────────────────────────────────────
# CLI entry point
# ─────────────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Generate a Multiversum CI-compliant PPTX deck")
    parser.add_argument("--out", default="Multiversum_Praesentation.pptx",
                        help="Output file path")
    parser.add_argument("--title", default="Präsentationstitel",
                        help="Deck title")
    parser.add_argument("--subtitle", default="", help="Cover subtitle")
    parser.add_argument("--eyebrow", default="PROPOSAL · 2026",
                        help="Cover eyebrow label")
    parser.add_argument("--client", default="", help="Client name (cover)")
    parser.add_argument("--date", default="",
                        help="Date string on cover (default: today)")
    parser.add_argument("--classification", default="intern",
                        choices=["öffentlich", "intern", "vertraulich",
                                 "streng vertraulich"])
    parser.add_argument("--responsible", default="",
                        help="Verfasser (nur Metadaten, nicht Datei-Eigenschaft "
                             "'Autor' — diese ist immer Multiversum GmbH)")
    parser.add_argument("--sample", action="store_true",
                        help="Include a full sample deck (7 slides)")
    args = parser.parse_args()

    prs = create_mv_presentation(
        title=args.title,
        subtitle=args.subtitle,
        eyebrow=args.eyebrow,
        client=args.client,
        date_str=args.date,
        classification=args.classification,
        responsible=args.responsible,
        include_sample=args.sample,
    )

    out_path = Path(args.out)
    prs.save(str(out_path))
    print("✓ Saved: %s" % out_path.resolve())
    print("  Slides: %d" % len(prs.slides._sldIdLst))
    print("  Autor:  %s (Datei-Eigenschaft)" % MV_AUTHOR)
    print("  Logos:  combo=%s wordmark=%s" %
          (LOGO_COMBO_PATH.exists(), LOGO_WORDMARK_PATH.exists()))


if __name__ == "__main__":
    main()