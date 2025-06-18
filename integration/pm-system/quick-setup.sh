#!/bin/bash

# Quick Setup für ai-collab PM-System 
echo "🚀 ai-collab PM-System Setup"
echo "============================"

# PHP installieren
echo "📦 Installiere PHP..."
sudo apt update && sudo apt install php php-sqlite3 -y

if [ $? -eq 0 ]; then
    echo "✅ PHP erfolgreich installiert"
    
    # Ungewöhnlichen Port verwenden: 9876
    PORT=9876
    
    echo ""
    echo "🌐 Starte PHP-Server auf Port $PORT..."
    echo "🔗 Öffne Browser: http://localhost:$PORT"
    echo "👤 Login: admin / admin"
    echo ""
    echo "🔥 Server läuft - Browser öffnen!"
    echo ""
    
    # Server starten
    php -S localhost:$PORT -t /mnt/a/Dokumente/Entwicklung/Powershell/ai-collab-pm
    
else
    echo "❌ PHP-Installation fehlgeschlagen"
    echo "💡 Alternative: Python-Server (eingeschränkte Funktionalität)"
    echo ""
    
    if command -v python3 &> /dev/null; then
        PORT=9876
        echo "Using Python server on port $PORT..."
        cd /mnt/a/Dokumente/Entwicklung/Powershell/ai-collab-pm
        python3 -m http.server $PORT
    fi
fi