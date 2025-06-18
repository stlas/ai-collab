# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projektbeschreibung

ai-collab ist ein universeller KI-Entwicklungsassistent für kostenoptimierte Softwareentwicklung. Das System unterstützt beliebige Programmiersprachen und Projekte durch intelligente Modellauswahl, wiederverwendbare Template-Patterns und persistente Session-Verwaltung mit Parameterbeständigkeit.

## Entwicklungskommandos

### Hauptskripte
```bash
# System initialisieren
./core/src/ai-collab.sh init

# Session starten/verwalten
./core/src/ai-collab.sh start
./core/src/session-manager.sh init [name] [project]
./core/src/session-manager.sh restore [name]

# Kostenoptimierung
./core/src/ai-collab.sh optimize "<prompt>" [task_type] [complexity]
./core/src/cost-optimizer.sh select-model <task> <complexity> <priority> <budget>

# Status und Verwaltung
./core/src/ai-collab.sh status
./core/src/ai-collab.sh add-project <path> [name]

# Tests ausführen
./test-system.sh
```

### Template-System
```bash
# Template verwenden
./core/src/ai-collab.sh template <template-name>

# Neues Template erstellen
./core/src/ai-collab.sh create-template <name> [type]
```

## Code-Architektur

### Modulare Struktur
- **core/src/ai-collab.sh**: Hauptsystem mit intelligenter Modellauswahl und Prompt-Optimierung
- **core/src/cost-optimizer.sh**: Kostenoptimierung mit Modell-ROI-Bewertung und Budget-Tracking
- **core/src/session-manager.sh**: Persistente Session-Verwaltung mit Parameter-Beständigkeit

### Datenorganisation
- **core/**: Öffentlicher Code (versioniert)
  - **templates/**: Wiederverwendbare Prompt-Templates für verschiedene Aufgabentypen
  - **docs/**: Projektdokumentation
- **local/**: Private Daten (nicht versioniert)
  - **config/**: Konfigurationsdateien und API-Keys
  - **development/**: Session-Protokolle, Snapshots, Kosten-Tracking
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