# SmartKI Ecosystem - Vollständige Dokumentation

## 🌟 Übersicht

SmartKI ist ein umfassendes KI-gestütztes Entwicklungs-Ecosystem, das aus mehreren spezialisierten Komponenten besteht. Das System ermöglicht kostenoptimierte Softwareentwicklung durch intelligente Modellauswahl, wiederverwendbare Templates und persistente Session-Verwaltung.

## 📊 Projekt-Struktur

```
SmartKI Ecosystem/
├── ai-collab/              # KI-Entwicklungsassistent (Hauptsystem)
├── SmartKI/                # Core Backend Services
├── SmartKI-web/            # Web-Interface und UI
├── SmartKI-PM/             # Projektmanagement (Kanboard)
├── SmartKI-Obsidian/       # Knowledge Base Integration
├── SmartKI-Pangolin/       # Internet Gateway Container
└── RemoteKI/               # Mobile SSH Terminal App
```

## 🚀 Komponenten im Detail

### 1. ai-collab (v2.1.2)
**Zweck**: Universeller KI-Entwicklungsassistent für kostenoptimierte Softwareentwicklung

**Features**:
- Intelligente Modellauswahl basierend auf Aufgabentyp und Budget
- Template-Engine für 60-70% Kostenersparnis
- Persistente Session-Verwaltung mit Parameterbeständigkeit
- MCP (Model Context Protocol) Server Integration
- Continuous Logging System für schnelle Kontext-Wiederherstellung

**Technologie**: Bash, Node.js, MCP Server

**GitHub**: https://github.com/stlas/ai-collab ✅

### 2. SmartKI (v1.0.0)
**Zweck**: Core Backend Services und Business Logic

**Features**:
- RESTful API für alle SmartKI-Dienste
- Authentifizierung und Autorisierung
- Datenbank-Management
- Integration mit externen KI-APIs

**Technologie**: Node.js, Express, PostgreSQL

**GitHub**: https://github.com/stlas/SmartKI ✅

### 3. SmartKI-web
**Zweck**: Web-Interface und Benutzeroberfläche

**Features**:
- Responsive Web-UI
- Real-time Updates über WebSocket
- Integration mit allen Backend-Services
- Multi-Language Support (DE/EN)

**Technologie**: React, TypeScript, WebSocket

**GitHub**: https://github.com/stlas/SmartKI-web ✅

### 4. SmartKI-PM
**Zweck**: Projektmanagement-System basierend auf Kanboard

**Features**:
- Task-Management mit Kanban-Boards
- API-Integration für automatische Task-Erstellung
- Webhook-Support für CI/CD
- Multi-User Support

**Technologie**: PHP (Kanboard), MySQL

**URL**: http://192.168.178.183/ai-collab-pm/

### 5. SmartKI-Obsidian
**Zweck**: Knowledge Base und Dokumentationssystem

**Features**:
- Markdown-basierte Wissensverwaltung
- REST API für externe Integration
- Verknüpfung mit Entwicklungsprojekten
- Automatische Dokumentationsgenerierung

**Technologie**: Obsidian, REST API Plugin

**Container**: 192.168.178.187:3001

### 6. SmartKI-Pangolin
**Zweck**: Internet Gateway und Tunnel-Management

**Features**:
- Sichere Tunnel für lokale Services
- Domain-Routing und SSL-Termination
- Zero-Configuration Deployment
- Multi-Site Support

**Technologie**: Docker (fosrl/pangolin), WireGuard

**Container**: 192.168.178.186

### 7. RemoteKI
**Zweck**: Mobile SSH Terminal App für Android

**Features**:
- SSH-Verbindung zu SmartKI-Servern
- Terminal-Emulation
- Session-Management
- File Upload/Download

**Technologie**: React Native 0.80.1

**Status**: In Entwicklung, APK Build verfügbar

## 🛠️ Installation und Setup

### Voraussetzungen
- Ubuntu 24.04 LTS (oder kompatibel)
- Node.js 20.x
- Docker und Docker Compose
- Git
- Optional: Proxmox für Container-Virtualisierung

### Schnellstart

1. **Repository klonen**:
```bash
git clone https://github.com/stlas/ai-collab.git
cd ai-collab
```

2. **System initialisieren**:
```bash
./start-ai-collab.sh
```

3. **Services starten**:
```bash
# Web-API starten (Port 3300)
# WebSocket Bridge starten (Port 3301)
# Bei Prompt mit 'j' bestätigen
```

### Konfiguration

1. **API-Keys einrichten**:
```bash
cp local/config/api-keys.local.template local/config/api-keys.local
# Datei bearbeiten und Keys eintragen
```

2. **Kanboard konfigurieren**:
```bash
cp local/config/kanboard.conf.template local/config/kanboard.conf
# API und Webhook Tokens eintragen
```

## 📡 Netzwerk-Architektur

```
Internet
    │
    ├─── simplyki.net (82.165.68.138)
    │         │
    │         └─── Pangolin Gateway
    │                   │
    └─── LAN (192.168.178.0/24)
              │
              ├─── Proxmox Host (.94)
              │      │
              │      ├─── ai-collab LXC (.183)
              │      │      ├─── Web-API (:3300)
              │      │      ├─── WebSocket (:3301)
              │      │      └─── Kanboard (:80)
              │      │
              │      ├─── Pangolin LXC (.186)
              │      │      └─── Tunnel Service
              │      │
              │      └─── Obsidian LXC (.187)
              │             └─── REST API (:3001)
              │
              └─── Clients (Windows/Android)
```

## 🔐 Sicherheit

### Best Practices
- Alle sensiblen Daten in `/local/` (nicht versioniert)
- API-Keys in `.local` Dateien
- SSH-Key-basierte Authentifizierung
- Regelmäßige Security-Updates

### Datenschutz
- Keine persönlichen Daten in öffentlichen Repos
- Verschlüsselte Verbindungen (HTTPS/SSH)
- Lokale Datenhaltung wo möglich

## 🤝 Beitragen

### Code-Style
- ESLint für JavaScript/TypeScript
- ShellCheck für Bash-Scripts
- Konventionelle Commits

### Pull Requests
1. Feature-Branch erstellen
2. Tests schreiben/anpassen
3. Dokumentation aktualisieren
4. PR mit ausführlicher Beschreibung

## 📈 Roadmap

### Q3 2025
- [ ] RemoteKI App Store Release
- [ ] SmartKI Cloud-Version
- [ ] Enterprise Features

### Q4 2025
- [ ] KI-Model Marketplace
- [ ] Community Templates
- [ ] Advanced Analytics

## 📞 Support

- **GitHub Issues**: Für Bug Reports und Feature Requests
- **Dokumentation**: `/docs/` Verzeichnis in jedem Repo
- **Community**: Discord Server (geplant)

## 📄 Lizenz

Alle SmartKI-Komponenten sind unter der MIT-Lizenz veröffentlicht.

---

**Version**: 2.1.2  
**Stand**: Juli 2025  
**Maintainer**: @stlas