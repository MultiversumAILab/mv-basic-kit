# Multiversum CI — Full Specification

## Color System

### Primary Palette (CSS Variables)
```css
:root {
  --y:  #F2FF62;  /* Yellow-Green: highlight, badges, accent bars */
  --c:  #333333;  /* Charcoal: primary text, dark-bg bg */
  --o:  #F26B43;  /* Orange: CTAs, takeaway borders, secondary accent */
  --w:  #FFFFFF;  /* White: slide bg, body text on dark */
  --s:  #5D6269;  /* Steel: secondary text, subtitles */
  --sv: #A4A7AB;  /* Silver: muted text, captions, placeholders */
  --l:  #F5F5F3;  /* Light: off-white bg, light slides */
  --t:  #3C6E89;  /* Teal: links, data viz, tertiary accent */
  --f:  'Arial','Helvetica Neue',sans-serif;
}
```

### Semantic Usage Rules
- `--y` → One element per slide max. Badges, active indicators, highlight lines, chapter numbers on dark
- `--o` → One element per slide max. Takeaway boxes, CTA buttons, chapter dividers
- `--c` → Body text on light backgrounds. NEVER use as text on `--y` backgrounds (too dark → unreadable)
- `--t` → Links, charts/graphs, secondary info. Never compete with `--o`

### Dark Background Text Hierarchy
```
Primary:    #FFFFFF (full opacity)
Secondary:  rgba(255,255,255,.65)
Muted:      rgba(255,255,255,.45)
Very muted: rgba(255,255,255,.28)
Accent:     #F2FF62 (--y)
Sub-accent: #F26B43 (--o)
```

### Light Background Text Hierarchy
```
Primary:    #333333 (--c)
Secondary:  rgba(0,0,0,.55)
Muted:      rgba(0,0,0,.38)
Very muted: rgba(0,0,0,.22)
```

## Typography

**Font:** Arial, Helvetica Neue, Helvetica, sans-serif (system stack — no web font loading)

### Scale
| Role | Size | Weight | Letter-Spacing | Line-Height |
|------|------|--------|----------------|-------------|
| Display/H1 | `clamp(34px, 5vw, 68px)` | 900 | -2px | 1.02 |
| H2 | `clamp(22px, 3.2vw, 44px)` | 800 | -1px | 1.1 |
| H3 | `clamp(14px, 1.8vw, 20px)` | 700 | 0 | 1.3 |
| Lead/Intro | `clamp(14px, 1.8vw, 22px)` | 300 | 0 | 1.5 |
| Body | `clamp(12px, 1.3vw, 16px)` | 400 | 0 | 1.6 |
| Eyebrow/Label | 11px | 500 | 3px | 1 |
| Caption | 10px | 400 | 1px | 1.4 |

**Eyebrow labels:** always UPPERCASE, opacity .55, letter-spacing 3px — used for section labels, category tags

**Chapter numbers (decorative):** `clamp(100px, 18vw, 220px)`, weight 900, opacity .12 (dark) / .07 (light), position absolute bottom-right

## Spacing System (px)
```
4 · 8 · 12 · 16 · 20 · 24 · 28 · 32 · 40 · 48 · 52 · 60 · 64 · 80 · 96
```
- Slide padding: `60px 80px`
- Card padding: `22px–24px`
- Section gap (major): `28px–40px`
- Component gap (minor): `13px–16px`
- Inline gap: `6px–10px`

## Grid Layouts (Slides)

```css
.fw    { grid-template-columns: 1fr; max-width: 1200px }
.two   { grid-template-columns: 1fr 1fr; gap: 44px }
.three { grid-template-columns: 1fr 1fr 1fr; gap: 28px }
.side  { grid-template-columns: 1fr 420px; gap: 52px }
.side-sm { grid-template-columns: 1fr 320px; gap: 40px }
.sg    { grid-template-columns: repeat(4,1fr); gap: 28px }  /* stats */
.pl    { grid-template-columns: repeat(4,1fr); gap: 20px }  /* pillars */
```

Slide dimensions: 1280×720px (16:9). Full-screen web: 100vw×100vh.

## Component Tokens

### Cards
```css
/* Dark context */
background: rgba(255,255,255,.03);
border: 1px solid rgba(255,255,255,.07);
border-radius: 10px;
padding: 22px;
/* Hover */
border-color: rgba(242,255,98,.3);
transition: .3s;

/* Light context */
background: rgba(0,0,0,.03);
border: 1px solid rgba(0,0,0,.08);
```

### Architecture Stack Items (left-border color system)
```css
.al1 { background: rgba(242,255,98,.10); border-left: 3px solid #F2FF62; }  /* Yellow */
.al2 { background: rgba(242,107,67,.10); border-left: 3px solid #F26B43; }  /* Orange */
.al3 { background: rgba(60,110,137,.18); border-left: 3px solid #3C6E89; }  /* Teal */
.al4 { background: rgba(255,255,255,.05); border-left: 3px solid #A4A7AB; } /* Silver */
padding: 15px 22px; border-radius: 8px;
```

### Takeaway/Highlight Boxes
```css
.taw-y { border-left: 4px solid #F2FF62; background: rgba(242,255,98,.07); }
.taw-o { border-left: 4px solid #F26B43; background: rgba(242,107,67,.07); }
border-radius: 0 8px 8px 0; padding: 18px 24px; font-style: italic;
```

### Badges / Tags
```css
/* Feature badge */
background: #F2FF62; color: #333333; font-size: 9px; font-weight: 700;
padding: 3px 9px; border-radius: 18px;

/* Technology tag */
background: rgba(255,255,255,.06); border-radius: 18px;
padding: 5px 12px; font-size: 11px;
```

### Tables
```css
/* Header row */
font-size: 10px; letter-spacing: 2px; text-transform: uppercase;
padding: 10px 14px; border-bottom: 2px solid rgba(242,255,98,.2);

/* Data cells */
padding: 9px 14px; border-bottom: 1px solid rgba(255,255,255,.05);

/* Total row */
font-weight: 700; color: #F2FF62; border-top: 2px solid rgba(242,255,98,.2);
```

### Decorative Elements
- **Progress bar** (top, fixed): 3px height, `#F2FF62`, `z-index: 1000`
- **Navigation dots**: 7×7px circle → active: 22×7px pill `#F2FF62` / `#333333` (light)
- **Timeline**: 2px vertical line gradient `#F2FF62` → `rgba(242,255,98,.1)`, dots 40px circle `#F2FF62` weight 900
- **Circular watermark** (white slides): `KreisgrauWeiss.png`, top -60px left -40px, 560×560px, opacity .35, z-index -1

## Animation
```css
@keyframes fu {
  from { opacity: 0; transform: translateY(18px); }
  to   { opacity: 1; transform: translateY(0); }
}
/* Usage: animation: fu .55s ease forwards */
/* Stagger delays: .08s, .14s, .19s, .23s */
```

Box shadows (dark bg):
- Light: `0 4px 24px rgba(0,0,0,.18)`
- Deep: `0 24px 64px rgba(0,0,0,.55)`
