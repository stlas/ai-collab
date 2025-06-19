# Prämissen-Management System

## Übersicht

Das Prämissen-Management-System ist ein zentrales Feature von ai-collab v2.1.0, das die **Entwicklungsphilosophie als living document** verwaltet. Es dokumentiert automatisch alle Designentscheidungen, Prinzipien und deren Evolution über die Zeit.

## 🎯 Konzept

### Was sind Prämissen?
Prämissen sind die **Grundannahmen und Prinzipien**, die Entwicklungsentscheidungen leiten:
- Technische Architektur-Prinzipien
- Wirtschaftliche Optimierungsziele  
- User-Experience-Leitlinien
- Betriebliche Workflow-Regeln
- Ecosystem-Integration-Strategien

### Warum Prämissen-Management?
- **Konsistenz**: Alle Entscheidungen folgen dokumentierten Prinzipien
- **Nachvollziehbarkeit**: Stakeholder verstehen "Warum" hinter Entscheidungen
- **Anti-Drift**: Warnung bei Abweichung von Kernwerten
- **Team-Onboarding**: Neue Mitglieder verstehen Projekt-DNA sofort
- **Retrospektiven**: "Wann haben wir X als Prinzip etabliert?"

## 📋 Kernfunktionen

### 1. Prämissen hinzufügen
```bash
./core/src/ai-collab.sh premises add "Performance vor Eleganz" technical "Schnelle Iteration wichtiger als perfekter Code"
```

**Parameter:**
- `principle`: Das Grundprinzip (erforderlich)
- `category`: Kategorisierung (technical, economic, user_experience, etc.)
- `rationale`: Begründung warum dieses Prinzip wichtig ist
- `confidence`: Vertrauen in das Prinzip (0.0-1.0, default: 0.8)

### 2. Aktuelle Prämissen anzeigen
```bash
./core/src/ai-collab.sh premises show
```

**Zeigt:**
- Alle aktuellen Prinzipien
- Kategorien und Vertrauen-Level
- Begründungen und Evidenz
- Durchschnittliches Vertrauen
- Gesamtanzahl Prämissen

### 3. Snapshot-Versionierung
```bash
./core/src/ai-collab.sh premises snapshot "Nach Login-System-Implementierung"
```

**Erstellt:**
- Versionierte Kopie aller aktuellen Prämissen
- Timestamp und Beschreibung
- Automatische Versionsnummer (1.0.1, 1.0.2, etc.)
- Vergleichbare Baseline für Drift-Analyse

### 4. Evolution-Historie
```bash
./core/src/ai-collab.sh premises history
```

**Zeigt:**
- Chronologische Timeline aller Änderungen
- Verfügbare Snapshots mit Beschreibungen
- Entwicklungs-Log mit Timestamps
- Aktuelle Prämissen-Übersicht

### 5. Drift-Analyse
```bash
./core/src/ai-collab.sh premises drift
```

**Analysiert:**
- Vertrauens-Drift seit letztem Snapshot
- Neue/geänderte Prämissen
- Warnung bei signifikantem Vertrauensverlust
- Empfehlungen für Korrekturmaßnahmen

## 🗂️ Kategorien-System

### Economic
- Kostenoptimierung
- Budget-Entscheidungen
- ROI-Prinzipien
- Ressourcen-Allokation

**Beispiele:**
- "Kostenoptimierung vor Feature-Komplexität"
- "Template-Wiederverwendung > 60% Kostenersparnis"

### Technical
- Architektur-Prinzipien
- Technologie-Auswahl
- Code-Qualität-Standards
- Performance-Ziele

**Beispiele:**
- "Modulare Architektur mit loser Kopplung"
- "Bash-First für maximale Portabilität"

### Operational
- Workflow-Prozesse
- Deployment-Strategien
- Monitoring-Ansätze
- Backup-Richtlinien

**Beispiele:**
- "Vollständige Session-Persistenz und Reproduzierbarkeit"
- "Automatische Snapshots bei kritischen Änderungen"

### User Experience
- UI/UX-Prinzipien
- Benutzerführung
- Accessibility-Standards
- Performance-Wahrnehmung

**Beispiele:**
- "CLI-First für maximale Developer-Productivity"
- "Sofortiges Feedback in allen Modulen"

### Ecosystem
- Tool-Integration
- API-Design
- Compatibility-Anforderungen
- Vendor-Strategien

**Beispiele:**
- "Nahtlose Integration in bestehende Entwicklungs-Workflows"
- "JSON-RPC-API für externe Tools"

## 📊 Datenstruktur

### Prämissen-Objekt
```json
{
  "id": "cost_optimization_first",
  "category": "economic",
  "principle": "Kostenoptimierung vor Feature-Komplexität",
  "rationale": "Entwicklungskosten müssen vorhersagbar und kontrollierbar bleiben",
  "confidence": 0.95,
  "priority": "high",
  "evidence": [
    "75% Kostenersparnis bei CSV2Actual-Projekt erreicht",
    "Template-System reduziert Prompt-Kosten um 60-70%"
  ],
  "metrics": {
    "cost_reduction_target": 0.7,
    "roi_threshold": 2.0
  },
  "added_at": "2025-06-19T21:29:23+00:00"
}
```

