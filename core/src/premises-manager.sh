#!/bin/bash
# FILE: ./core/src/premises-manager.sh
# Prämissen-Management-Modul für ai-collab
# Entwicklungsphilosophie-Tagebuch mit Snapshot-System

VERSION="1.0.0"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Pfad-Konfiguration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PREMISES_DIR="$PROJECT_ROOT/local/development/premises"
SNAPSHOTS_DIR="$PREMISES_DIR/snapshots"
CURRENT_PREMISES_FILE="$PREMISES_DIR/current.json"
EVOLUTION_LOG="$PREMISES_DIR/evolution.log"

# Initialisierung
init_premises_system() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                PREMISES MANAGEMENT SYSTEM                    ║${NC}"
    echo -e "${PURPLE}║              Entwicklungsphilosophie-Tagebuch                ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    mkdir -p "$PREMISES_DIR" "$SNAPSHOTS_DIR"
    
    if [ ! -f "$CURRENT_PREMISES_FILE" ]; then
        echo -e "${CYAN}🎯 Erstelle initiale Prämissen-Datei...${NC}"
        create_initial_premises
    else
        echo -e "${GREEN}✅ Prämissen-System bereits initialisiert${NC}"
    fi
    
    echo -e "${BLUE}📂 Prämissen-Verzeichnis: $PREMISES_DIR${NC}"
    echo -e "${BLUE}📸 Snapshots: $SNAPSHOTS_DIR${NC}"
}

# Initiale Prämissen erstellen
create_initial_premises() {
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
    local version="1.0.0"
    
    cat > "$CURRENT_PREMISES_FILE" << EOF
{
  "premises_version": "$version",
  "timestamp": "$timestamp",
  "context": "ai-collab System-Initialisierung",
  "session_context": "Erstes Prämissen-Setup",
  "premises": [
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
      }
    },
    {
      "id": "modular_architecture",
      "category": "technical",
      "principle": "Modulare Architektur mit loser Kopplung",
      "rationale": "Jedes Modul muss eigenständig funktionieren und austauschbar sein",
      "confidence": 0.9,
      "priority": "high",
      "evidence": [
        "Bash-First-Ansatz für Portabilität",
        "JSON-Kommunikation zwischen Modulen",
        "Plugin-System erfolgreich implementiert"
      ],
      "metrics": {
        "module_independence": 0.9,
        "coupling_score": "low"
      }
    },
    {
      "id": "session_persistence",
      "category": "operational",
      "principle": "Vollständige Session-Persistenz und Reproduzierbarkeit",
      "rationale": "Jede Entwicklungs-Interaktion muss reproduzierbar und nachvollziehbar sein",
      "confidence": 0.85,
      "priority": "medium",
      "evidence": [
        "Session-Manager implementiert",
        "Parameter-Cache über Session-Grenzen hinweg",
        "Kosten-Tracking vollständig"
      ],
      "metrics": {
        "session_coverage": 0.9,
        "reproducibility_score": 0.85
      }
    },
    {
      "id": "developer_experience",
      "category": "user_experience",
      "principle": "CLI-First für maximale Developer-Productivity",
      "rationale": "Entwickler sollen sich auf Kreativität konzentrieren, ai-collab managt Komplexität",
      "confidence": 0.8,
      "priority": "medium",
      "evidence": [
        "Sofortiges Feedback in allen Modulen",
        "Selbsterklärende Kommandozeilen-Tools",
        "Fehlertoleranz bei fehlenden Komponenten"
      ],
      "metrics": {
        "cli_response_time": "<2s",
        "error_recovery_rate": 0.9
      }
    },
    {
      "id": "integration_ready",
      "category": "ecosystem",
      "principle": "Nahtlose Integration in bestehende Entwicklungs-Workflows",
      "rationale": "ai-collab muss sich in vorhandene Tools einfügen, nicht ersetzen",
      "confidence": 0.8,
      "priority": "medium",
      "evidence": [
        "GitHub-Integration vollständig",
        "PM-System (Kanboard) erfolgreich integriert",
        "JSON-RPC-API für externe Tools"
      ],
      "metrics": {
        "integration_coverage": ["github", "kanboard", "json_rpc"],
        "workflow_disruption": "minimal"
      }
    }
  ],
  "meta": {
    "total_premises": 5,
    "avg_confidence": 0.86,
    "last_review": "$timestamp",
    "next_review_due": "$(date -u -d '+1 week' +"%Y-%m-%dT%H:%M:%S+00:00")"
  }
}
EOF

    echo -e "${GREEN}✅ Initiale Prämissen erstellt: $version${NC}"
    log_evolution "INIT" "Initiale Prämissen-Datei erstellt" "$version"
}

