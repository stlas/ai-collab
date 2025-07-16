# SmartKI System - Konsolidierter Neustart-Guide

## 🚀 Schnellstart

```bash
# System starten
./start-ai-collab.sh

# Bei spezifischem Kontext
./core/src/session-manager.sh restore [session-name]
```

## 📋 Kontext-spezifische Neustarts

### 1. Standard ai-collab Entwicklung

**Kontext**: Normale Entwicklungsarbeit mit dem ai-collab Framework

```bash
# Status prüfen
./core/src/ai-collab.sh status

# Session wiederherstellen
./core/src/session-manager.sh restore ai-collab

# Wichtige Befehle
./core/src/ai-collab.sh optimize "<prompt>" [task_type] [complexity]
./core/src/ai-collab.sh template <template-name>
```

### 2. Mobile App Entwicklung (RemoteKI)

**Kontext**: React Native App Entwicklung

```bash
# APK Build Status
cat /home/aicollab/REMOTEKI-BUILD-STATUS.md

# Metro Bundler starten
cd /home/aicollab/RemoteKI
npm start

# APK bauen
cd android && ./gradlew assembleDebug
```

### 3. Pangolin Gateway Konfiguration

**Kontext**: Internet-Gateway und Domain-Routing

```bash
# SSH zu Pangolin
ssh -i ~/.ssh/pangolin_key root@192.168.178.186

# Container Status
docker ps
docker logs pangolin-full

# Konfiguration prüfen
cat /app/config/config.yml
```

### 4. Projektmanagement (Kanboard)

**Kontext**: Task-Management und API-Integration

```bash
# Kanboard API testen
curl -X POST http://192.168.178.183/ai-collab-pm/jsonrpc.php \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "method": "getVersion", "id": 1}'

# Tasks synchronisieren
./integration/pm-system/scripts/sync_todos.sh
```

## 🔧 Wichtige Dateien & Pfade

### Konfiguration
- `/home/aicollab/local/config/` - Alle privaten Configs
- `/home/aicollab/.claude/CLAUDE.md` - Globale Claude-Anweisungen
- `/home/aicollab/CLAUDE.md` - Projekt-spezifische Anweisungen

### Logs & Sessions
- `/home/aicollab/local/development/protocols/` - Session-Dateien
- `/home/aicollab/local/development/continuous-logs/` - Continuous Logs
- `/home/aicollab/local/development/snapshots/` - System-Snapshots

### Scripts
- `./start-ai-collab.sh` - Hauptstart-Script
- `./core/src/ai-collab.sh` - Kern-Funktionalität
- `./core/src/session-manager.sh` - Session-Verwaltung
- `./core/src/cost-optimizer.sh` - Kosten-Optimierung

## 📊 System-Architektur

```
SmartKI Ecosystem
├── ai-collab (192.168.178.183)
│   ├── Web-API (:3300)
│   ├── WebSocket (:3301)
│   └── Kanboard (:80)
├── Pangolin Gateway (192.168.178.186)
│   └── Tunnel Service
└── Obsidian (192.168.178.187)
    └── REST API (:3001)
```

## 🔍 Häufige Probleme & Lösungen

### API-Token nur Lese-Rechte
```bash
# In Kanboard einloggen
# Settings → API → Generate new application token
# Token in local/config/kanboard.conf eintragen
```

### Metro Bundler Verbindungsfehler
```bash
# Debug APK mit eingebettetem Bundle bauen
cd /home/aicollab/RemoteKI/android
./gradlew assembleDebug
```

### Service läuft bereits
```bash
# PIDs prüfen
lsof -i :3300  # Web-API
lsof -i :3301  # WebSocket

# Bei Bedarf beenden
kill $(lsof -i :3300 -t)
```

## 💡 Best Practices

1. **Immer Continuous Logging nutzen**
   - Automatisch bei `start-ai-collab.sh`
   - Manuelle Events: `log_event "TYPE" "message"`

2. **Session-Management**
   - Regelmäßig Sessions speichern
   - Aussagekräftige Session-Namen verwenden

3. **Kosten-Optimierung**
   - Templates für wiederkehrende Aufgaben
   - Modell-Auswahl nach Komplexität

4. **Sicherheit**
   - Keine Credentials in öffentlichen Dateien
   - `.local` Suffix für private Configs
   - Regelmäßig `.gitignore` prüfen

## 🚨 Notfall-Kommandos

```bash
# Alle Services stoppen
pkill -f "node.*web-api"
pkill -f "node.*websocket"

# System-Reset
./core/src/ai-collab.sh init

# Logs prüfen
tail -f /home/aicollab/local/development/continuous-logs/*/current.log
```

---

**Version**: 2.1.2  
**Erstellt**: Juli 2025  
**Zweck**: Einheitlicher Neustart-Guide für alle SmartKI-Kontexte