### Snapshot-Format
```json
{
  "premises_version": "1.0.2",
  "snapshot_timestamp": "2025-06-19T21:31:05+00:00",
  "snapshot_description": "Prämissen-Management-Modul erfolgreich implementiert",
  "context": "ai-collab System-Entwicklung",
  "premises": [...],
  "meta": {
    "total_premises": 6,
    "avg_confidence": 0.87,
    "last_review": "2025-06-19T21:29:23+00:00"
  }
}
```

## 🔄 Workflow-Integration

### Entwicklungsprozess
1. **Projektstart**: Initiale Prämissen definieren
2. **Feature-Entwicklung**: Neue Prinzipien bei wichtigen Entscheidungen
3. **Code-Reviews**: Prämissen-Konformität prüfen
4. **Releases**: Snapshot vor jedem Release
5. **Retrospektiven**: Drift-Analyse und Prämissen-Update

### PM-System Integration
```bash
# Prämissen ins PM-System exportieren
./integration/pm-system/ai-collab-pm-integration.sh export
```

**Exportiert:**
- Aktuelle Prämissen für Stakeholder-Dashboard
- Prämissen-Evolution für Compliance-Reports
- Confidence-Metriken für Management-Übersicht

### Session-Integration
Prämissen-Updates werden automatisch in Session-Protokolle integriert:
- Neue Prinzipien → Session-Log-Eintrag
- Snapshots → Session-Meilenstein
- Drift-Warnungen → Session-Alert

## 🎯 Best Practices

### Prämissen formulieren
- **Konkret**: "Performance vor Eleganz" statt "Gute Performance"
- **Messbar**: Mit Metriken/Schwellwerten wo möglich
- **Begründet**: Immer Rationale mitliefern
- **Zeitgebunden**: Regelmäßige Review-Zyklen

### Kategorisierung
- **Eindeutig**: Jede Prämisse hat klare Kategorie
- **Konsistent**: Ähnliche Prinzipien in gleicher Kategorie
- **Skalierbar**: Neue Kategorien bei Bedarf hinzufügen

### Snapshot-Timing
- **Vor Releases**: Immer Baseline vor großen Releases
- **Nach wichtigen Entscheidungen**: Bei Architektur-Änderungen
- **Wöchentlich**: Bei aktiver Entwicklung
- **Bei Team-Changes**: Onboarding/Offboarding

### Drift-Monitoring
- **Wöchentliche Checks**: Regelmäßige Drift-Analyse
- **Confidence-Trends**: Abnehmende Werte untersuchen
- **Team-Reviews**: Prämissen-Diskussion im Team
- **Stakeholder-Updates**: Änderungen kommunizieren

## 🔍 Troubleshooting

### Problem: "Keine Prämissen-Datei gefunden"
```bash
# Lösung: System initialisieren
./core/src/ai-collab.sh premises init
```

### Problem: "Snapshot-Erstellung fehlgeschlagen"
```bash
# Prüfe Verzeichnis-Berechtigung
ls -la local/development/premises/

# Erstelle Verzeichnis falls nötig
mkdir -p local/development/premises/snapshots
```

### Problem: "Drift-Analyse zeigt keine Daten"
```bash
# Mindestens ein Snapshot erforderlich
./core/src/ai-collab.sh premises snapshot "Baseline"
```

### Problem: "JSON-Parsing-Fehler"
```bash
# Prüfe Datei-Integrität
jq '.' local/development/premises/current.json

# Bei Korruption: Von Snapshot wiederherstellen
cp local/development/premises/snapshots/premises_v1.0.1_*.json local/development/premises/current.json
```

## 📈 Metriken & Analytics

### Confidence-Tracking
- **Durchschnittliches Vertrauen**: Gesamt-Confidence aller Prämissen
- **Trend-Analyse**: Vertrauen über Zeit
- **Kategorie-Confidence**: Vertrauen nach Bereichen
- **Drift-Rate**: Geschwindigkeit der Änderungen

### Prämissen-Statistiken
- **Anzahl nach Kategorie**: Verteilung der Prinzipien
- **Evolution-Rate**: Häufigkeit von Änderungen
- **Snapshot-Frequenz**: Review-Zyklen-Analyse
- **Team-Engagement**: Prämissen-Diskussion-Aktivität

### PM-Dashboard-Integration
- **Real-time Confidence**: Live-Vertrauen im Web-Interface
- **Prämissen-Widgets**: Top-Prinzipien für Stakeholder
- **Evolution-Timeline**: Historische Entwicklung
- **Drift-Alerts**: Automatische Benachrichtigungen

## 🚀 Zukunfts-Features

### Geplante Erweiterungen
- **Multi-Team-Prämissen**: Verschiedene Teams, gemeinsame Prinzipien
- **Automated Compliance**: Code-Analyse vs. Prämissen
- **Machine Learning**: Pattern-Erkennung in Prämissen-Evolution
- **Export-Standards**: Integration in externe Governance-Tools

---

**Das Prämissen-Management macht ai-collab's Entwicklungsphilosophie transparent, nachvollziehbar und kontinuierlich verbesserbar.** 🧠📚