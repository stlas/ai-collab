#!/bin/bash
# FILE: ./integration/pm-system/todo-sync.sh
# Todo-Liste Synchronisation zwischen ai-collab und PM-System

VERSION="1.0.0"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Pfad-Konfiguration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DATA_EXPORT_DIR="$SCRIPT_DIR/data-export"

# Todo-Export Funktion
export_todo_list() {
    echo -e "${CYAN}📋 Exportiere aktuelle Todo-Liste...${NC}"
    
    # Erstelle Todo-Export-Datei
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
    local todo_file="$DATA_EXPORT_DIR/claude_todo_list.json"
    
    # Template für Todo-Export
    cat > "$todo_file" << EOF
{
  "export_timestamp": "$timestamp",
  "source": "claude_code_session",
  "todo_items": [
    {
      "id": "1",
      "title": "PM-System Integration prüfen",
      "description": "Datenaustausch zwischen ai-collab und Kanban überprüfen",
      "status": "completed",
      "priority": "high",
      "category": "system_integration"
    },
    {
      "id": "2", 
      "title": "Sync-Mechanismus analysieren",
      "description": "Wie werden Tasks zwischen Systemen synchronisiert",
      "status": "completed",
      "priority": "high",
      "category": "analysis"
    },
    {
      "id": "3",
      "title": "Todo-Liste mit PM-System verknüpfen",
      "description": "Sync zwischen Claude Todo-Liste und Kanban-Tasks implementieren",
      "status": "in_progress", 
      "priority": "medium",
      "category": "development"
    }
  ],
  "integration_meta": {
    "session_context": "ai-collab workflow analysis",
    "export_format": "kanban_ready",
    "auto_sync": true
  }
}
EOF

    echo -e "${GREEN}✅ Todo-Liste exportiert: $todo_file${NC}"
}

# PM-System Todo-Import (simuliert)
simulate_pm_import() {
    echo -e "${CYAN}🔄 Simuliere PM-System Import...${NC}"
    
    local todo_file="$DATA_EXPORT_DIR/claude_todo_list.json"
    if [ -f "$todo_file" ]; then
        local todo_count=$(jq '.todo_items | length' "$todo_file")
        echo -e "${BLUE}📊 $todo_count Todo-Items für PM-Import bereit${NC}"
        
        # Zeige Import-Preview
        echo -e "${YELLOW}🎯 Kanban-Tasks werden erstellt:${NC}"
        jq -r '.todo_items[] | "  - [\(.priority | ascii_upcase)] \(.title) (\(.status))"' "$todo_file"
        
        echo -e "${GREEN}✅ PM-Import erfolgreich simuliert${NC}"
    else
        echo -e "${RED}❌ Keine Todo-Daten zum Import gefunden${NC}"
        return 1
    fi
}

# Status der Todo-Sync
show_sync_status() {
    echo -e "${CYAN}=== TODO-SYNC STATUS ===${NC}"
    
    local todo_file="$DATA_EXPORT_DIR/claude_todo_list.json"
    if [ -f "$todo_file" ]; then
        local export_time=$(jq -r '.export_timestamp' "$todo_file")
        local todo_count=$(jq -r '.todo_items | length' "$todo_file")
        local completed_count=$(jq -r '.todo_items | map(select(.status == "completed")) | length' "$todo_file")
        local in_progress_count=$(jq -r '.todo_items | map(select(.status == "in_progress")) | length' "$todo_file")
        
        echo -e "${GREEN}✅ Letzter Export: $export_time${NC}"
        echo -e "${BLUE}📊 Gesamt: $todo_count Tasks${NC}"
        echo -e "${GREEN}✅ Abgeschlossen: $completed_count${NC}"
        echo -e "${YELLOW}🔄 In Bearbeitung: $in_progress_count${NC}"
    else
        echo -e "${YELLOW}⚠️  Noch kein Todo-Export durchgeführt${NC}"
    fi
}

# Hauptprogramm
case "${1:-help}" in
    "export")
        export_todo_list
        ;;
    "import")
        simulate_pm_import
        ;;
    "sync")
        export_todo_list
        simulate_pm_import
        ;;
    "status")
        show_sync_status
        ;;
    "help")
        echo "Todo-Sync für ai-collab PM-Integration v$VERSION"
        echo ""
        echo "Commands:"
        echo "  export        - Exportiere Todo-Liste für PM-System"
        echo "  import        - Simuliere PM-System Import"
        echo "  sync          - Vollständige Synchronisation"
        echo "  status        - Sync-Status anzeigen"
        echo "  help          - Diese Hilfe"
        ;;
    *)
        echo -e "${BLUE}Todo-Sync v$VERSION${NC}"
        echo -e "${YELLOW}Verwende '$0 help' für alle Kommandos${NC}"
        ;;
esac