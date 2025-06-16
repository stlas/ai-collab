# 🚀 Migrationsleitfaden: CSV2Actual → ai-collab Integration

## Übersicht

Dieser Leitfaden beschreibt die Migration von der bestehenden CSV2Actual ai-collab Integration zum neuen, eigenständigen **ai-collab** System mit vollständiger Projekt-Entflechtung.

## 🎯 Migration-Ziele

- ✅ **Entflechtung**: Trennung von CSV2Actual-spezifischen und generischen AI-Tools
- ✅ **Kostenoptimierung**: Intelligente Modellwahl und 60-90% Kostenersparnis
- ✅ **Skalierbarkeit**: Multi-Projekt-Unterstützung
- ✅ **Parameterbeständigkeit**: Persistente Kontextverwaltung
- ✅ **WSL-Kompatibilität**: Vollständige Windows WSL2 Unterstützung

---

## 📂 Neue Struktur vs. Alte Struktur

### Vorher (CSV2Actual integriert):
```
CSV2Actual/
├── CSV2Actual.ps1
├── ai-collab.sh                    ← Gemischt CSV2Actual + Generisch
├── dev-workflow.sh                 ← CSV2Actual-spezifisch
├── development-protocol.sh         ← Generisch verwendbar
├── csv2actual-release-manager.sh   ← CSV2Actual-spezifisch
└── [andere CSV2Actual Dateien]
```

### Nachher (Entflochten):
```
ai-collab/                          ← Neues eigenständiges Projekt
├── core/                           ← Öffentlich (GitHub)
│   ├── src/
│   │   ├── ai-collab.sh            ← Haupt-Interface
│   │   ├── session-manager.sh      ← Session & Parameter-Persistenz
│   │   └── cost-optimizer.sh       ← Intelligente Kostenoptimierung
│   └── templates/                  ← Wiederverwendbare Code-Templates
└── projects/
    └── csv2actual -> ../CSV2Actual ← Symlink zu CSV2Actual

CSV2Actual/                         ← Bereinigtes CSV2Actual Projekt
├── CSV2Actual.ps1                  ← Nur noch CSV2Actual Core
├── modules/                        ← CSV2Actual Module
└── [CSV2Actual-spezifische Dateien]
```

---

## 🔧 Schritt-für-Schritt Migration

### Phase 1: Backup und Vorbereitung

```bash
# 1. Backup des aktuellen Zustands erstellen
cd /mnt/a/Dokumente/Entwicklung/Powershell/CSV2Actual
cp -r . ../CSV2Actual_backup_$(date +%Y%m%d)

# 2. Aktuelle ai-collab Dateien identifizieren
ls -la ai-collab.sh dev-workflow.sh development-protocol.sh csv2actual-release-manager.sh
```

### Phase 2: ai-collab System Setup

```bash
# 1. Zum ai-collab Verzeichnis wechseln
cd /mnt/a/Dokumente/Entwicklung/Powershell/ai-collab

# 2. System initialisieren
./core/src/ai-collab.sh init

# 3. CSV2Actual als Projekt hinzufügen (bereits gemacht)
ls -la projects/csv2actual

# 4. Erste Test-Session
./core/src/ai-collab.sh start
```

### Phase 3: Funktions-Mapping

| Alte Funktion | Neue Implementierung | Befehl |
|---------------|---------------------|---------|
| `ai-collab.sh start` | Session-Management | `ai-collab.sh start` |
| `ai-collab.sh optimize` | Kostenoptimierung | `ai-collab.sh optimize` |
| `ai-collab.sh cost` | Budget-Tracking | `cost-optimizer.sh report` |
| `dev-workflow.sh status` | System-Status | `ai-collab.sh status` |
| `development-protocol.sh` | Session-Persistenz | `session-manager.sh` |

### Phase 4: CSV2Actual Bereinigung

```bash
# In CSV2Actual Verzeichnis - alte ai-collab Dateien entfernen
cd /mnt/a/Dokumente/Entwicklung/Powershell/CSV2Actual

# Optional: Alte Dateien in Archiv verschieben
mkdir -p archive/old_ai_collab
mv ai-collab.sh archive/old_ai_collab/
mv dev-workflow.sh archive/old_ai_collab/
mv development-protocol.sh archive/old_ai_collab/
# csv2actual-release-manager.sh kann bleiben (CSV2Actual-spezifisch)
```

