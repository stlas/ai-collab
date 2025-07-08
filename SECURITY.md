# Security Policy

## Sicherheit bei ai-collab

Dieses Projekt nimmt Sicherheit sehr ernst. API-Keys und andere sensible Daten werden NIEMALS im Repository gespeichert.

## Setup für neue Entwickler

### 1. Lokale Konfiguration erstellen

```bash
# Verzeichnis erstellen
mkdir -p local/config

# API-Keys Template kopieren
cp core/config-templates/api-keys.template local/config/api-keys.local
chmod 600 local/config/api-keys.local

# Settings Template kopieren
cp core/config-templates/settings.template.json local/config/settings.json

# Environment Template kopieren
cp local/config/.env.template local/config/.env
```

### 2. API-Keys sicher eintragen

Öffnen Sie `local/config/api-keys.local` und tragen Sie Ihre Keys ein:
- Anthropic API Key
- GitHub Personal Access Token
- Weitere benötigte Keys

### 3. Sicherheitsregeln

- **NIEMALS** echte API-Keys committen
- **NIEMALS** sensible Daten in öffentliche Repositories pushen
- **IMMER** `.gitignore` beachten
- **IMMER** `chmod 600` für Key-Dateien verwenden

## Was ist geschützt?

- Gesamtes `local/` Verzeichnis
- Alle `*.local` Dateien
- Alle `.env` Dateien
- Dateien mit Patterns wie `*api*key*`, `*secret*`, `*token*`

## Melden von Sicherheitsproblemen

Wenn Sie ein Sicherheitsproblem finden:
1. **NICHT** als öffentliches Issue melden
2. Kontaktieren Sie stlas1967@gmail.com
3. Beschreiben Sie das Problem detailliert

## Best Practices

1. **API-Key Rotation**: Ändern Sie Keys regelmäßig
2. **Principle of Least Privilege**: Nur notwendige Berechtigungen
3. **Audit Logs**: Überwachen Sie API-Nutzung
4. **Sichere Übertragung**: Verwenden Sie HTTPS/SSH

## GitHub Secret Scanning

Dieses Repository nutzt GitHub's Secret Scanning. Commits mit erkannten Secrets werden automatisch blockiert.