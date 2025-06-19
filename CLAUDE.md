# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projektbeschreibung

ai-collab ist ein universeller KI-Entwicklungsassistent für kostenoptimierte Softwareentwicklung. Das System unterstützt beliebige Programmiersprachen und Projekte durch intelligente Modellauswahl, wiederverwendbare Template-Patterns und persistente Session-Verwaltung mit Parameterbeständigkeit.

## Entwicklungskommandos

### Hauptskripte (v2.1.0)
```bash
# System initialisieren
./core/src/ai-collab.sh init

# Session starten/verwalten
./core/src/ai-collab.sh start
./core/src/session-manager.sh init [name] [project]
./core/src/session-manager.sh restore [name]
./core/src/session-manager.sh list
./core/src/session-manager.sh show [name]
./core/src/session-manager.sh cleanup

# Kostenoptimierung
./core/src/ai-collab.sh optimize "<prompt>" [task_type] [complexity]
./core/src/cost-optimizer.sh select-model <task> <complexity> <priority> <budget>

# Status und Diagnose (NEU)
./core/src/ai-collab.sh status                # Basis-Status
./core/src/ai-collab.sh diagnose             # Vollständige System-Diagnose
./core/src/ai-collab.sh add-project <path> [name]

# Prämissen-Management (NEU)
./core/src/ai-collab.sh premises init
./core/src/ai-collab.sh premises add "<principle>" [category] [rationale]
./core/src/ai-collab.sh premises show
./core/src/ai-collab.sh premises snapshot [description]
./core/src/ai-collab.sh premises history
./core/src/ai-collab.sh premises drift

# API-Setup
./core/src/ai-collab.sh setup-api            # Interaktive API-Konfiguration

# GitHub-Integration
./core/src/ai-collab.sh github-setup         # Vollautomatisches Setup
./core/src/ai-collab.sh auto-push            # Commit & Push
./core/src/ai-collab.sh release <version>    # Release erstellen
```

### Template-System
```bash
# Template verwenden
./core/src/ai-collab.sh template <template-name>

# Neues Template erstellen
./core/src/ai-collab.sh create-template <name> [type]
```

### PM-System Integration (NEU)
```bash
# Datenexport für PM-System
./integration/pm-system/ai-collab-pm-integration.sh export
./integration/pm-system/ai-collab-pm-integration.sh status

# Todo-Synchronisation
./integration/pm-system/todo-sync.sh sync
./integration/pm-system/todo-sync.sh status

# PM-System Analyse
./integration/pm-system/pm-analyzer.sh full
./integration/pm-system/pm-analyzer.sh db
./integration/pm-system/pm-analyzer.sh costs

# PM-Web-Interface starten
cd ai-collab-pm && php -S localhost:8080
# Login: admin/admin
```

## Code-Architektur

### Modulare Struktur (v2.1.0)
- **core/src/ai-collab.sh**: Hauptsystem mit intelligenter Modellauswahl und Prompt-Optimierung (32KB)
- **core/src/session-manager.sh**: Erweiterte Session-Verwaltung mit Show/Cleanup-Features (19KB)
- **core/src/cost-optimizer.sh**: Kostenoptimierung mit Modell-ROI-Bewertung und Budget-Tracking (18KB)
- **core/src/github-integration.sh**: Vollständige GitHub-Integration mit Auto-Setup (21KB)
- **core/src/premises-manager.sh**: Prämissen-Management mit Snapshot-System (NEU)
- **core/src/dev-cost-tracker.sh**: Entwicklungskosten-Tracking für PM-Integration (2KB)

### Datenorganisation (Erweitert)
- **core/**: Öffentlicher Code (versioniert)
  - **src/**: 5 Hauptmodule + Utilities
  - **templates/**: 5 wiederverwendbare Prompt-Templates
  - **docs/**: Projektdokumentation
- **local/**: Private Daten (nicht versioniert)
  - **config/**: Konfigurationsdateien und API-Keys
  - **development/**: 
    - **sessions/**: Session-Protokolle
    - **premises/**: Entwicklungsphilosophie-Tagebuch (NEU)
    - **snapshots/**: Automatische Backups
  - **temp/**: Temporäre Dateien
- **integration/**: PM-System Integration (NEU)
  - **pm-system/**: Kanban-Export, Todo-Sync, Analyzer
- **ai-collab-pm/**: Vollständiges Kanban-System (396KB Datenbank) (NEU)
- **projects/**: Symlinks zu externen Projekten

### Intelligente Kostenkontrolle
Das System implementiert ein dreistufiges Kostenoptimierungs-Framework:
1. **Automatische Modellauswahl** basierend auf Aufgabentyp und verfügbarem Budget
2. **Template-Engine** für 60-70% Kostenersparnis durch Prompt-Wiederverwendung
3. **Session-basiertes Budget-Tracking** mit Echtzeit-Kostenüberwachung

### Konfigurationssystem
- JSON-basierte Konfiguration in `local/config/settings.json`
- Umgebungsvariablen in `local/config/.env`
- Parameter-Persistierung über Sessions hinweg

## Wichtige Konventionen

### Dateiorganisation
- Alle Shell-Skripte sind ausführbar und verwenden Bash
- JSON-Dateien für strukturierte Daten (Konfiguration, Session-Daten)
- Template-Dateien mit `.template` Erweiterung für Prompt-Patterns

### Kostenoptimierung
- Verwende `claude-3.5-haiku` für einfache Aufgaben (simple_fix, documentation)
- Verwende `claude-3.5-sonnet` für Standard-Entwicklung (code_review, feature_development)
- Verwende `claude-4-opus` nur für komplexe Architektur-Entscheidungen bei ausreichendem Budget

### Referenzprojekt: CSV2Actual
Das System wurde ursprünglich für CSV2Actual (PowerShell-basiertes CSV-Verarbeitungstool) entwickelt:
- **PowerShell-Templates**: Spezialisierte Patterns für .ps1-Dateien
- **CSV-Verarbeitung**: Optimierte Prompts für Datenmanipulation
- **Excel-Integration**: Feature-Templates für Office-Interoperabilität
- **Kostenreduktion**: 75% Ersparnis bei CSV2Actual-Entwicklung erreicht

### Session-Management
- Jede Development-Session wird protokolliert und kann wiederhergestellt werden
- Parameter-Cache ermöglicht konsistente Arbeitsweise über Session-Grenzen hinweg
- Automatischen Snapshots bei kritischen Änderungen

## Multilinguale Unterstützung
Das System ist primär auf Deutsch entwickelt, unterstützt aber mehrsprachige Prompts und Templates. Die Benutzerinteraktion erfolgt standardmäßig auf Deutsch.