---

## 🚀 Neue Arbeitsabläufe

### Täglicher Entwicklungsworkflow

```bash
# 1. AI-Collab Session starten
/mnt/a/Dokumente/Entwicklung/Powershell/ai-collab/core/src/ai-collab.sh start

# 2. Projekt-spezifische Entwicklung
cd /mnt/a/Dokumente/Entwicklung/Powershell/CSV2Actual

# 3. Kostenoptimierte AI-Anfragen
/mnt/a/Dokumente/Entwicklung/Powershell/ai-collab/core/src/ai-collab.sh optimize "Fix CSV parsing bug" bug_fix high

# 4. Session beenden
/mnt/a/Dokumente/Entwicklung/Powershell/ai-collab/core/src/session-manager.sh end
```

### Template-basierte Entwicklung

```bash
# Code-Review mit Template
ai-collab.sh optimize "Review new categorization logic" code_review

# Feature-Entwicklung mit Template  
ai-collab.sh optimize "Add Excel export functionality" feature_development

# Bug-Fix mit Template
ai-collab.sh optimize "CSV delimiter detection fails" bug_fix
```

### Kosten-Management

```bash
# Tägliches Budget prüfen
cost-optimizer.sh budget daily

# Wöchentlichen Report generieren
cost-optimizer.sh report weekly

# Modell-Performance analysieren
cost-optimizer.sh report monthly
```

---

## 💰 Kostenoptimierungs-Features

### Automatische Modellwahl

```bash
# Einfache Aufgaben → Claude 3.5 Haiku ($0.80/$4.00 per 1M tokens)
ai-collab.sh optimize "Add comment to function" documentation

# Code-Reviews → Claude 3.5 Sonnet ($3.00/$15.00 per 1M tokens)  
ai-collab.sh optimize "Review parsing logic" code_review

# Architektur-Entscheidungen → Claude 4 Opus ($15.00/$75.00 per 1M tokens)
ai-collab.sh optimize "Design new module structure" architecture high
```

### Template-Wiederverwendung

**Geschätzte Ersparnis: 60-70%** durch Template-basierte Prompt-Optimierung:

- `bug_fix.template` - Systematische Bug-Analyse
- `code_review.template` - Strukturierte Code-Reviews  
- `feature_development.template` - Vollständige Feature-Entwicklung
- `optimization.template` - Performance-Optimierung
- `documentation.template` - Umfassende Dokumentation

### Batch-Processing

```bash
# Mehrere ähnliche Aufgaben in einer Batch (50% Ersparnis)
echo "Fix function A" > batch_tasks.txt
echo "Fix function B" >> batch_tasks.txt
echo "Fix function C" >> batch_tasks.txt

cost-optimizer.sh batch batch_tasks.txt bug_fix
```

---

## 🔄 Session-Persistenz & Parameter-Beständigkeit

### Session-Management

```bash
# Session mit Projekt-Kontext starten
session-manager.sh init "csv2actual_development" "CSV2Actual"

# Parameter setzen (bleiben bei Prompt-Komprimierung erhalten)
session-manager.sh set model "claude-3.5-sonnet"
session-manager.sh set cost_budget "10.00"
session-manager.sh set optimization_level "high"

# Snapshot für komplexe Entwicklungen
session-manager.sh snapshot "before_major_refactor" "Backup vor großer Umstrukturierung"

# Session wiederherstellen
session-manager.sh restore "csv2actual_development"
```

### Kontext-Verwaltung

```bash
# Entwicklungskontext setzen
session-manager.sh context "current_task" "Categorization engine optimization"
session-manager.sh context "recent_changes" "Modified CategoryManager.ps1"

# Automatische Kontext-Wiederherstellung bei neuer Session
session-manager.sh restore  # Lädt letzten gespeicherten Kontext
```

---

## 📊 Multi-Projekt-Support

### Neues Projekt hinzufügen

