# 🚀 ai-collab Proxmox Migration Guide

## 📋 Übersicht

Migration von WSL zu Proxmox-Server für professionelles ai-collab Development Environment.

### 🎯 Ziele:
- ✅ **Produktive PM-System-Umgebung** (24/7 verfügbar)
- ✅ **Team-Collaboration** ohne WSL-Einschränkungen
- ✅ **Professional Demo-Setup** für Investoren
- ✅ **CI/CD-Pipeline** für ai-collab-Entwicklung

---

## 📦 Phase 1: LXC-Container Setup

### **1.1 Container erstellen** (Proxmox WebUI)
```bash
# In Proxmox WebUI:
# Create CT → Ubuntu 22.04 LTS Template
# 
# Container-Specs:
CT ID: 200
Hostname: ai-collab-dev
Cores: 4
RAM: 4096 MB
Storage: 32 GB
Network: vmbr0 (Bridge)
```

### **1.2 Container-Konfiguration**
```bash
# Container starten und connecten
pct start 200
pct enter 200

# Basic Setup
apt update && apt upgrade -y
apt install curl wget git vim nano htop -y

# User erstellen
useradd -m -s /bin/bash aicollab
usermod -aG sudo aicollab
passwd aicollab  # Passwort setzen
```

### **1.3 SSH-Zugang einrichten**
```bash
# SSH-Server installieren
apt install openssh-server -y
systemctl enable ssh
systemctl start ssh

# SSH-Key-Auth (optional)
mkdir -p /home/aicollab/.ssh
# Deine SSH-Keys von WSL kopieren
```

---

## 📁 Phase 2: Code-Migration

### **2.1 ai-collab Repository übertragen**
```bash
# Von WSL aus (dein Windows-System):
# Option A: Via SCP
scp -r /mnt/a/Dokumente/Entwicklung/Powershell/ai-collab aicollab@PROXMOX-IP:/opt/

# Option B: Via GitHub (empfohlen)
# Auf Proxmox:
cd /opt
git clone https://github.com/yourusername/ai-collab.git
chown -R aicollab:aicollab /opt/ai-collab
```

### **2.2 Daten-Migration**
```bash
# Private Daten separat übertragen
# Von WSL:
scp -r /mnt/a/Dokumente/Entwicklung/Powershell/ai-collab/local aicollab@PROXMOX-IP:/opt/ai-collab/

# Sessions und Statistiken
scp /home/stlas/.claude/CLAUDE.md aicollab@PROXMOX-IP:/home/aicollab/.claude/
```

### **2.3 Verzeichnis-Struktur anpassen**
```bash
# Auf Proxmox-Container:
cd /opt/ai-collab

# Permissions setzen
chmod +x core/src/*.sh
chmod +x integration/**/*.sh
chmod +x test-system.sh

# Local-Verzeichnis erstellen falls nicht vorhanden
mkdir -p local/{config,development}
```

---

## 🔧 Phase 3: Server-Stack Installation

### **3.1 LAMP-Stack installieren**
```bash
# Apache, PHP, MySQL
apt install apache2 php php-cli php-mysql php-sqlite3 php-mbstring php-xml php-curl php-zip -y
apt install mysql-server -y

# PHP-Konfiguration optimieren
sed -i 's/;date.timezone =/date.timezone = Europe\/Berlin/' /etc/php/8.1/apache2/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/' /etc/php/8.1/apache2/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 50M/' /etc/php/8.1/apache2/php.ini

# Apache-Module aktivieren
a2enmod rewrite
a2enmod ssl
systemctl restart apache2
```

### **3.2 MySQL-Setup**
```bash
# MySQL sichern
mysql_secure_installation

# ai-collab Datenbank erstellen
mysql -u root -p
```

