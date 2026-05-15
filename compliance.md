# Multiversum DSGVO + TISAX — Compliance Quick Reference

## Mandatory First Question (Every Project)

**Before creating any document, workflow, or system:**
> "Werden in diesem Projekt personenbezogene Daten verarbeitet, übertragen oder gespeichert?"

- **JA** → Apply all rules in this document. Load `ra-qm-team/gdpr-dsgvo-expert` skill if available.
- **NEIN** → Document explicitly: *"Kein Personenbezug im Projekt."*

---

## TISAX Data Classification

Every document and dataset must be classified. Mark classification in document footer.

| Level | Label | Examples | Protection |
|-------|-------|----------|-----------|
| 🔴 **STRENG VERTRAULICH** | Strictly Confidential | Angebote mit Preisen, M&A-Informationen, Personalakten | End-to-end encryption, need-to-know, no cloud storage |
| 🟠 **VERTRAULICH** | Confidential | Kundendaten, PII (Name, Email, Telefon), Projektdokumentation mit Kundenbezug | Encrypted storage, access control, NDA required |
| 🟡 **INTERN** | Internal | Interne Prozesse, anonymisierte Scores, allgemeine Projektdaten | Standard access control, not for public sharing |
| 🟢 **ÖFFENTLICH** | Public | Marketingmaterial, öffentliche Präsentationen | No restrictions |

**Rule:** When in doubt, classify UP (more restrictive).

---

## DSGVO — Pflichtchecks vor Aktivierung

### Vor jedem System/Workflow mit Personenbezug:
- [ ] **Rechtsgrundlage** dokumentiert (Art. 6 Abs. 1 DSGVO)
  - Einwilligung (a) | Vertrag (b) | Rechtspflicht (c) | Berechtigtes Interesse (f)
- [ ] **Datensparsamkeit** angewendet — nur notwendige Felder verarbeitet
- [ ] **PII nicht in** Workflow-/Dateinamen, Logs, Fehlermeldungen, Webhook-Antworten
- [ ] **Verschlüsselte Credentials** — keine Hardcoding, immer Credential Store
- [ ] **Löschkonzept** vorhanden — wann und wie werden Daten gelöscht/anonymisiert
- [ ] **Fehler-Branches** geben keine PII weiter (kein Stack-Trace mit Personendaten)
- [ ] Dokument/System mit `[dsgvo-geprüft]` markiert nach Abschluss

### Besondere Kategorien (Art. 9 DSGVO) — STOP + User-Bestätigung erforderlich:
Gesundheitsdaten · Biometrie · Ethnische Herkunft · Politische Meinungen · Religiöse Überzeugungen · Gewerkschaftszugehörigkeit · Genetische Daten · Sexuelle Orientierung · Finanzdaten (IBAN, Kreditkarte)

→ **Sofort stoppen und User fragen, bevor weitergemacht wird.**

### DSFA erforderlich (Art. 35 DSGVO) — SOFORT melden:
- Systematische Überwachung von Personen
- Besondere Kategorien (Art. 9) in großem Maßstab
- Automatisierte Einzelentscheidungen mit erheblicher Wirkung

---

## ISMS / TISAX — Technische Mindestanforderungen

### Für alle Projekte mit VERTRAULICH oder höher:
| Maßnahme | Anforderung |
|----------|-------------|
| **Zugriffskontrolle** | RBAC, Need-to-Know-Prinzip |
| **Authentifizierung** | MFA für alle Systemzugriffe |
| **Verschlüsselung** | TLS 1.2+ für alle Übertragungen |
| **Credentials** | Kein Hardcoding — immer verschlüsselter Credential Store |
| **Audit-Trail** | Zugriffs- und Änderungsprotokoll |
| **Datensicherung** | Regelmäßige Backups, getestet |
| **Löschkonzept** | Definierte Fristen + automatisierte Ausführung |
| **Drittanbieter** | DPA (Auftragsverarbeitungsvertrag) vorhanden |

### Für US-Anbieter (OpenAI, Apollo, HarvestAPI etc.):
- SCCs (Standardvertragsklauseln) oder DPF-Zertifizierung prüfen
- Transfer Impact Assessment bei STRENG VERTRAULICH Daten

---

## Verantwortliche (Multiversum GmbH)

| Rolle | Person | Kontakt |
|-------|--------|---------|
| Verantwortlicher (Art. 4 Nr. 7) | Robert Grimm | datenschutz@multiversum.consulting |
| Datenschutzbeauftragter (extern) | Tabea Bleckert | — |
| Datenschutzkoordinatoren | Evelyn Hoffart, Tabea Bleckert | — |
| Aufsichtsbehörde | HmbBfDI Hamburg | — |

---

## 72h Meldepflicht (Art. 33 DSGVO)

Bei Datenpanne → **innerhalb 72h** an Aufsichtsbehörde melden:
1. Was ist passiert? (Kategorien, Anzahl Betroffene)
2. DSB-Kontaktdaten
3. Wahrscheinliche Folgen
4. Ergriffene/geplante Maßnahmen

→ Sofortige Eskalation an datenschutz@multiversum.consulting + Tabea Bleckert (DSB)

---

## Dokument-Benennung (TISAX-konform)

```
YYYY-MM-DD_[Kunde/Projekt]_[Dokumenttyp]_[Klassifikation]_v[N].[ext]

Beispiele:
2026-05-15_NewYorker_Angebot_VERTRAULICH_v1.docx
2026-05-15_Intern_Prozessbeschreibung_INTERN_v2.pdf
2026-05-15_Multiversum_Datenschutzinfo_OEFFENTLICH_v1.pdf
```
