# ai-collab Proxmox Migration Package

## 🚀 Quick Start

### 1. Package zu Proxmox übertragen:
```bash
./transfer-to-proxmox.sh <PROXMOX-IP> [username]
# Beispiel: ./transfer-to-proxmox.sh 192.168.1.100 aicollab
```

### 2. Auf Proxmox-Container:
```bash
ssh aicollab@PROXMOX-IP
cd /opt/ai-collab
./proxmox-quick-setup.sh
```

### 3. Konfiguration anpassen:
```bash
nano local/config/settings.json
nano local/config/.env
```

### 4. PM-System initialisieren:
```bash
./integration/pm-system/ai-collab-pm-integration.sh init
```

### 5. System testen:
```bash
./test-system.sh
```

## 🌐 Zugang

- **PM-System**: http://PROXMOX-IP/ai-collab-pm/
- **Login**: admin / admin
- **SSH**: ssh aicollab@PROXMOX-IP

## 📚 Vollständige Anleitung

Siehe: `docs/proxmox-migration-guide.md`