```sql
CREATE DATABASE ai_collab_pm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'aicollab'@'localhost' IDENTIFIED BY 'secure_password_here';
GRANT ALL PRIVILEGES ON ai_collab_pm.* TO 'aicollab'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### **3.3 Node.js & npm (optional)**
```bash
# Für zukünftige Web-Dashboard-Entwicklung
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt install nodejs -y
```

---

## 🌐 Phase 4: PM-System (Kanboard) Deployment

### **4.1 Kanboard installieren**
```bash
# ai-collab-pm nach /var/www übertragen
cp -r /opt/ai-collab/ai-collab-pm /var/www/html/
chown -R www-data:www-data /var/www/html/ai-collab-pm
chmod -R 755 /var/www/html/ai-collab-pm
chmod -R 777 /var/www/html/ai-collab-pm/data
```

### **4.2 Apache Virtual Host**
```bash
# Virtual Host erstellen
cat > /etc/apache2/sites-available/ai-collab-pm.conf << 'EOF'
<VirtualHost *:80>
    ServerName ai-collab-pm.local
    DocumentRoot /var/www/html/ai-collab-pm
    
    <Directory /var/www/html/ai-collab-pm>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/ai-collab-pm_error.log
    CustomLog ${APACHE_LOG_DIR}/ai-collab-pm_access.log combined
</VirtualHost>
EOF

# Site aktivieren
a2ensite ai-collab-pm.conf
systemctl reload apache2
```

### **4.3 Kanboard-Konfiguration**
```bash
# Database-Config erstellen
cat > /var/www/html/ai-collab-pm/config.php << 'EOF'
<?php
// MySQL-Konfiguration
define('DB_DRIVER', 'mysql');
define('DB_HOSTNAME', 'localhost');
define('DB_USERNAME', 'aicollab');
define('DB_PASSWORD', 'secure_password_here');
define('DB_NAME', 'ai_collab_pm');

// Base URL
define('BASE_URL', 'http://DEINE-PROXMOX-IP/ai-collab-pm/');

// Session-Konfiguration
define('SESSION_DURATION', 86400 * 30); // 30 Tage

// Plugin-Verzeichnis
define('PLUGINS_DIR', 'plugins');
EOF
```

---

## 🔗 Phase 5: ai-collab Integration

### **5.1 Integration-Script anpassen**
```bash
# Pfade in ai-collab-pm-integration.sh aktualisieren
cd /opt/ai-collab
vim integration/pm-system/ai-collab-pm-integration.sh

# Ändern:
# KANBOARD_PATH="/var/www/html/ai-collab-pm"
# AI_COLLAB_PATH="/opt/ai-collab"
```

### **5.2 PM-Integration initialisieren**
```bash
cd /opt/ai-collab
./integration/pm-system/ai-collab-pm-integration.sh init
./integration/pm-system/ai-collab-pm-integration.sh export
./integration/pm-system/ai-collab-pm-integration.sh create-plugin
```

### **5.3 Cron-Jobs für Auto-Sync**
```bash
# Crontab für aicollab-User
crontab -e
```

```bash
# ai-collab Auto-Sync (alle 15 Minuten)
*/15 * * * * /opt/ai-collab/integration/pm-system/ai-collab-pm-integration.sh export >/dev/null 2>&1

# Backup (täglich um 2:00)
0 2 * * * /opt/ai-collab/scripts/backup-sessions.sh >/dev/null 2>&1
```

---

## 🔒 Phase 6: Security & SSL

### **6.1 Firewall konfigurieren**
```bash
# UFW installieren und konfigurieren
apt install ufw -y
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 'Apache Full'
ufw enable
```

### **6.2 SSL-Zertifikat (Let's Encrypt)**
```bash
# Certbot installieren
apt install certbot python3-certbot-apache -y

# SSL für Domain (falls verfügbar)
# certbot --apache -d ai-collab.yourdomain.com
```

### **6.3 Basic Auth für Demo (optional)**
```bash
# Temporärer Passwort-Schutz für Demos
htpasswd -c /etc/apache2/.htpasswd demo
# Passwort: demo123

# In Virtual Host hinzufügen:
# AuthType Basic
# AuthName "ai-collab Demo"
# AuthUserFile /etc/apache2/.htpasswd
# Require valid-user
```

---

## 🚀 Phase 7: Services & Monitoring

### **7.1 Systemd-Services erstellen**
```bash
# ai-collab Service
cat > /etc/systemd/system/ai-collab-sync.service << 'EOF'
[Unit]
Description=ai-collab PM Integration Sync
After=network.target

[Service]
Type=oneshot
User=aicollab
ExecStart=/opt/ai-collab/integration/pm-system/ai-collab-pm-integration.sh export
WorkingDirectory=/opt/ai-collab

[Install]
WantedBy=multi-user.target
EOF

