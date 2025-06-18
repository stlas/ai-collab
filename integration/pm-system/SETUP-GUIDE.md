# 🚀 ai-collab PM-System Setup Guide

## ⚡ Quick Start (3 Schritte)

### **Schritt 1: Web-Server starten**
```bash
# Terminal öffnen und navigieren
cd /mnt/a/Dokumente/Entwicklung/Powershell/ai-collab-pm

# PHP-Server starten (Port 8080)
php -S localhost:8080

# Oder anderen Port falls 8080 belegt ist:
php -S localhost:8090
```

### **Schritt 2: Browser öffnen**
```
Öffne deinen Browser und gehe zu:
http://localhost:8080

ODER falls anderen Port:
http://localhost:8090
```

### **Schritt 3: Erste Anmeldung**
```
Kanboard fragt nach Initial-Setup:

Benutzername: admin
Passwort:     admin

(Das kannst du später ändern)
```

## 🎯 Was du dann siehst:

### **Standard Kanboard + ai-collab Integration:**
- ✅ **ai-collab Header** mit Branding
- ✅ **Automatisch importierte Tasks** aus ai-collab Sessions
- ✅ **Cost-Tracking-Widgets** mit Entwicklungskosten
- ✅ **ai-collab Projekt** bereits angelegt
- ✅ **Navigation-Link** zu ai-collab Features

### **Automatisch erstellte Daten:**
- 📁 **Projekt "ai-collab"** mit allen Sessions
- 📋 **Tasks für jede Session** (session_20250617_*, etc.)
- 💰 **Kosten-Informationen** in Task-Beschreibungen
- 🎨 **ai-collab Styling** aktiv

## 🔧 Troubleshooting

### **Problem: Port 8080 ist belegt**
```bash
# Anderen Port verwenden
php -S localhost:8090
# Dann: http://localhost:8090
```

### **Problem: PHP nicht gefunden**
```bash
# PHP installieren (Ubuntu/WSL)
sudo apt update && sudo apt install php

# PHP installieren (Windows)
# Download von: https://windows.php.net/download
```

### **Problem: Keine ai-collab-Tasks sichtbar**
```bash
# Daten neu exportieren
cd /mnt/a/Dokumente/Entwicklung/Powershell/ai-collab
./integration/pm-system/ai-collab-pm-integration.sh export

# Browser refreshen
```

### **Problem: Plugin nicht aktiv**
```bash
# Plugin-Status prüfen
./integration/pm-system/ai-collab-pm-integration.sh status

# Plugin neu erstellen
./integration/pm-system/ai-collab-pm-integration.sh create-plugin
```

## 📱 Zugang ohne Anmeldung

### **Demo-Modus (Read-Only):**
Falls du nur schauen willst ohne Setup:
```
http://localhost:8080/?guest=1
```

### **API-Zugang:**
```bash
# JSON-API für Status
curl http://localhost:8080/jsonrpc.php -d '{"jsonrpc":"2.0","method":"getVersion","id":1}'

# ai-collab Integration-Status
curl http://localhost:8080/plugins/AiCollabIntegration/status
```

## 🎨 UI-Anpassungen

### **ai-collab Theme aktivieren:**
1. **Settings** → **Application Settings**
2. **Theme** → **ai-collab** auswählen
3. **Save** klicken

### **Dashboard-Widgets:**
- **Cost-Overview** → Zeigt ai-collab Entwicklungskosten
- **Session-Statistics** → Anzahl Sessions, verwendete Models
- **Project-Timeline** → Entwicklungsfortschritt über Zeit

## 💰 Budget-Monitoring

### **Live-Kosten im Dashboard:**
```
💰 Heutiger Entwicklungstag: $29.75
📊 Monatliche Kosten: $148.75
📈 Kosteneinsparung vs. Pre-ai-collab: 20%
🎯 Budget-Status: 96% verfügbar
```

### **Task-Details mit Kosten:**
- Jede **ai-collab Session** → eigene Task
- **Beschreibung** enthält Kosten-Information
- **Color-Coding** nach Kosten (grün=günstig, gelb=mittel, rot=teuer)
- **Category "AI Development"** für alle Sessions

## 🔗 Integration mit ai-collab

### **Automatischer Sync:**
```bash
# Nach jeder ai-collab Session automatisch:
./core/src/ai-collab.sh optimize "neue feature"
# → Automatisch neue Task im PM-System

# Manueller Sync:
./integration/pm-system/ai-collab-pm-integration.sh export
```

### **Bi-directional Sync (geplant):**
- Tasks im PM-System anlegen → ai-collab Templates erstellen
- Kanban-Board-Status → ai-collab Session-Status
- Time-Tracking → Kosten-Zuordnung

## 🚀 Advanced Features

### **Team-Collaboration:**
1. **Benutzer hinzufügen:** Settings → Users → Add User
2. **Projekt-Zugriff:** Projects → Permissions
3. **ai-collab Sharing:** Plugin → Team-Settings

### **Custom-Workflows:**
1. **Columns anpassen:** Board → Column-Settings
2. **ai-collab Kategorien:** Categories → AI Development
3. **Automatic Actions:** Actions → AI-Session-Import

### **Reporting:**
1. **Analytics-Dashboard:** Analytics → Project-Statistics  
2. **Cost-Reports:** Plugin → Cost-Analytics
3. **Export:** Settings → Export → ai-collab-Data

## 🎯 Production-Setup

### **Apache/Nginx-Setup:**
```apache
# Apache Virtual Host
<VirtualHost *:80>
    ServerName ai-collab-pm.local
    DocumentRoot /mnt/a/.../ai-collab-pm
    DirectoryIndex index.php
</VirtualHost>
```

### **MySQL-Setup:**
```php
// config.php
<?php
define('DB_DRIVER', 'mysql');
define('DB_HOSTNAME', 'localhost');
define('DB_USERNAME', 'kanboard');
define('DB_PASSWORD', 'your-password');
define('DB_NAME', 'ai_collab_pm');
```

### **SSL/HTTPS:**
```bash
# Let's Encrypt für Domain
certbot --apache -d ai-collab-pm.yourdomain.com
```

## 📞 Support

### **Falls Probleme auftreten:**
1. **Log-Dateien prüfen:** `data/debug.log`
2. **Plugin-Status:** `./integration/pm-system/ai-collab-pm-integration.sh status`
3. **Browser-Konsole** auf JavaScript-Fehler prüfen
4. **PHP-Errors:** `php -l` für Syntax-Check

### **Häufige Fixes:**
```bash
# Permissions reparieren
chmod -R 755 /mnt/a/.../ai-collab-pm
chmod -R 777 /mnt/a/.../ai-collab-pm/data

# Cache leeren
rm -rf /mnt/a/.../ai-collab-pm/data/cache/*

# Plugin neu installieren
./integration/pm-system/ai-collab-pm-integration.sh create-plugin
```

---

## 🎉 Ready to go!

**Nach dem Setup hast du:**
- ✅ **Professional PM-Interface** für ai-collab
- ✅ **Real-time Cost-Tracking** im Browser
- ✅ **Team-Collaboration** Features
- ✅ **Automated Session-Import** aus ai-collab
- ✅ **Enterprise-ready** Web-Platform

**Perfekt für Investor-Demos und Team-Management!** 🚀