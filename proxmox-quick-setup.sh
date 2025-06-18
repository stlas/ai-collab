#!/bin/bash
# ai-collab Proxmox Quick-Setup

echo "🚀 ai-collab Proxmox Setup"
echo "=========================="

# System-Updates
apt update && apt upgrade -y

# LAMP-Stack
echo "📦 Installiere LAMP-Stack..."
apt install apache2 php php-cli php-mysql php-sqlite3 php-mbstring php-xml php-curl php-zip mysql-server git curl wget vim htop -y

# Permissions
chmod +x core/src/*.sh
chmod +x integration/**/*.sh
chmod +x test-system.sh

# Config aus Examples erstellen
echo "⚙️  Erstelle Konfiguration..."
cp local/config/settings.json.example local/config/settings.json
cp local/config/.env.example local/config/.env

echo "✅ Basis-Setup abgeschlossen!"
echo ""
echo "🔧 Nächste Schritte:"
echo "1. Konfiguration anpassen: nano local/config/settings.json"
echo "2. PM-System setup: ./integration/pm-system/ai-collab-pm-integration.sh init"
echo "3. System testen: ./test-system.sh"
echo ""
echo "🌐 PM-System wird verfügbar unter: http://$(hostname -I | awk '{print $1}')/ai-collab-pm/"
