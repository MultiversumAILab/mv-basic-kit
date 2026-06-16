# AGENTS.md — Multiversum GmbH

Context file auto-loaded by Codex, Cursor and Pi. Copy to a project root as `AGENTS.md` and merge with
project-specific instructions. For full Multiversum CI/DSGVO rules, load the `multiversum-brand` skill
(see `SKILL.md`); for Claude Code use `CLAUDE-template.md`.

## Coding-Verhalten (Karpathy-Leitlinien)

Allgemeines Coding-Verhalten, gilt bei JEDER Code-Aufgabe. Volle Fassung: `coding-guidelines.md` im
`multiversum-brand` Skill. Quelle: Andrej-Karpathy-Coding-Guidelines via
`multica-ai/andrej-karpathy-skills`.

1. **Erst denken, dann coden:** Annahmen explizit nennen; bei Unklarheit STOPP und nachfragen; mehrere
   Interpretationen offenlegen statt still eine zu wählen; einfachere Wege ansprechen.
2. **Simplicity First:** minimaler Code, der das Problem löst; nichts Spekulatives (keine ungefragten
   Features/Abstraktionen/„Flexibilität"/Error-Handling für unmögliche Fälle). „Würde ein Senior das
   überkompliziert nennen?" → vereinfachen.
3. **Chirurgische Änderungen:** nur anfassen, was nötig ist; angrenzenden Code nicht „verbessern",
   umformatieren oder refactoren; bestehenden Stil treffen; nur selbst erzeugte Orphans entfernen,
   vorbestehenden toten Code nur erwähnen. Jede geänderte Zeile führt direkt auf den Auftrag zurück.
4. **Zielgetrieben ausführen:** Aufgaben in verifizierbare Ziele übersetzen (Tests/Checks), kurzen
   Schritt-Plan mit Verifikation, bis grün loopen.

## Sicherheit & DSGVO (Kurz)

- Keine Secrets/API-Keys/Tokens hardcoden oder im Klartext loggen — Credential-/Env-Store nutzen.
- Keine personenbezogenen Daten in Datei-/Projektnamen, Commit-Messages, Logs oder kundenseitige Outputs.
- Root Cause vor Quick-Fix. Keine Erfolgsmeldung ohne Verifikation. Minimaler, sauberer Eingriff.

> Cursor liest `AGENTS.md` direkt; ältere Cursor-Versionen ggf. zusätzlich `.cursorrules` (denselben
> Inhalt dorthin kopieren).