# Neue Prämisse hinzufügen
add_premise() {
    local principle="$1"
    local category="${2:-general}"
    local rationale="$3"
    local confidence="${4:-0.8}"
    
    if [ -z "$principle" ]; then
        echo -e "${RED}❌ Fehler: Prinzip ist erforderlich${NC}"
        echo "Usage: $0 add \"<principle>\" [category] [rationale] [confidence]"
        return 1
    fi
    
    echo -e "${CYAN}🎯 Neue Prämisse hinzufügen...${NC}"
    echo -e "${BLUE}Prinzip: $principle${NC}"
    echo -e "${BLUE}Kategorie: $category${NC}"
    
    # Interaktive Eingabe falls Rationale fehlt
    if [ -z "$rationale" ]; then
        echo -e "${YELLOW}Rationale eingeben (Warum ist dieses Prinzip wichtig?):${NC}"
        read -r rationale
    fi
    
    # ID generieren
    local premise_id=$(echo "$principle" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/__*/_/g')
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
    
    # Zu aktueller Datei hinzufügen
    local temp_file="/tmp/premises_temp.json"
    jq --arg id "$premise_id" \
       --arg principle "$principle" \
       --arg category "$category" \
       --arg rationale "$rationale" \
       --arg confidence "$confidence" \
       --arg timestamp "$timestamp" \
       '.premises += [{
         "id": $id,
         "category": $category,
         "principle": $principle,
         "rationale": $rationale,
         "confidence": ($confidence | tonumber),
         "priority": "medium",
         "evidence": [],
         "added_at": $timestamp
       }] | 
       .timestamp = $timestamp |
       .meta.total_premises = (.premises | length) |
       .meta.avg_confidence = ((.premises | map(.confidence) | add) / (.premises | length))' \
       "$CURRENT_PREMISES_FILE" > "$temp_file"
    
    mv "$temp_file" "$CURRENT_PREMISES_FILE"
    
    echo -e "${GREEN}✅ Prämisse hinzugefügt: $premise_id${NC}"
    log_evolution "ADD" "Neue Prämisse: $principle" "$(get_current_version)"
}

# Prämissen-Snapshot erstellen
create_snapshot() {
    local description="${1:-Manual snapshot}"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
    local version=$(increment_version "$(get_current_version)")
    local snapshot_file="$SNAPSHOTS_DIR/premises_v${version}_$(date +%Y%m%d_%H%M%S).json"
    
    echo -e "${CYAN}📸 Erstelle Prämissen-Snapshot...${NC}"
    
    # Snapshot mit Metadaten erstellen
    jq --arg version "$version" \
       --arg description "$description" \
       --arg timestamp "$timestamp" \
       '.premises_version = $version |
        .snapshot_description = $description |
        .snapshot_timestamp = $timestamp |
        .previous_version = .premises_version' \
       "$CURRENT_PREMISES_FILE" > "$snapshot_file"
    
    # Aktuelle Datei updaten
    jq --arg version "$version" \
       --arg timestamp "$timestamp" \
       '.premises_version = $version |
        .timestamp = $timestamp' \
       "$CURRENT_PREMISES_FILE" > "/tmp/premises_current.json"
    
    mv "/tmp/premises_current.json" "$CURRENT_PREMISES_FILE"
    
    echo -e "${GREEN}✅ Snapshot erstellt: v$version${NC}"
    echo -e "${BLUE}📂 Datei: $snapshot_file${NC}"
    echo -e "${BLUE}📝 Beschreibung: $description${NC}"
    
    log_evolution "SNAPSHOT" "$description" "$version"
}

# Prämissen-Historie anzeigen
show_history() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                  PRÄMISSEN-EVOLUTION                         ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ -f "$EVOLUTION_LOG" ]; then
        echo -e "${CYAN}=== ENTWICKLUNGS-TIMELINE ===${NC}"
        cat "$EVOLUTION_LOG" | tail -20
        echo ""
    fi
    
    echo -e "${CYAN}=== VERFÜGBARE SNAPSHOTS ===${NC}"
    if [ -d "$SNAPSHOTS_DIR" ]; then
        find "$SNAPSHOTS_DIR" -name "premises_v*.json" | sort -r | head -10 | while read -r snapshot; do
            local filename=$(basename "$snapshot")
            local version=$(echo "$filename" | sed 's/premises_v\([^_]*\).*/\1/')
            local description=$(jq -r '.snapshot_description // "Keine Beschreibung"' "$snapshot" 2>/dev/null)
            local timestamp=$(jq -r '.snapshot_timestamp // "Unbekannt"' "$snapshot" 2>/dev/null)
            echo -e "${BLUE}📸 v$version - $description${NC}"
            echo -e "${YELLOW}   $timestamp${NC}"
        done
    else
        echo -e "${YELLOW}Keine Snapshots gefunden${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}=== AKTUELLE PRÄMISSEN ===${NC}"
    show_current_premises
}

