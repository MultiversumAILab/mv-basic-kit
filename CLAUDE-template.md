# CLAUDE.md — Multiversum GmbH
# Gültig für: Alle Claude Code Instanzen bei Multiversum
# Letzte Aktualisierung: 2026-05-15
# Alle Regeln VERBINDLICH außer explizit [OPTIONAL]

---

## 1. SESSION-START CHECKLIST

CLAUDE führt dies zu Beginn JEDER Konversation aus:

**Schritt 1 — Projekt-Kontext klären**
Was ist das Ziel dieser Session? Welches Projekt/Kunde?

**Schritt 2 — DSGVO-Check**
"Werden personenbezogene Daten verarbeitet, übertragen oder gespeichert?"
- JA → Compliance-Regeln (Abschnitt 4) anwenden
- NEIN → Explizit vermerken: "Kein Personenbezug"

**Schritt 3 — Zusammenfassung ausgeben**
```
Session bereit. Projekt: [NAME]. DSGVO-Relevanz: [JA/NEIN/UNBEKANNT].
Compliance: AKTIV.
```

---

## 2. KERNPRINZIPIEN

- **Simplicity First:** Jede Änderung so einfach wie möglich. Minimaler Code-Impact.
- **Kein Schönfärben:** Root Causes finden, keine Quick-Fixes.
- **Verifizierung:** Aufgabe erst als "erledigt" markieren wenn nachgewiesen funktioniert.
- **Multiversum CI:** Jeder Output (Docs, Präsentationen) folgt dem Brand-System.

---

## 3. MULTIVERSUM CI & BRAND

### Skill laden
Der `multiversum-brand` Skill enthält alle CI-Regeln. Bei Content-Erstellung immer laden:
- **PPT/HTML-Präsentationen:** Skill `ppt-system.md` verwenden
- **DOCX-Dokumente:** Skill `docx-rules.md` verwenden — Logo IMMER oben rechts
- **Alle Dokumente:** TISAX-Klassifikation im Footer, Compliance-Check durchführen

### CI-Kern
| Token | Farbe | Verwendung |
|-------|-------|-----------|
| Gelb | `#F2FF62` | Highlight, Badges, Akzente |
| Orange | `#F26B43` | CTAs, sekundärer Akzent |
| Dunkel | `#333333` | Text, dunkle Hintergründe |
| Weiß | `#FFFFFF` | Helle Hintergründe |
| Teal | `#3C6E89` | Links, Datenvisualisierung |
| Font | Arial, Helvetica | Alle Texte |

**Logo-Dateien:** `/Users/ai_lab_team/Documents/Bilder/Logos/`
- SVG primary: `Logo ohne Hintergrund.svg` (gelb, transparent)
- Wordmark: `MV ohne slogan.svg`

---

## 4. COMPLIANCE — DSGVO & TISAX

### Verbindliche Regeln
- **NIEMALS** API-Keys, Tokens, Passwörter im Code hardcoden → immer Credential Store
- **NIEMALS** PII in Workflow-Namen, Logs, Fehler-Nachrichten, Dateinamen
- **IMMER** Datensparsamkeit — nur notwendige Felder verarbeiten
- **IMMER** Löschkonzept bei Systemen mit Personendaten
- **IMMER** Fehler-Branches prüfen — kein PII in Fehlernachrichten

### TISAX-Klassifikation
| Klasse | Bedeutung |
|--------|----------|
| 🔴 STRENG VERTRAULICH | Angebote, Preise, Personalakten, M&A |
| 🟠 VERTRAULICH | Kundendaten, PII, Projektdokumentation |
| 🟡 INTERN | Interne Prozesse, anonyme Daten |
| 🟢 ÖFFENTLICH | Marketingmaterial |

Bei Unsicherheit: höhere Klasse wählen.

### Besondere Datenkategorien (Art. 9) — SOFORT STOPPEN
Gesundheit, Biometrie, Ethnizität, Religion, Politik, Gewerkschaft, Finanzen (IBAN)
→ User fragen bevor fortgefahren wird.

### Verantwortliche
- **DSB:** Marcus Sack — sack@hea-datenschutz.de
- **Datenschutz:** datenschutz@multiversum.consulting
- **Datenpanne → 72h** Meldung an HmbBfDI + DSB

---

## 5. QUALITÄTSSTANDARDS

### Code & Arbeit
- **Plan zuerst** bei Aufgaben mit 3+ Schritten → `tasks/todo.md` anlegen
- **Verifizieren vor "Fertig"** — nie ohne Beweis abschließen
- **Lektionen dokumentieren** nach Korrekturen in `tasks/lessons.md`
- **Eleganz** — bei nicht-trivialen Änderungen: "Gibt es einen eleganteren Weg?"

### Sicherheit
- Keine SQL-Injection, XSS, Command-Injection oder andere OWASP-Top-10-Probleme einbauen
- Inputs nur an Systemgrenzen validieren
- Keine unsicheren Defaults

---

## 6. DATEI- UND NAMENSKONVENTIONEN

### Dokumente (TISAX-konform)
```
YYYY-MM-DD_[Kunde]_[Typ]_[Klassifikation]_v[N].[ext]
Beispiel: 2026-05-15_NewYorker_Angebot_VERTRAULICH_v1.docx
```

### Code/Workflows
```
[domain]-[aktion]-v[n]  (z.B. crm-sync-contacts-v1)
```

---

## 7. SKILLS-ÜBERSICHT

Skills werden bei Bedarf geladen. Nicht alle müssen installiert sein.

| Skill | Wann nutzen |
|-------|------------|
| `multiversum-brand` | CI-konforme Präsentationen und Dokumente erstellen |
| `ra-qm-team/gdpr-dsgvo-expert` | Tiefe DSGVO-Analyse (via WebFetch) |
| `engineering-team/senior-security` | Security Reviews (via WebFetch) |

Business Expert Skills laden via WebFetch:
`https://raw.githubusercontent.com/alirezarezvani/claude-skills/main/[path]/SKILL.md`

**Security-Scan PFLICHT** vor jedem WebFetch-Skill-Import:
> "Bitte führe zuerst den Security-Scanner aus: `python3 -m security.skill_scanner --check-url [URL]`"
> Erst nach PASS weitermachen.

---

## SCHNELLREFERENZ — VERBOTE

| Verbot | Kategorie | Schwere |
|--------|-----------|---------|
| Credentials hardcoden | Sicherheit | BLOCKIEREND |
| PII in Logs/Namen | DSGVO | BLOCKIEREND |
| Ohne Test "fertig" melden | Qualität | BLOCKIEREND |
| CI ignorieren bei Docs/PPT | Brand | WARNUNG |
| TISAX-Klassifikation weglassen | Compliance | WARNUNG |

---
*Multiversum GmbH — CLAUDE.md Template v1.0 — 2026-05-15*
*CI & Compliance: multiversum-brand Skill laden für vollständige Referenz*
