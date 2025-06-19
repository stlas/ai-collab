# ai-collab Development Workflow

## Übersicht

Dieser Guide beschreibt den **vollständigen Entwicklungsworkflow** mit ai-collab v2.1.0 - von der Projektinitialisierung bis zum Release-Management mit integriertem PM-System und Prämissen-Dokumentation.

## 🚀 Phase 1: Projekt-Setup

### 1.1 System-Initialisierung
```bash
# Repository klonen (falls noch nicht geschehen)
git clone https://github.com/sTLAs/ai-collab.git
cd ai-collab

# ai-collab System initialisieren
./core/src/ai-collab.sh init

# Vollständige Diagnose durchführen
./core/src/ai-collab.sh diagnose
```

**Ergebnis:** System bereit, alle Module verfügbar

### 1.2 API-Konfiguration
```bash
# Interaktive API-Setup
./core/src/ai-collab.sh setup-api

# Alternativ: Manuell .env editieren
cp local/config/.env.template local/config/.env
# ANTHROPIC_API_KEY=dein-key-hier setzen
```

**Ergebnis:** KI-Features aktiviert, Kostenoptimierung verfügbar

### 1.3 Projekt hinzufügen
```bash
# Dein Projekt zu ai-collab hinzufügen
./core/src/ai-collab.sh add-project /pfad/zu/deinem/projekt MeinProjekt

# Prüfen
./core/src/ai-collab.sh status
```

**Ergebnis:** Projekt in ai-collab integriert

### 1.4 GitHub-Integration (Optional)
```bash
# Vollautomatisches GitHub-Setup
./core/src/ai-collab.sh github-setup

# Führt durch:
# ✅ GitHub CLI Installation
# ✅ Authentication
# ✅ Git-Konfiguration
# ✅ Repository-Verbindung
```

**Ergebnis:** Automatische Commits/Releases möglich

## 🧠 Phase 2: Entwicklungsphilosophie definieren

### 2.1 Prämissen-System initialisieren
```bash
# Prämissen-Management starten
./core/src/ai-collab.sh premises init

# Erste Prämissen anzeigen (auto-generiert)
./core/src/ai-collab.sh premises show
```

**Ergebnis:** 5 Standard-Prämissen verfügbar

### 2.2 Projekt-spezifische Prämissen
```bash
# Technische Prinzipien
./core/src/ai-collab.sh premises add "Performance vor Eleganz" technical "Schnelle Iteration wichtiger als perfekter Code"

# Benutzer-Erfahrung
./core/src/ai-collab.sh premises add "User-Experience First" user_experience "Nutzer steht im Mittelpunkt aller Entscheidungen"

# Wirtschaftliche Ziele
./core/src/ai-collab.sh premises add "Budget-Transparenz" economic "Alle Kosten müssen nachvollziehbar sein"

# Operative Regeln
./core/src/ai-collab.sh premises add "Dokumentation parallel" operational "Code und Docs werden gleichzeitig entwickelt"
```

**Ergebnis:** Projekt-DNA dokumentiert

### 2.3 Baseline-Snapshot
```bash
# Projektstart-Snapshot erstellen
./core/src/ai-collab.sh premises snapshot "Projektstart - Grundlegende Prämissen definiert"

# Historie prüfen
./core/src/ai-collab.sh premises history
```

**Ergebnis:** Versionierte Prämissen-Baseline für Drift-Detection

## 🔄 Phase 3: Entwicklungszyklen

### 3.1 Session starten
```bash
# Neue Session für Feature-Entwicklung
./core/src/session-manager.sh init "login_system" "MeinProjekt"

# Session-Parameter setzen
./core/src/session-manager.sh set model "claude-3.5-sonnet"
./core/src/session-manager.sh set cost_budget "15.00"
./core/src/session-manager.sh context "current_feature" "Benutzer-Authentifizierung implementieren"

# Session-Status prüfen
./core/src/session-manager.sh show
```

**Ergebnis:** Persistente Entwicklungsumgebung bereit

### 3.2 KI-gestützte Entwicklung
```bash
# Zum Projektverzeichnis wechseln
cd projects/MeinProjekt  # Oder direkt zu deinem Projekt

# Feature-Entwicklung mit KI-Optimierung
./path/to/ai-collab/core/src/ai-collab.sh optimize "Login-System mit JWT-Token implementieren" feature_development medium

# Code-Review durchführen
./path/to/ai-collab/core/src/ai-collab.sh optimize "Review login implementation for security issues" code_review high

# Bug-Fix (kostengünstig mit Haiku)
./path/to/ai-collab/core/src/ai-collab.sh optimize "Fix validation error in login form" bug_fix low
```

**Ergebnis:** Kostenoptimierte KI-Entwicklung