# Aktuelle Prämissen anzeigen
show_current_premises() {
    if [ ! -f "$CURRENT_PREMISES_FILE" ]; then
        echo -e "${RED}❌ Keine Prämissen-Datei gefunden${NC}"
        return 1
    fi
    
    local version=$(jq -r '.premises_version' "$CURRENT_PREMISES_FILE")
    local context=$(jq -r '.context' "$CURRENT_PREMISES_FILE")
    local total=$(jq -r '.meta.total_premises' "$CURRENT_PREMISES_FILE")
    local avg_confidence=$(jq -r '.meta.avg_confidence' "$CURRENT_PREMISES_FILE")
    
    echo -e "${BLUE}📋 Version: $version | Kontext: $context${NC}"
    echo -e "${BLUE}📊 Prämissen: $total | Ø Vertrauen: $(printf "%.2f" "$avg_confidence")${NC}"
    echo ""
    
    jq -r '.premises[] | "🎯 \(.principle)
   📂 Kategorie: \(.category) | Vertrauen: \(.confidence)
   💭 \(.rationale)
   📈 Evidenz: \(.evidence | join(", "))
"' "$CURRENT_PREMISES_FILE"
}

# Prämissen-Drift-Analyse
analyze_drift() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                   DRIFT-ANALYSE                              ║${NC}"
    echo -e "${PURPLE}║              Prämissen-Abweichung Detection                  ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Vergleich mit letztem Snapshot
    local latest_snapshot=$(find "$SNAPSHOTS_DIR" -name "premises_v*.json" | sort -r | head -1)
    
    if [ -f "$latest_snapshot" ]; then
        local snapshot_version=$(jq -r '.premises_version' "$latest_snapshot")
        local current_version=$(jq -r '.premises_version' "$CURRENT_PREMISES_FILE")
        
        echo -e "${CYAN}📊 Vergleiche: v$snapshot_version → v$current_version${NC}"
        echo ""
        
        # Confidence-Drift prüfen
        local old_confidence=$(jq -r '.meta.avg_confidence' "$latest_snapshot")
        local new_confidence=$(jq -r '.meta.avg_confidence' "$CURRENT_PREMISES_FILE")
        local confidence_diff=$(echo "$new_confidence - $old_confidence" | bc -l 2>/dev/null || echo "0")
        
        echo -e "${YELLOW}🔍 Vertrauen-Drift: $(printf "%.3f" "$confidence_diff")${NC}"
        
        if (( $(echo "$confidence_diff < -0.1" | bc -l 2>/dev/null) )); then
            echo -e "${RED}⚠️  Warnung: Signifikanter Vertrauensverlust!${NC}"
        fi
        
        # Neue/geänderte Prämissen
        echo -e "${CYAN}🆕 Änderungen seit letztem Snapshot:${NC}"
        # Hier würde eine detailliertere Diff-Analyse folgen
        
    else
        echo -e "${YELLOW}📸 Kein Snapshot für Vergleich verfügbar${NC}"
        echo -e "${BLUE}💡 Erstelle ersten Snapshot mit: $0 snapshot \"Baseline\"${NC}"
    fi
}

# Hilfsfunktionen
get_current_version() {
    if [ -f "$CURRENT_PREMISES_FILE" ]; then
        jq -r '.premises_version' "$CURRENT_PREMISES_FILE" 2>/dev/null || echo "1.0.0"
    else
        echo "1.0.0"
    fi
}

increment_version() {
    local version="$1"
    local major=$(echo "$version" | cut -d. -f1)
    local minor=$(echo "$version" | cut -d. -f2)
    local patch=$(echo "$version" | cut -d. -f3)
    
    patch=$((patch + 1))
    echo "$major.$minor.$patch"
}

log_evolution() {
    local action="$1"
    local description="$2"
    local version="$3"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
    
    echo "[$timestamp] [$action] v$version - $description" >> "$EVOLUTION_LOG"
}

# Hauptprogramm
case "${1:-help}" in
    "init")
        init_premises_system
        ;;
    "add")
        add_premise "$2" "$3" "$4" "$5"
        ;;
    "snapshot")
        create_snapshot "$2"
        ;;
    "show"|"current")
        show_current_premises
        ;;
    "history"|"log")
        show_history
        ;;
    "drift"|"analyze")
        analyze_drift
        ;;
    "help")
        echo "Premises Manager für ai-collab v$VERSION"
        echo ""
        echo "Commands:"
        echo "  init                           - Prämissen-System initialisieren"
        echo "  add \"<principle>\" [category] [rationale] - Neue Prämisse hinzufügen"
        echo "  snapshot [description]         - Prämissen-Snapshot erstellen"
        echo "  show                           - Aktuelle Prämissen anzeigen"
        echo "  history                        - Evolution und Snapshots anzeigen"
        echo "  drift                          - Drift-Analyse durchführen"
        echo "  help                           - Diese Hilfe"
        echo ""
        echo "Beispiele:"
        echo "  $0 init"
        echo "  $0 add \"Performance vor Eleganz\" technical \"Schnelle Iteration wichtiger\""
        echo "  $0 snapshot \"Nach PM-Integration\""
        echo "  $0 drift"
        ;;
    *)
        echo -e "${BLUE}Premises Manager v$VERSION${NC}"
        echo -e "${YELLOW}Verwende '$0 help' für alle Kommandos${NC}"
        ;;
esac