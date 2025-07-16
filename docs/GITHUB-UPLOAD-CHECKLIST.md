# GitHub Upload Checklist für SmartKI Projekte

## ✅ Vor dem Upload prüfen

### 1. Sensible Daten entfernt
- [ ] API-Keys und Tokens entfernt/maskiert
- [ ] Passwörter entfernt/maskiert
- [ ] IP-Adressen anonymisiert (falls nötig)
- [ ] E-Mail-Adressen geprüft
- [ ] Private URLs entfernt

### 2. Dateien bereinigt
- [ ] Duplikate entfernt
- [ ] Temporäre Dateien gelöscht
- [ ] Veraltete Dokumentation aktualisiert
- [ ] `.gitignore` aktualisiert

### 3. Dokumentation vollständig
- [ ] README.md vorhanden und aktuell
- [ ] CHANGELOG.md gepflegt
- [ ] Installation-Anleitung vorhanden
- [ ] API-Dokumentation (falls zutreffend)
- [ ] Lizenz-Datei vorhanden

## 📁 Sichere Dateien für Upload

### Haupt-Dokumentation
- ✅ `SMARTKI-DOCUMENTATION.md` - Vollständige Projekt-Übersicht
- ✅ `NEUSTART-CONSOLIDATED.md` - Einheitlicher Restart-Guide
- ✅ `README.md` - Projekt-Hauptseite
- ✅ `CHANGELOG.md` - Versions-Historie
- ✅ `PUBLIC-RELEASE.md` - Öffentliche Release Notes

### Technische Dokumentation
- ✅ `SMARTKI-ECOSYSTEM.md` - System-Architektur
- ✅ `SIMPLYKI-PERFORMANCE-ROADMAP.md` - Performance-Optimierung
- ✅ `SIMPLYKI-REBRANDING-STRATEGY.md` - Branding-Strategie
- ✅ `CONTINUOUS-LOGGING-STATUS.md` - Logging-System
- ✅ `GITHUB-COMMANDS.md` - Git-Befehle
- ✅ `GITHUB-SETUP.md` - Repository-Setup

### Bereinigte Versionen
- ✅ `CLAUDE-NEUSTART-PUBLIC.md` - Ohne API-Keys
- ✅ `NEUSTART-PROMPT-PANGOLIN-PUBLIC.md` - Ohne Passwörter

## 🚫 NICHT hochladen

### Private Konfiguration
- ❌ `CLAUDE.local.md` - Private Anweisungen
- ❌ Alle Dateien mit `.local` Endung
- ❌ `/local/` Verzeichnis komplett

### Dateien mit sensiblen Daten
- ❌ Original `CLAUDE-NEUSTART.md` (enthält API-Keys)
- ❌ Original `NEUSTART-PROMPT-PANGOLIN.md` (enthält Passwort)
- ❌ `kanboard-api-setup.md` (prüfen auf API-Keys)

### Temporäre/Veraltete Dateien
- ❌ Alles im `zu_loeschen/` Ordner
- ❌ `*.tmp`, `*.bak`, `*.old` Dateien
- ❌ Build-Artefakte und Logs

## 📝 GitHub Repository Struktur

### Empfohlene Repository-Aufteilung

1. **ai-collab** (Hauptsystem)
   ```
   README.md
   CHANGELOG.md
   LICENSE
   .gitignore
   core/
   docs/
   integration/
   ```

2. **SmartKI** (Backend)
   ```
   README.md
   package.json
   src/
   tests/
   docs/
   ```

3. **SmartKI-web** (Frontend)
   ```
   README.md
   package.json
   src/
   public/
   docs/
   ```

4. **SmartKI-Obsidian** (Knowledge Base)
   ```
   README.md
   plugins/
   templates/
   docs/
   ```

5. **SmartKI-Pangolin** (Gateway)
   ```
   README.md
   docker-compose.yml
   config/
   docs/
   ```

## 🔒 Sicherheits-Checkliste

### Vor jedem Commit
```bash
# Sensible Daten suchen
grep -r "password\|token\|key\|secret" --exclude-dir=node_modules .

# Große Dateien finden
find . -type f -size +1M -ls

# Git Status prüfen
git status
git diff --cached
```

### .gitignore Einträge prüfen
```bash
# Sicherstellen dass .gitignore funktioniert
git check-ignore local/config/api-keys.local
git check-ignore CLAUDE.local.md
```

## 🚀 Upload-Prozess

1. **Lokale Bereinigung**
   ```bash
   # Zu löschende Dateien entfernen
   rm -rf zu_loeschen/
   
   # Git Cache leeren (falls nötig)
   git rm -r --cached .
   git add .
   ```

2. **Repository vorbereiten**
   ```bash
   # Neues Repo oder existierendes nutzen
   git remote add origin https://github.com/stlas/[REPO-NAME].git
   
   # Branch erstellen
   git checkout -b main
   ```

3. **Commit und Push**
   ```bash
   # Commit mit aussagekräftiger Nachricht
   git commit -m "Initial SmartKI [Component] setup with documentation"
   
   # Push zum Repository
   git push -u origin main
   ```

4. **Nach dem Upload**
   - Repository-Einstellungen prüfen
   - README im Browser kontrollieren
   - Sensible Daten nochmals prüfen
   - Issues/Projects aktivieren falls gewünscht

## 📋 Finale Checkliste

- [ ] Alle sensiblen Daten entfernt
- [ ] .gitignore funktioniert korrekt
- [ ] Dokumentation vollständig und aktuell
- [ ] Lizenz ausgewählt (MIT empfohlen)
- [ ] Repository-Beschreibung hinzugefügt
- [ ] Topics/Tags gesetzt
- [ ] Erste Release erstellt

---

**Wichtig**: Diese Checkliste vor JEDEM Upload durchgehen!