### 3.3 Prämissen-Updates bei wichtigen Entscheidungen
```bash
# Neue Sicherheits-Prämisse nach Login-System
./path/to/ai-collab/core/src/ai-collab.sh premises add "Sicherheit vor Convenience" security "Login-System braucht 2FA und starke Passwörter"

# Session-Kontext aktualisieren
./path/to/ai-collab/core/src/session-manager.sh context "security_decision" "2FA als Standard etabliert"
```

**Ergebnis:** Entwicklungsphilosophie-Evolution dokumentiert

### 3.4 PM-System Synchronisation
```bash
# Alle Daten zum PM-System exportieren
./path/to/ai-collab/integration/pm-system/ai-collab-pm-integration.sh export

# Todo-Liste synchronisieren (falls du eine führst)
./path/to/ai-collab/integration/pm-system/todo-sync.sh sync

# PM-Status prüfen
./path/to/ai-collab/integration/pm-system/pm-analyzer.sh full
```

**Ergebnis:** Stakeholder haben aktuellen Entwicklungsstand

## 📊 Phase 4: Monitoring & Qualitätssicherung

### 4.1 System-Gesundheit prüfen
```bash
# Vollständige Diagnose
./core/src/ai-collab.sh diagnose

# Ausgabe analysieren:
# ✅ System-Komponenten
# ✅ Session-Analyse  
# ✅ PM-Integration
# ✅ API-Tests
# ✅ Template-Validierung
# ✅ Budget-Analyse
```

**Prüfe besonders:**
- Verbleibendes Budget
- Session-Anzahl (cleanup bei Bedarf)
- PM-System Status

### 4.2 Prämissen-Drift überwachen
```bash
# Drift-Analyse durchführen
./core/src/ai-collab.sh premises drift

# Bei Warnung: Team-Review einberufen
# Bei Confidence-Drop: Prämissen überdenken
```

**Reaktionen:**
- **Grüner Bereich**: Weiter entwickeln
- **Gelber Bereich**: Team-Diskussion
- **Roter Bereich**: Sofortiger Stopp, Prämissen-Review

### 4.3 Budget-Kontrolle
```bash
# Aktuelle Kosten prüfen
./core/src/ai-collab.sh status

# Detaillierte Kostenanalyse
./core/src/cost-optimizer.sh report daily

# Bei Budget-Warnung: Modell-Mix anpassen
./core/src/cost-optimizer.sh select-model simple_fix low normal 5.00
```

**Budget-Strategien:**
- Haiku für einfache Tasks
- Sonnet für Standard-Entwicklung  
- Opus nur bei kritischen Architekturen

## 📦 Phase 5: Release-Vorbereitung

### 5.1 Session-Cleanup
```bash
# Leere Sessions bereinigen
./core/src/session-manager.sh cleanup

# Aktuelle Session beenden
./core/src/session-manager.sh end

# Session-Snapshot für Release
./core/src/session-manager.sh snapshot "v1.2.0_release" "Login-System fertiggestellt"
```

**Ergebnis:** Saubere Session-Historie

### 5.2 Prämissen-Release-Snapshot
```bash
# Prämissen-Stand für Release dokumentieren
./core/src/ai-collab.sh premises snapshot "v1.2.0 Release - Login-System mit 2FA-Sicherheit"

# Prämissen-Evolution prüfen
./core/src/ai-collab.sh premises history
```

**Ergebnis:** Entwicklungsphilosophie-Stand dokumentiert

### 5.3 PM-System finaler Export
```bash
# Vollständigen Export für Release-Dokumentation
./integration/pm-system/ai-collab-pm-integration.sh export

# PM-Datenbank-Backup
cp ai-collab-pm/data/db.sqlite local/development/backups/pm_v1.2.0.sqlite
```

**Ergebnis:** Stakeholder-Dashboard aktuell

## 🚀 Phase 6: Release-Durchführung

### 6.1 Automatisches Release
```bash
# ai-collab automatisches Release
./core/src/ai-collab.sh release v1.2.0 "Login-System mit 2FA-Sicherheit"

# Führt automatisch durch:
# ✅ Git-Commit mit Session-Statistiken
# ✅ Git-Tag erstellen
# ✅ Release-Notes generieren
# ✅ GitHub-Release (falls konfiguriert)
```

**Alternativ: Manueller Push**
```bash
# Manuelle Kontrolle über Commits
git add .
git commit -m "v1.2.0: Login-System mit 2FA

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Auto-Push verwenden
./core/src/ai-collab.sh auto-push
```

### 6.2 Release-Dokumentation
```bash
# Release in PM-System dokumentieren
# (Automatisch durch Export-Integration)

# Prämissen-Änderungen kommunizieren
./core/src/ai-collab.sh premises show > PREMISES_v1.2.0.md
```

