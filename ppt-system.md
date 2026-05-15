# Multiversum PPT — HTML Slide System

## Architecture

Every Multiversum presentation is a self-contained HTML file with:
- CSS variable design system (7 color tokens)
- Full-screen slides (100vw × 100vh) with keyboard/arrow navigation
- Fixed progress bar (top), logo (top-left), slide counter (top-right)
- PDF export button (bottom-right, shows on hover)
- Responsive typography via `clamp()`

## CSS Foundation (copy into every new presentation)

```html
<style>
:root{--y:#F2FF62;--c:#333333;--o:#3C6E89;--w:#FFFFFF;--s:#5D6269;--sv:#A4A7AB;--l:#F5F5F3;--t:#3C6E89;--f:'Arial','Helvetica Neue',sans-serif}
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:var(--f);background:#111;overflow:hidden;width:100vw;height:100vh}

/* Progress bar */
#prog{position:fixed;top:0;left:0;height:3px;background:var(--y);width:0;transition:width .5s ease;z-index:1000}

/* Slides */
.slide{position:absolute;inset:0;display:flex;flex-direction:column;justify-content:center;padding:60px 80px;opacity:0;pointer-events:none;transition:opacity .5s ease}
.slide.active{opacity:1;pointer-events:all}

/* Backgrounds */
.bg-d{background:linear-gradient(145deg,#464646 0%,#1c1c1c 100%);color:#fff}
.bg-w{background:#fff;color:#333}
.bg-l{background:#f5f5f3;color:#333}
.bg-y{background:#F2FF62;color:#333}
.bg-g{background:linear-gradient(145deg,#404040 0%,#1a1a1a 100%);color:#fff}

/* Logo (top-left) */
.logo{position:fixed;top:20px;left:28px;z-index:100;width:38px;height:38px;background:var(--y);border-radius:8px;display:flex;align-items:center;justify-content:center}

/* Nav dots */
.dots{position:fixed;bottom:20px;left:50%;transform:translateX(-50%);display:flex;gap:7px;z-index:100}
.dot{width:7px;height:7px;border-radius:50%;background:rgba(255,255,255,.25);cursor:pointer;transition:.3s}
.dot.on{width:22px;border-radius:3px;background:var(--y)}
.dot.light{background:rgba(0,0,0,.18)}.dot.light.on{background:#333}

/* Arrow nav */
.arr{position:fixed;top:50%;transform:translateY(-50%);width:44px;height:44px;border-radius:50%;background:rgba(255,255,255,.08);backdrop-filter:blur(8px);border:none;cursor:pointer;color:#fff;font-size:16px;display:flex;align-items:center;justify-content:center;transition:.3s;z-index:100}
.arr:hover{background:rgba(242,255,98,.25)}.arr.prev{left:18px}.arr.next{right:18px}

/* Counter */
.ctr{position:fixed;top:24px;right:28px;font-size:10px;letter-spacing:2px;opacity:.4;z-index:100}

/* Grid layouts */
.fw{display:grid;grid-template-columns:1fr;max-width:1200px;width:100%}
.two{display:grid;grid-template-columns:1fr 1fr;gap:44px;max-width:1200px;width:100%}
.three{display:grid;grid-template-columns:1fr 1fr 1fr;gap:28px;max-width:1200px;width:100%}
.side{display:grid;grid-template-columns:1fr 420px;gap:52px;max-width:1260px;width:100%}
.sg{display:grid;grid-template-columns:repeat(4,1fr);gap:28px;max-width:1200px;width:100%}

/* Typography */
.ey{font-size:11px;letter-spacing:3px;text-transform:uppercase;opacity:.55}
h1{font-size:clamp(34px,5vw,68px);font-weight:900;letter-spacing:-2px;line-height:1.02}
h2{font-size:clamp(22px,3.2vw,44px);font-weight:800;letter-spacing:-1px;line-height:1.1}
h3{font-size:clamp(14px,1.8vw,20px);font-weight:700;line-height:1.3}
.lead{font-size:clamp(14px,1.8vw,22px);font-weight:300;line-height:1.5;max-width:760px}
p,li{font-size:clamp(12px,1.3vw,16px);line-height:1.6}

/* Cards */
.rc{background:rgba(255,255,255,.03);border:1px solid rgba(255,255,255,.07);border-radius:10px;padding:22px;transition:.3s}
.rc:hover{border-color:rgba(242,255,98,.3)}
.rc.light{background:rgba(0,0,0,.03);border-color:rgba(0,0,0,.08)}

/* Architecture stack */
.al{padding:15px 22px;border-radius:8px;border-left:3px solid transparent}
.al1{background:rgba(242,255,98,.1);border-left-color:#F2FF62}
.al2{background:rgba(242,107,67,.1);border-left-color:#F26B43}
.al3{background:rgba(60,110,137,.18);border-left-color:#3C6E89}
.al4{background:rgba(255,255,255,.05);border-left-color:#A4A7AB}

/* Takeaway boxes */
.taw{padding:18px 24px;border-radius:0 8px 8px 0;font-style:italic;border-left:4px solid}
.taw-y{border-left-color:#F2FF62;background:rgba(242,255,98,.07);color:#F2FF62}
.taw-o{border-left-color:#F26B43;background:rgba(242,107,67,.07);color:#F26B43}

/* Chapter number watermark */
.ch-big{position:absolute;right:56px;bottom:36px;font-size:clamp(100px,18vw,220px);font-weight:900;opacity:.12;line-height:.8;letter-spacing:-6px;color:var(--y);pointer-events:none}
.bg-w .ch-big,.bg-l .ch-big{color:#333;opacity:.07}

/* Badge */
.sbadge{background:#F2FF62;color:#333;font-size:9px;font-weight:700;padding:3px 9px;border-radius:18px}

/* Animations */
@keyframes fu{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)}}
.fade-up{animation:fu .55s ease forwards}
.d1{animation-delay:.08s}.d2{animation-delay:.14s}.d3{animation-delay:.19s}.d4{animation-delay:.23s}
</style>
```

