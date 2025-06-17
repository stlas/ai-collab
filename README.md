# ai-collab - AI Development Collaboration Assistant

> **Entwickelt von [sTLAs](https://github.com/sTLAs) in Zusammenarbeit mit Claude AI**

**ai-collab** ist ein universeller KI-Entwicklungsassistent für kostenoptimierte Softwareentwicklung. Das System unterstützt beliebige Programmiersprachen und Projekte durch intelligente Modellauswahl, wiederverwendbare Template-Patterns und nahtlose Integration in bestehende Entwicklungsworkflows.

## 🚀 Features

### Kostenoptimierung
- **Intelligente Modellwahl**: Automatische Auswahl zwischen Claude 3.5 Haiku, Sonnet und Opus basierend auf Aufgabenkomplexität
- **Prompt-Optimierung**: Bis zu 90% Kostenersparnis durch Template-basierte Entwicklung
- **Real-time Budget-Tracking**: Überwachung der API-Kosten in Echtzeit

### Projektmanagement
- **Session-Management**: Persistente Kontextverwaltung über Sessions hinweg
- **Automatische Backups**: Intelligentes Release-Management mit Snapshot-System
- **Multi-Projekt-Support**: Verwaltung mehrerer Projekte über Symlinks

### Entwicklungsunterstützung
- **Template-Engine**: Wiederverwendbare Code-Patterns für 60-70% schnellere Entwicklung
- **Cross-Platform**: Unterstützung für Windows (PowerShell), Linux und macOS
- **Multi-Language**: Unterstützung für alle gängigen Programmiersprachen (Python, JavaScript, Java, C#, PowerShell, etc.)
- **Universal Templates**: Sprachagnostische Templates für Code-Reviews, Bug-Fixes und Feature-Entwicklung

## 📁 Projektstruktur

```
ai-collab/
├── core/                           # Öffentlich (GitHub)
│   ├── src/                        # Hauptquellcode
│   ├── templates/                  # Code-Templates
│   ├── docs/                       # Dokumentation
│   └── README.md                   # Dieses Dokument
├── local/                          # Privat (nicht versioniert)
│   ├── config/                     # Konfigurationsdateien
│   ├── development/                # Entwicklungsdaten
│   └── temp/                       # Temporäre Dateien
└── projects/                       # Projektverweise
```

## 🛠️ Installation & Setup

```bash
# Repository klonen
git clone https://github.com/sTLAs/ai-collab.git
cd ai-collab

# System automatisch initialisieren (wird bei erstem Start ausgeführt)
./core/src/ai-collab.sh start

# Oder manuell initialisieren
./core/src/ai-collab.sh init
```

### API-Konfiguration
```bash
# API-Key konfigurieren
cp local/config/.env.template local/config/.env
# Editiere .env und setze ANTHROPIC_API_KEY
```

## 📖 Schritt-für-Schritt Nutzungsanleitung

### 1️⃣ Erstmalige Einrichtung (Einmalig)

```bash
# Schritt 1: System initialisieren (automatisch bei erstem Start)
./core/src/ai-collab.sh start

# Schritt 2: Dein Projekt hinzufügen
./core/src/ai-collab.sh add-project /pfad/zu/deinem/projekt MeinProjekt

# Schritt 3: API-Key konfigurieren
cp local/config/.env.template local/config/.env
# Bearbeite local/config/.env und setze deinen ANTHROPIC_API_KEY
```

### 2️⃣ Täglicher Arbeitsablauf

```bash
# Session starten (lädt automatisch letzte Einstellungen)
./core/src/ai-collab.sh start

# Zum Projektverzeichnis wechseln
cd /pfad/zu/deinem/projekt

# KI-optimierte Entwicklung starten
./path/to/ai-collab/core/src/ai-collab.sh optimize "Deine Aufgabe hier" [task_type]

# Beispiele:
./core/src/ai-collab.sh optimize "Fix login bug" bug_fix high
./core/src/ai-collab.sh optimize "Review user authentication" code_review
./core/src/ai-collab.sh optimize "Add password reset feature" feature_development
```

### 3️⃣ Session-Persistenz (Wichtig!)

**Problem**: KI vergisst Kontext bei Neustart  
**Lösung**: ai-collab Session-Management

```bash
# Session mit Name starten (empfohlen für längere Projekte)
./core/src/session-manager.sh init "mein_projekt_session" "MeinProjekt"

# Wichtige Parameter setzen (bleiben bei AI-Neustart erhalten!)
./core/src/session-manager.sh set model "claude-3.5-sonnet"
./core/src/session-manager.sh set cost_budget "10.00"
./core/src/session-manager.sh context "current_task" "Login-System überarbeiten"

# Snapshot vor wichtigen Änderungen
./core/src/session-manager.sh snapshot "vor_refactoring" "Backup vor großer Umstrukturierung"
```

### 4️⃣ Nach AI-Neustart: Kontext wiederherstellen

```bash
# Automatisch: Letzte Session wiederherstellen
./core/src/ai-collab.sh start  # Lädt automatisch letzte Session

# Manuell: Spezifische Session laden
./core/src/session-manager.sh restore "mein_projekt_session"

# Oder: Aus Snapshot wiederherstellen
./core/src/session-manager.sh restore-snapshot "vor_refactoring"

# Kontext prüfen
./core/src/session-manager.sh get model
./core/src/session-manager.sh current
```

### 5️⃣ Wiedereinsteig in unterbrochene Arbeit

```bash
# 1. Session-Liste anzeigen
./core/src/session-manager.sh list

# 2. Gewünschte Session wiederherstellen
./core/src/session-manager.sh restore "mein_projekt_session"

# 3. Aktuellen Kontext prüfen
./core/src/ai-collab.sh status

# 4. Weiterarbeiten mit vollem Kontext
./core/src/ai-collab.sh optimize "Wo war ich stehengeblieben?" simple_fix
```

### 6️⃣ GitHub-Integration (Neu in v2.1.0!)

```bash
# GitHub CLI einrichten (einmalig)
./core/src/ai-collab.sh github init

# Auto-commit und push
./core/src/ai-collab.sh github commit "Feature hinzugefügt"

# GitHub Release mit Session-Statistiken
./core/src/ai-collab.sh release v2.1.0 "GitHub Integration"

# Issue erstellen aus AI-Session
./core/src/ai-collab.sh github issue "Bug Title" "AI-analyzed description" "bug"

# Pull Request aus Feature-Branch
./core/src/ai-collab.sh github pr "Feature Title" "AI-generated summary"
```

## ⚡ Quick Start (Für Eilige)

```bash
# Ein-Zeilen-Setup für neue Projekte
git clone https://github.com/sTLAs/ai-collab.git && cd ai-collab && ./core/src/ai-collab.sh start

# API-Key setzen (einmalig)
cp local/config/.env.template local/config/.env && nano local/config/.env

# Projekt hinzufügen und loslegen
./core/src/ai-collab.sh add-project /pfad/zu/projekt MeinProjekt
./core/src/ai-collab.sh optimize "Deine erste Aufgabe" feature_development
```

## 🔧 Häufige Probleme & Lösungen

### Problem: "Session nicht gefunden"
```bash
# Lösung: Verfügbare Sessions anzeigen
./core/src/session-manager.sh list
```

### Problem: "API-Key fehlt"
```bash
# Lösung: .env-Datei prüfen
cat local/config/.env
# ANTHROPIC_API_KEY=dein-key-hier setzen
```

### Problem: "Kontext verloren nach Neustart"
```bash
# Lösung: Session wiederherstellen
./core/src/ai-collab.sh start  # Lädt automatisch letzte Session
# Oder manuell:
./core/src/session-manager.sh restore "session_name"
```

## 💰 Kostenoptimierung

| Aufgabentyp | Empfohlenes Modell | Kosten/1M Token | Ersparnis |
|-------------|-------------------|-----------------|-----------|
| Einfache Korrekturen | Claude 3.5 Haiku | $0.80/$4 | 75% |
| Code-Reviews | Claude 3.5 Sonnet | $3/$15 | Standard |
| Architektur-Entscheidungen | Claude 4 Opus | $15/$75 | Beste Qualität |

### Automatische Kostenoptimierung
- **Template-Reuse**: 60-70% Kostenersparnis durch Musterwiederverwendung
- **Prompt Caching**: Bis zu 90% Ersparnis bei wiederholenden Operationen
- **Batch Processing**: 50% Ersparnis bei Batch-Operationen

## 🔧 Verwendung

### Basis-Kommandos
```bash
# AI-Session starten
./core/src/ai-collab.sh start

# Kostenoptimierung aktivieren
./core/src/ai-collab.sh optimize

# Projektstatus anzeigen
./core/src/ai-collab.sh status

# Template verwenden
./core/src/ai-collab.sh template <template-name>
```

### Erweiterte Features
```bash
# Session-Management
./core/src/ai-collab.sh session start
./core/src/ai-collab.sh session restore <session-id>

# Release-Management
./core/src/ai-collab.sh release auto
./core/src/ai-collab.sh backup create
```

## 📊 Entwicklungsprotokoll

ai-collab führt automatisch Protokoll über:
- **Kosten pro Session**: Tracking der API-Ausgaben
- **Entwicklungszeit**: Messung der Produktivität
- **Template-Usage**: Analyse der Wiederverwendungsrate
- **Modell-Performance**: Vergleich der verschiedenen AI-Modelle
- **Projekt-übergreifende Statistiken**: Effizienz-Analyse verschiedener Entwicklungsprojekte

## 🎯 Praxisbeispiel: CSV2Actual Integration

ai-collab wurde ursprünglich für die Entwicklung von **CSV2Actual** (PowerShell-basiertes CSV-Verarbeitungstool) entwickelt und demonstriert seine Vielseitigkeit:

### Kostenoptimierung in der Praxis
```bash
# Einfache Code-Korrekturen mit Haiku (75% Kostenersparnis)
./core/src/ai-collab.sh optimize "Fix CSV delimiter detection" simple_fix

# Code-Reviews mit Sonnet (Standard-Qualität)
./core/src/ai-collab.sh optimize "Review categorization logic" code_review

# Architektur-Entscheidungen mit Opus (beste Qualität)
./core/src/ai-collab.sh optimize "Design module structure" architecture high
```

### Template-Effizienz
Die **bug_fix.template** reduzierte Entwicklungszeit für CSV2Actual-Fehlerbehandlung um 60%, während **feature_development.template** strukturierte Implementierung neuer Excel-Export-Features ermöglichte.

### Multi-Projekt-Skalierung
Nach erfolgreicher CSV2Actual-Integration kann ai-collab für beliebige andere Projekte (Python, JavaScript, Java, etc.) verwendet werden.

## 🌍 Multi-Language Support

Unterstützte Programmiersprachen:
- **PowerShell** - Native Unterstützung
- **Python** - Mit spezialisierten Templates
- **JavaScript/TypeScript** - Frontend und Backend
- **Java/C#** - Enterprise-Entwicklung
- **Bash/Shell** - System-Administration
- **Weitere** - Durch universelle Templates

Interface-Sprachen:
- Deutsch (de) - Standard
- Englisch (en) - Vollständig
- Weitere Sprachen - Community-basiert

## 🤝 Beitragen

1. Fork des Repositories
2. Feature-Branch erstellen (`git checkout -b feature/AmazingFeature`)
3. Änderungen committen (`git commit -m 'Add some AmazingFeature'`)
4. Branch pushen (`git push origin feature/AmazingFeature`)
5. Pull Request öffnen

## 📝 Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Siehe `LICENSE` Datei für Details.

## 👨‍💻 Autor & Credits

**Hauptautor**: [sTLAs](https://github.com/sTLAs)  
**Entwickelt in Kooperation mit**: Claude (Anthropic AI)

ai-collab wurde von sTLAs konzipiert und entwickelt, ursprünglich für das CSV2Actual-Projekt. Die Implementierung erfolgte in enger Zusammenarbeit mit Claude AI für optimale Kosteneffizienz und Benutzerfreundlichkeit.

## 🙏 Danksagungen

- **sTLAs** - Konzept, Architektur und Hauptentwicklung
- **Claude (Anthropic)** - KI-Partnerschaft bei der Entwicklung
- **Community** - Feedback und Beiträge
- **Open Source** Projekte - Inspiration und Best Practices

---

**Entwickelt für maximale Effizienz bei KI-gestützter Softwareentwicklung** 🚀