**Ergebnis:** Vollständig dokumentiertes Release

## 🔄 Phase 7: Kontinuierliche Iteration

### 7.1 Post-Release-Review
```bash
# Session-Statistiken analysieren
./core/src/session-manager.sh show login_system

# Kosten-Effizienz bewerten
./core/src/cost-optimizer.sh report project

# Prämissen-Review einplanen
./core/src/ai-collab.sh premises drift
```

### 7.2 Nächste Iteration vorbereiten
```bash
# Neue Session für nächstes Feature
./core/src/session-manager.sh init "user_dashboard" "MeinProjekt"

# Lektionen als Prämissen dokumentieren
./core/src/ai-collab.sh premises add "2FA-UX-Balance" user_experience "Sicherheit darf UX nicht zerstören"

# Neue Feature-Baseline
./core/src/ai-collab.sh premises snapshot "v1.2.0 Post-Release - 2FA-UX-Learnings"
```

**Ergebnis:** Kontinuierlicher Verbesserungszyklus

## 🎯 Workflow-Checkliste

### ✅ Projekt-Setup
- [ ] ai-collab initialisiert
- [ ] API konfiguriert  
- [ ] Projekt hinzugefügt
- [ ] GitHub-Integration (optional)

### ✅ Prämissen-Definition
- [ ] Prämissen-System initialisiert
- [ ] Projekt-spezifische Prinzipien hinzugefügt
- [ ] Baseline-Snapshot erstellt

### ✅ Entwicklungszyklus
- [ ] Session gestartet mit Parametern
- [ ] KI-optimierte Entwicklung
- [ ] Prämissen bei wichtigen Entscheidungen aktualisiert
- [ ] PM-System synchronisiert

### ✅ Qualitätssicherung
- [ ] System-Diagnose durchgeführt
- [ ] Prämissen-Drift überwacht
- [ ] Budget-Kontrolle eingehalten

### ✅ Release-Management
- [ ] Session-Cleanup durchgeführt
- [ ] Prämissen-Release-Snapshot
- [ ] PM-System finaler Export
- [ ] Automatisches Release

### ✅ Kontinuierliche Verbesserung
- [ ] Post-Release-Review
- [ ] Lektionen als Prämissen dokumentiert
- [ ] Nächste Iteration vorbereitet

## 🔧 Troubleshooting

### Häufige Probleme

**Problem: Session nicht gefunden**
```bash
# Lösung: Verfügbare Sessions prüfen
./core/src/session-manager.sh list
```

**Problem: API-Budget überschritten**
```bash
# Lösung: Modell-Mix anpassen
./core/src/cost-optimizer.sh select-model bug_fix low normal 2.00
```

**Problem: PM-System offline**
```bash
# Lösung: PM-System starten
cd ai-collab-pm && php -S localhost:8080
```

**Problem: Prämissen-Drift-Warnung**
```bash
# Lösung: Team-Review organisieren
./core/src/ai-collab.sh premises history
./core/src/ai-collab.sh premises show
```

**Problem: Git-Integration fehlgeschlagen**
```bash
# Lösung: GitHub-Setup erneut durchführen
./core/src/ai-collab.sh github-setup
```

## 📈 Erfolgs-Metriken

### Entwicklungseffizienz
- **Time-to-Feature**: Zeit von Idee zu funktionierendem Code
- **Code-Qualität**: Review-basierte Qualitätsbewertung
- **Bug-Rate**: Fehler pro Entwicklungsstunde
- **Refactoring-Bedarf**: Nachträgliche Änderungen

### Kostenoptimierung
- **Kosten pro Feature**: Direkte API-Kosten
- **ROI**: Zeiteinsparung vs. KI-Kosten
- **Template-Effizienz**: Wiederverwendungsrate
- **Modell-Optimierung**: Kostenreduktion durch intelligente Wahl

### Prämissen-Management
- **Prämissen-Stabilität**: Confidence-Trends
- **Team-Alignment**: Prämissen-Diskussion-Frequenz
- **Drift-Rate**: Geschwindigkeit der Philosophie-Änderungen
- **Stakeholder-Verständnis**: Prämissen-Kommunikation-Erfolg

### PM-Integration
- **Stakeholder-Engagement**: Dashboard-Usage
- **Transparenz-Index**: Informations-Verfügbarkeit
- **Koordinationsaufwand**: Zeit für Team-Abstimmung
- **Release-Qualität**: Dokumentations-Vollständigkeit

---

**Dieser Workflow macht ai-collab zu einem vollständigen Entwicklungsökosystem für KI-gestützte Softwareentwicklung.** 🚀⚙️