# Timer für regelmäßige Syncs
cat > /etc/systemd/system/ai-collab-sync.timer << 'EOF'
[Unit]
Description=Run ai-collab sync every 15 minutes
Requires=ai-collab-sync.service

[Timer]
OnCalendar=*:0/15
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Services aktivieren
systemctl enable ai-collab-sync.timer
systemctl start ai-collab-sync.timer
```

### **7.2 Monitoring-Dashboard**
```bash
# Htop für System-Monitoring
apt install htop iotop nethogs -y

# Log-Rotation für ai-collab
cat > /etc/logrotate.d/ai-collab << 'EOF'
/opt/ai-collab/local/development/*.log {
    weekly
    rotate 4
    compress
    delaycompress
    missingok
    notifempty
    create 644 aicollab aicollab
}
EOF
```

---

## 🌐 Phase 8: Netzwerk & Zugang

### **8.1 IP-Adresse festlegen**
```bash
# Statische IP im Proxmox-Container
# /etc/netplan/00-installer-config.yaml
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
```

### **8.2 Domain/Subdomain-Setup** (optional)
```bash
# DNS-Eintrag erstellen:
# ai-collab.yourdomain.com → PROXMOX-IP

# Oder lokaler DNS:
# /etc/hosts auf Client-Rechnern:
# 192.168.1.100    ai-collab-pm.local
```

---

## ✅ Phase 9: Testing & Verification

### **9.1 System-Tests**
```bash
# ai-collab Funktionalität testen
cd /opt/ai-collab
./test-system.sh

# PM-System testen
curl -I http://localhost/ai-collab-pm/

# Database-Connection testen
mysql -u aicollab -p ai_collab_pm -e "SHOW TABLES;"
```

### **9.2 Integration-Tests**
```bash
# Neue Session erstellen und PM-Sync testen
./core/src/ai-collab.sh optimize "Test Migration" simple_fix low
./integration/pm-system/ai-collab-pm-integration.sh export

# Kanboard prüfen
curl -s http://localhost/ai-collab-pm/ | grep "ai-collab"
```

### **9.3 Performance-Tests**
```bash
# Apache-Performance
ab -n 100 -c 10 http://localhost/ai-collab-pm/

# Database-Performance
mysql -u aicollab -p ai_collab_pm -e "SHOW PROCESSLIST;"
```

---

## 🎯 Go-Live Checklist

### **Vor dem Switch:**
- [ ] **Container läuft stabil** (24h Test)
- [ ] **PM-System erreichbar** (HTTP + HTTPS)
- [ ] **ai-collab Sessions funktionieren**
- [ ] **Auto-Sync aktiv** (Cron-Jobs laufen)
- [ ] **Backup-Strategie** implementiert
- [ ] **SSH-Zugang** von WSL aus funktioniert

### **Nach der Migration:**
- [ ] **WSL-Entwicklung einstellen**
- [ ] **GitHub-Repository** auf Proxmox-Version zeigen
- [ ] **Team-Zugang** einrichten (SSH-Keys)
- [ ] **Investor-Demo-Link** testen
- [ ] **Monitoring** einrichten (Logs, Performance)

---

## 🚀 Quick-Commands für Go-Live

### **Container-Zugang:**
```bash
# SSH von WSL
ssh aicollab@PROXMOX-IP

# Oder Proxmox-Console
pct enter 200
```

### **PM-System URLs:**
```bash
# Lokal
http://PROXMOX-IP/ai-collab-pm/

# Mit Domain
https://ai-collab.yourdomain.com/
```

### **Development-Workflow:**
```bash
# SSH in Container
ssh aicollab@PROXMOX-IP

# ai-collab-Entwicklung
cd /opt/ai-collab
./core/src/ai-collab.sh optimize "neue Feature"

# Automatisch im PM-System sichtbar (alle 15 Min)
# Oder manuell:
./integration/pm-system/ai-collab-pm-integration.sh export
```

---

## 🎉 Bereit für Production!

**Nach der Migration hast du:**
- ✅ **Professional Development Environment**
- ✅ **24/7 verfügbares PM-System**
- ✅ **Team-Collaboration-Platform**
- ✅ **Investor-Demo-Ready Setup**
- ✅ **CI/CD-Pipeline-Basis**
- ✅ **Echte Server-Performance**

**Perfekt für die nächste Entwicklungsphase!** 🚀