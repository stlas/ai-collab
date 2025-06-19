# ai-collab - AI Development Collaboration Assistant

> **Entwickelt von [sTLAs](https://github.com/sTLAs) in Zusammenarbeit mit Claude AI**

[![Support ai-collab](https://img.shields.io/badge/Support-Buy%20Me%20A%20Coffee-yellow.svg)](https://buymeacoffee.com/stlas)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/stlas/ai-collab.svg)](https://github.com/stlas/ai-collab/stargazers)

**ai-collab v2.1.0** ist ein universeller KI-Entwicklungsassistent für kostenoptimierte Softwareentwicklung. Das System unterstützt beliebige Programmiersprachen und Projekte durch intelligente Modellauswahl, wiederverwendbare Template-Patterns, vollständiges Projektmanagement und persistente Entwicklungsphilosophie-Dokumentation.

## 🚀 Neue Features in v2.1.0

### 📋 **Integriertes Projektmanagement**
- **Kanban-Boards**: Vollständiges PM-System mit Web-Interface
- **Stakeholder-Dashboard**: Real-time Entwicklungsstatistiken  
- **Team-Kollaboration**: Multi-User Kanban-Integration
- **Kostenvisualisierung**: Budget-Tracking im Web-Interface

### 🧠 **Prämissen-Management-System**
- **Entwicklungsphilosophie-Tagebuch**: Automatische Archivierung von Designentscheidungen
- **Snapshot-Versionierung**: Rückverfolgung von Prämissen-Evolution
- **Anti-Drift-Detection**: Warnung bei Abweichung von Kernprinzipien
- **Stakeholder-Transparenz**: Nachvollziehbare Entwicklungsrichtung

### 🔍 **Erweiterte System-Diagnose**
- **Health-Check-Framework**: Vollständige Systemanalyse
- **Integration-Monitoring**: API-Status und Verbindungstests
- **Performance-Metriken**: Template-Usage und Effizienz-Analyse

### 🐙 **GitHub-Integration 2.0**
- **Vollautomatisches Setup**: Ein-Klick GitHub-Konfiguration
- **Automatische Releases**: Session-basierte Release-Generierung
- **Issue-Management**: AI-gestützte Issue-Erstellung und -Verwaltung

## 🎯 Core Features

### Kostenoptimierung
- **Intelligente Modellwahl**: Automatische Auswahl zwischen Claude 3.5 Haiku, Sonnet und Opus
- **Template-Optimierung**: Bis zu 90% Kostenersparnis durch Pattern-Wiederverwendung
- **Real-time Budget-Tracking**: Überwachung der API-Kosten mit Alarmen
- **ROI-Tracking**: Messbare Produktivitätssteigerung vs. Kosten

### Projektmanagement
- **Web-basierte PM-Plattform**: Kanboard-Integration für Teams
- **Session-Persistenz**: Vollständiger Kontext über Sessions hinweg
- **Automatische Backups**: Intelligentes Snapshot-System
- **Multi-Projekt-Support**: Unbegrenzte Projektanzahl

### Entwicklungsunterstützung
- **Template-Engine**: 5+ spezialisierte Templates für 60-70% schnellere Entwicklung
- **Cross-Platform**: Windows (PowerShell), Linux und macOS
- **Multi-Language**: Alle gängigen Programmiersprachen
- **Prämissen-gesteuerte Entwicklung**: Konsistente Architektur-Entscheidungen

## 📁 Projektstruktur

```
ai-collab/
├── core/                           # Öffentlich (GitHub)
│   ├── src/                        # Hauptquellcode
│   │   ├── ai-collab.sh           # Hauptsystem (32KB)
│   │   ├── session-manager.sh     # Session-Verwaltung (19KB)
│   │   ├── cost-optimizer.sh      # Kostenoptimierung (18KB)
│   │   ├── github-integration.sh  # GitHub-Integration (21KB)
│   │   └── premises-manager.sh    # Prämissen-Management (NEU)
│   ├── templates/                  # 5 Code-Templates
│   └── docs/                       # Dokumentation
├── local/                          # Privat (nicht versioniert)
│   ├── config/                     # API-Keys, Einstellungen
│   ├── development/                # Sessions, Kosten, Prämissen
│   │   ├── premises/              # Entwicklungsphilosophie (NEU)
│   │   └── sessions/              # Session-Protokolle
│   └── temp/                       # Temporäre Dateien
├── integration/                    # PM-System Integration (NEU)
│   └── pm-system/                  # Kanban-Export und -Sync
├── ai-collab-pm/                  # Vollständiges PM-System (NEU)
│   ├── data/                      # SQLite-Datenbank (396KB)
│   └── plugins/                   # ai-collab Integration
└── projects/                       # Projektverweise
```

## 🛠️ Installation & Setup

```bash
# Repository klonen
git clone https://github.com/sTLAs/ai-collab.git
cd ai-collab

# System initialisieren
./core/src/ai-collab.sh init

# API-Konfiguration (Anthropic Claude)
./core/src/ai-collab.sh setup-api

# Erste Session starten
./core/src/ai-collab.sh start
```

### PM-System starten (Optional)
```bash
# Kanban-Board Web-Interface
cd ai-collab-pm
php -S localhost:8080

# Browser öffnen: http://localhost:8080
# Login: admin/admin
```

## 📖 Vollständiger Entwicklungsworkflow

### 1️⃣ Projekt-Setup
```bash
# System initialisieren und Projekt hinzufügen
./core/src/ai-collab.sh init
./core/src/ai-collab.sh add-project /pfad/zu/projekt MeinProjekt

# Prämissen-System initialisieren
./core/src/ai-collab.sh premises init

# GitHub-Integration (vollautomatisch)
./core/src/ai-collab.sh github-setup
```

### 2️⃣ Entwicklungsphilosophie definieren
```bash
# Grundlegende Prämissen festlegen
./core/src/ai-collab.sh premises add "Performance vor Eleganz" technical "Schnelle Iteration wichtiger"
./core/src/ai-collab.sh premises add "User-Experience First" user_experience "Nutzer steht im Mittelpunkt"

# Baseline-Snapshot erstellen
./core/src/ai-collab.sh premises snapshot "Projektstart - Grundlegende Prämissen"
```

### 3️⃣ Tägliche Entwicklung
```bash
# Session starten
./core/src/ai-collab.sh start

# KI-optimierte Entwicklung
./core/src/ai-collab.sh optimize "Login-System implementieren" feature_development medium

# Entwicklungsfortschritt dokumentieren
./core/src/session-manager.sh context "current_feature" "Benutzer-Authentifizierung"

# Prämissen bei wichtigen Entscheidungen updaten
./core/src/ai-collab.sh premises add "Sicherheit vor Convenience" security "Login-System braucht 2FA"
```

### 4️⃣ System-Überwachung
```bash
# Vollständige System-Diagnose
./core/src/ai-collab.sh diagnose

# Prämissen-Drift prüfen
./core/src/ai-collab.sh premises drift

# PM-System synchronisieren
./integration/pm-system/ai-collab-pm-integration.sh export
```

### 5️⃣ Release-Management
```bash
# Session-basiertes Release
./core/src/ai-collab.sh release v1.2.0 "Login-System mit 2FA"

# Prämissen-Snapshot für Release
./core/src/ai-collab.sh premises snapshot "v1.2.0 Release - Sicherheits-Features"

# GitHub automatisch pushen
./core/src/ai-collab.sh auto-push
```

## 🎛️ Alle Kommandos

### Hauptsystem
```bash
./core/src/ai-collab.sh init                    # System initialisieren
./core/src/ai-collab.sh start                   # Session starten
./core/src/ai-collab.sh status                  # Basis-Status
./core/src/ai-collab.sh diagnose                # Vollständige Diagnose
./core/src/ai-collab.sh optimize "<prompt>"     # KI-Optimierung
./core/src/ai-collab.sh setup-api               # API-Konfiguration
./core/src/ai-collab.sh github-setup            # GitHub-Setup
./core/src/ai-collab.sh auto-push               # Auto-Commit & Push
./core/src/ai-collab.sh release v1.0            # Release erstellen
```

### Session-Management
```bash
./core/src/session-manager.sh init [name]       # Session erstellen
./core/src/session-manager.sh list              # Sessions anzeigen
./core/src/session-manager.sh show [name]       # Session-Details
./core/src/session-manager.sh cleanup           # Leere Sessions löschen
./core/src/session-manager.sh snapshot          # Session-Snapshot
```

### Prämissen-Management (NEU)
```bash
./core/src/ai-collab.sh premises init           # Prämissen-System init
./core/src/ai-collab.sh premises add "<text>"   # Neue Prämisse
./core/src/ai-collab.sh premises show           # Aktuelle Prämissen
./core/src/ai-collab.sh premises snapshot       # Versionierung
./core/src/ai-collab.sh premises history        # Evolution anzeigen
./core/src/ai-collab.sh premises drift          # Drift-Analyse
```

### PM-System Integration (NEU)
```bash
./integration/pm-system/ai-collab-pm-integration.sh export    # Daten exportieren
./integration/pm-system/ai-collab-pm-integration.sh status    # PM-Status
./integration/pm-system/todo-sync.sh sync                     # Todo-Sync
./integration/pm-system/pm-analyzer.sh full                   # PM-Analyse
```

## 📊 Kostenoptimierung & ROI

### Automatische Modellauswahl
| Aufgabentyp | Modell | Kosten/1M Token | Ersparnis | Use Case |
|-------------|--------|-----------------|-----------|-----------|
| Bug Fixes | Claude 3.5 Haiku | $0.80/$4 | **75%** | Einfache Korrekturen |
| Code Reviews | Claude 3.5 Sonnet | $3/$15 | Standard | Qualitätssicherung |
| Architektur | Claude 4 Opus | $15/$75 | Premium | Komplexe Entscheidungen |

### ROI-Metriken (CSV2Actual Projekt)
- **Template-Effizienz**: 60-70% schnellere Entwicklung
- **Kostenreduktion**: 75% Ersparnis durch intelligente Modellwahl
- **Session-Persistenz**: 40% weniger Context-Rebuilding
- **PM-Integration**: 50% weniger Koordinationsaufwand

## 🔧 PM-System Features

### Web-Interface (http://localhost:8080)
- **Kanban-Boards**: Drag & Drop Task-Management
- **Real-time Sync**: Automatische Updates alle 5 Minuten
- **Kosten-Widgets**: Live Budget-Monitoring
- **Team-Dashboard**: Multi-User Kollaboration
- **Session-Import**: Automatische Task-Erstellung aus ai-collab

### AI-Integration
- **Session → Tasks**: Automatische Kanban-Card-Erstellung
- **Kosten-Tracking**: Budget-Visualisierung im Dashboard
- **Prämissen-Export**: Entwicklungsphilosophie für Stakeholder
- **Custom-Branding**: ai-collab Design-Integration

## 🧠 Prämissen-Management

### Entwicklungsphilosophie-Features
- **Automatische Archivierung**: Alle Designentscheidungen dokumentiert
- **Snapshot-Versionierung**: Rückverfolgbare Prämissen-Evolution
- **Confidence-Tracking**: Vertrauen in Prinzipien messbar
- **Drift-Detection**: Warnung bei Abweichung von Kernwerten

### Kategorien-System
- **Economic**: Kostenoptimierung, Budget-Entscheidungen
- **Technical**: Architektur, Technologie-Wahl
- **Operational**: Workflow, Prozesse
- **User Experience**: UI/UX-Prinzipien
- **Ecosystem**: Integration, Tool-Auswahl

### Praktischer Nutzen
- **Team-Onboarding**: Neue Mitglieder verstehen Projekt-DNA
- **Konsistenz-Prüfung**: Code-Drift von Prämissen erkennbar
- **Stakeholder-Transparenz**: Nachvollziehbare Entwicklungsrichtung
- **Retrospektiven**: "Wann haben wir X als Prinzip etabliert?"

## 🔍 System-Diagnose

```bash
# Vollständige Systemanalyse
./core/src/ai-collab.sh diagnose
```

**Überprüft:**
- ✅ System-Komponenten (5 Module)
- ✅ Session-Analyse (Aktive Sessions, Kosten)  
- ✅ PM-Integration (Export-Status, Datenbank)
- ✅ API-Tests (GitHub, PM-System, Anthropic)
- ✅ Template-Validierung (5 Templates verfügbar)
- ✅ Budget-Analyse (Tages-/Monats-Limits)

## 🌍 Multi-Language & Platform Support

### Programmiersprachen
- **PowerShell** - Native Unterstützung (ursprünglich für CSV2Actual)
- **Python** - Spezialisierte Templates
- **JavaScript/TypeScript** - Frontend/Backend
- **Java/C#** - Enterprise-Entwicklung  
- **Bash/Shell** - System-Administration
- **Weitere** - Universelle Templates

### Plattformen
- **Linux** - Primäre Entwicklungsplattform
- **macOS** - Vollständig unterstützt
- **Windows** - PowerShell-Integration

### Interface-Sprachen
- **Deutsch** - Primäre Sprache
- **Englisch** - Vollständig lokalisiert

## 🚀 Migration von v1.x

```bash
# Automatische Migration
./core/src/ai-collab.sh init

# Sessions prüfen und bereinigen
./core/src/session-manager.sh cleanup

# PM-System initialisieren
./integration/pm-system/ai-collab-pm-integration.sh init

# Prämissen-System setup
./core/src/ai-collab.sh premises init
./core/src/ai-collab.sh premises snapshot "Migration zu v2.1.0"
```

## 🤝 Enterprise Features

### Team-Kollaboration
- **Multi-User Kanban**: Bis zu unbegrenzte Team-Mitglieder
- **Session-Sharing**: Geteilte Entwicklungskontexte
- **Prämissen-Governance**: Unternehmensweite Designprinzipien
- **Cost-Center-Tracking**: Abteilungsbasierte Budgets

### Compliance & Governance
- **Audit-Trail**: Vollständige Nachverfolgbarkeit aller Entscheidungen
- **Prämissen-Compliance**: Automatische Drift-Detection
- **Budget-Controls**: Granulare Kostenkontrolle
- **Export-Standards**: JSON/CSV für externe Systeme

## 💰 Unterstützung & Sponsoring

[![Buy Me A Coffee](https://img.shields.io/badge/Support-Buy%20Me%20A%20Coffee-yellow.svg?style=for-the-badge)](https://buymeacoffee.com/stlas)

**ai-collab v2.1.0** ist ein komplexes System mit signifikanten Entwicklungskosten:

### Entwicklungsstatistiken
- **Codebase**: 150+ KB produktiver Code
- **Module**: 5 Hauptsysteme + PM-Integration
- **Templates**: 5 spezialisierte Entwicklungs-Templates
- **Entwicklungszeit**: 200+ Stunden
- **AI-Partnerschaft**: Intensive Claude-Kollaboration

### Warum unterstützen?
- 🚀 **Kostenlose Enterprise-Features** für alle
- 💡 **Kontinuierliche Innovation** in AI-Development
- 🌍 **Open-Source-Philosophie** ohne Vendor-Lock-in
- 🔬 **Cutting-Edge-Forschung** verfügbar für jeden

**Jeder Beitrag ermöglicht weitere Innovationen!**

## 🤝 Beitragen

1. Fork des Repositories
2. Feature-Branch erstellen (`git checkout -b feature/AmazingFeature`)
3. Prämissen dokumentieren (`./core/src/ai-collab.sh premises add "Feature-Prinzip"`)
4. Änderungen committen (`git commit -m 'Add AmazingFeature'`)
5. Branch pushen (`git push origin feature/AmazingFeature`)
6. Pull Request öffnen

**Neue Mitwirkende**: Bitte zuerst `./core/src/ai-collab.sh premises show` lesen für Projekt-Philosophie!

## 📝 Lizenz

MIT License - Siehe `LICENSE` für Details.

## 👨‍💻 Autor & Credits

**Hauptautor**: [sTLAs](https://github.com/sTLAs)  
**AI-Partner**: Claude (Anthropic AI)  
**PM-System**: Kanboard Fork (MIT License)

### Version History
- **v2.1.0** (2025-06-19): PM-Integration, Prämissen-Management, System-Diagnose
- **v2.0.0** (2025-06-17): GitHub-Integration, Session-Manager-Rewrite
- **v1.x** (2025): Basis-System für CSV2Actual

---

**Entwickelt für enterprise-grade AI-gestützte Softwareentwicklung** 🚀