```bash
# Beispiel: Weiteres PowerShell-Projekt hinzufügen
ai-collab.sh add-project "/pfad/zu/anderem/projekt" "MeinProjekt2"

# Projekt-spezifische Session starten
session-manager.sh init "meinprojekt2_session" "MeinProjekt2"
```

### Projekt-übergreifende Templates

Templates sind projekt-agnostisch und können für alle Projekte verwendet werden:

- **CSV2Actual**: PowerShell-spezifische Entwicklung
- **Andere Projekte**: Python, JavaScript, C#, etc.

---

## ⚠️ Wichtige Migrations-Hinweise

### WSL-spezifische Anpassungen

```bash
# Absolute Pfade verwenden für Skript-Aufrufe
/mnt/a/Dokumente/Entwicklung/Powershell/ai-collab/core/src/ai-collab.sh

# Line-Endings korrigieren falls nötig
sed -i 's/\r$//' /mnt/a/Dokumente/Entwicklung/Powershell/ai-collab/core/src/*.sh
```

### Konfiguration

```bash
# API-Keys in lokaler Konfiguration setzen
cd /mnt/a/Dokumente/Entwicklung/Powershell/ai-collab
cp local/config/.env.template local/config/.env
# .env editieren und API-Keys eintragen
```

### Backup-Strategie

```bash
# Automatische Backups werden im local/ Verzeichnis erstellt
# Diese sind NICHT in Git versioniert
ls -la local/development/snapshots/
```

---

## 🎯 Erwartete Verbesserungen

### Kostenreduzierung

| Kategorie | Vorher | Nachher | Ersparnis |
|-----------|--------|---------|-----------|
| Einfache Fixes | $0.15 | $0.04 | 73% |
| Code-Reviews | $0.50 | $0.20 | 60% |
| Feature-Entwicklung | $2.00 | $0.80 | 60% |
| Architektur-Entscheidungen | $5.00 | $3.00 | 40% |

**Gesamterschätzung**: 60-75% Kostenreduktion bei gleicher oder besserer Qualität.

### Entwicklungseffizienz

- **60-70% weniger Prompt-Engineering** durch Templates
- **Persistente Sessions** reduzieren Kontext-Wiederholung
- **Automatische Modellwahl** optimiert Kosten/Qualität-Verhältnis
- **Multi-Projekt-Support** ermöglicht Skalierung

### Wartbarkeit

- **Klare Trennung** zwischen generischen AI-Tools und CSV2Actual
- **Versionierte Templates** für konsistente Code-Qualität
- **Strukturierte Dokumentation** für bessere Nachvollziehbarkeit

---

## ✅ Validierung der Migration

### Funktionstest

```bash
# System-Test ausführen
/mnt/a/Dokumente/Entwicklung/Powershell/ai-collab/test-system.sh

# Alle Tests sollten "OK" zeigen:
# ✓ Struktur, Skripte, Templates, Projekt-Links, Funktionen
```

### Kostenvergleich

```bash
# Baseline vor Migration dokumentieren
# Nach 1 Woche neues System Kosten vergleichen
cost-optimizer.sh report weekly
```

### Template-Nutzung

```bash
# Template-Adoption prüfen
jq '.optimization_stats.template_reuse' local/development/usage_analytics.json
```

---

## 🚀 Nächste Schritte

1. **Migration abschließen**: Alte ai-collab Dateien aus CSV2Actual entfernen
2. **GitHub Repository**: ai-collab als eigenständiges Repository erstellen
3. **Dokumentation**: README und API-Dokumentation vervollständigen
4. **Community**: Projekt öffentlich verfügbar machen
5. **Erweiterungen**: Weitere Templates und Optimierungen hinzufügen

---

## 📞 Support

Bei Problemen während der Migration:

1. **System-Test**: `ai-collab/test-system.sh` ausführen
2. **Logs prüfen**: `local/development/protocols/` durchsuchen
3. **Konfiguration**: `local/config/settings.json` validieren
4. **Backup wiederherstellen**: Bei kritischen Problemen

**Die Migration ist erfolgreich, wenn alle Tests grün sind und die erste ai-collab Session funktioniert!** 🎉