## Logo — Pflichtbestandteile jeder Präsentation

### M-Symbol oben links (jede Folie)

Direkt nach `<body>` einfügen — **vor** dem ersten `.slide`:

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

### Wordmark MULTIVERSUM (nur Deckblatt, prominent)

Auf dem Cover-Slide als erste visuelle Einheit, vor `h1`:

```html
<div style="margin-bottom:28px">
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

**Weitere Logo-Varianten:** `http://172.16.20.20/catalog/catalog.html` → Abschnitt "Offizielle Logos"

## Navigation JavaScript (copy into every presentation)

```html
<script>
const slides = document.querySelectorAll('.slide');
const dots = document.querySelectorAll('.dot');
const ctr = document.querySelector('.ctr');
const prog = document.getElementById('prog');
let cur = 0;

function go(n) {
  slides[cur].classList.remove('active');
  dots[cur].classList.remove('on');
  cur = (n + slides.length) % slides.length;
  slides[cur].classList.add('active');
  dots[cur].classList.add('on');
  prog.style.width = ((cur + 1) / slides.length * 100) + '%';
  if(ctr) ctr.textContent = (cur+1) + ' / ' + slides.length;
}

document.addEventListener('keydown', e => {
  if(e.key==='ArrowRight'||e.key==='ArrowDown') go(cur+1);
  if(e.key==='ArrowLeft'||e.key==='ArrowUp') go(cur-1);
});
dots.forEach((d,i) => d.addEventListener('click',()=>go(i)));
document.querySelector('.arr.next')?.addEventListener('click',()=>go(cur+1));
document.querySelector('.arr.prev')?.addEventListener('click',()=>go(cur-1));
go(0);
</script>
```

## Slide Structure Templates

### Cover Slide (bg-d)
```html
<section class="slide bg-d active">
  <div class="ch-big">01</div>
  <p class="ey fade-up" style="color:var(--y);margin-bottom:16px">PROPOSAL · 2026</p>
  <h1 class="fade-up d1">Project Title</h1>
  <p class="lead fade-up d2" style="opacity:.7;margin-top:20px">Subtitle or tagline here</p>
  <div class="fade-up d3" style="display:flex;gap:16px;margin-top:40px;opacity:.45;font-size:12px">
    <span>CLIENT NAME</span>
    <span>·</span>
    <span>DATE</span>
  </div>
</section>
```

### Content Slide — Two Column (bg-w)
```html
<section class="slide bg-w">
  <p class="ey" style="color:var(--o);margin-bottom:12px">SECTION LABEL</p>
  <h2 style="margin-bottom:28px">Slide Title</h2>
  <div class="two">
    <div>
      <h3 style="margin-bottom:12px">Left Column</h3>
      <p>Content here.</p>
    </div>
    <div class="rc light">
      <h3 style="margin-bottom:12px">Right Panel</h3>
      <p>Content here.</p>
    </div>
  </div>
</section>
```

### Architecture/Stack Slide (bg-d)
```html
<section class="slide bg-d">
  <p class="ey" style="color:var(--y);margin-bottom:12px">ARCHITECTURE</p>
  <h2 style="margin-bottom:28px">System Stack</h2>
  <div style="display:flex;flex-direction:column;gap:10px;max-width:800px">
    <div class="al al1"><strong>Frontend Layer</strong> — React, TypeScript</div>
    <div class="al al2"><strong>API Layer</strong> — Node.js, REST/GraphQL</div>
    <div class="al al3"><strong>Data Layer</strong> — PostgreSQL, Redis</div>
    <div class="al al4"><strong>Infrastructure</strong> — Docker, nginx</div>
  </div>
</section>
```

### Stats Slide (bg-g)
```html
<section class="slide bg-g">
  <p class="ey" style="color:var(--y);margin-bottom:16px">KEY METRICS</p>
  <h2 style="margin-bottom:36px">Results at a Glance</h2>
  <div class="sg">
    <div style="text-align:center">
      <div style="font-size:clamp(40px,6vw,72px);font-weight:900;color:var(--y);line-height:1">94%</div>
      <p class="ey" style="margin-top:8px">Customer Satisfaction</p>
    </div>
    <!-- repeat for each stat -->
  </div>
</section>
```

### Takeaway/Closing Slide (bg-d)
```html
<section class="slide bg-d">
  <div style="max-width:800px">
    <p class="ey" style="color:var(--y);margin-bottom:16px">KEY TAKEAWAY</p>
    <h1 style="margin-bottom:32px">Main conclusion here.</h1>
    <div class="taw taw-o">
      Supporting detail or call to action text in italic style.
    </div>
  </div>
</section>
```

## Standard Deck Sequence

```
Slide 1:  Cover          → bg-d  (title, client, date)
Slide 2:  Agenda         → bg-l  (overview of topics)
Slide 3:  Challenge      → bg-d  (problem statement)
Slide 4:  Solution       → bg-w  (our approach)
Slide 5:  Architecture   → bg-d  (technical stack if relevant)
Slide 6:  Benefits       → bg-w  (2-3 column cards)
Slide 7:  Process        → bg-g  (timeline or phases)
Slide 8:  Team           → bg-l  (people)
Slide 9:  Pricing        → bg-w  (table)
Slide 10: Next Steps     → bg-d  (CTA + contact)
```

## Complete HTML Boilerplate

```html
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>TITLE — Multiversum GmbH</title>
<!-- [PASTE CSS FOUNDATION HERE] -->
</head>
<body>

<div id="prog"></div>

<!-- Logo -->
<div class="logo">
  <img src="PATH_TO_LOGO" width="26" height="26" style="filter:brightness(0)">
</div>

<!-- Slide counter -->
<span class="ctr"></span>

<!-- Navigation dots (one per slide) -->
<div class="dots">
  <div class="dot"></div>
  <!-- repeat -->
</div>

<!-- Arrow navigation -->
<button class="arr prev">←</button>
<button class="arr next">→</button>

<!-- SLIDES GO HERE -->

<!-- [PASTE NAVIGATION JAVASCRIPT HERE] -->
</body>
</html>
```
