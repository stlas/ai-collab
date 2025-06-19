#!/bin/bash
# FILE: ./integration/pm-system/pm-analyzer.sh
# PM-System direkter Analyzer - Kanban-Datenbank Auswertung

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
PM_DB="$PROJECT_ROOT/ai-collab-pm/data/db.sqlite"
PM_DIR="$PROJECT_ROOT/ai-collab-pm"

# PM-System Status prüfen
check_pm_system() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                PM-SYSTEM DIRECT ANALYZER                     ║${NC}"
    echo -e "${PURPLE}║              Kanboard Database Analysis                      ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # System-Verfügbarkeit prüfen
    if [ -f "$PM_DB" ]; then
        local db_size=$(stat -f%z "$PM_DB" 2>/dev/null || stat -c%s "$PM_DB" 2>/dev/null)
        echo -e "${GREEN}✅ PM-Datenbank verfügbar: $(( $db_size / 1024 )) KB${NC}"
    else
        echo -e "${RED}❌ PM-Datenbank nicht gefunden: $PM_DB${NC}"
        return 1
    fi
    
    # Web-Server Status
    if curl -s http://localhost:8080 >/dev/null 2>&1; then
        echo -e "${GREEN}✅ PM-System online: http://localhost:8080${NC}"
    else
        echo -e "${YELLOW}⚠️  PM-System offline (Start mit: cd $PM_DIR && php -S localhost:8080)${NC}"
    fi
    echo ""
}

# Datenbank-Übersicht
analyze_database() {
    echo -e "${CYAN}=== DATENBANK-ANALYSE ===${NC}"
    
    # Tabellen-Anzahl
    local table_count=$(sqlite3 "$PM_DB" ".tables" | wc -w)
    echo -e "${BLUE}📊 Tabellen gesamt: $table_count${NC}"
    
    # Kern-Entitäten
    local projects=$(sqlite3 "$PM_DB" "SELECT COUNT(*) FROM projects;")
    local tasks=$(sqlite3 "$PM_DB" "SELECT COUNT(*) FROM tasks;")
    local users=$(sqlite3 "$PM_DB" "SELECT COUNT(*) FROM users;")
    local columns=$(sqlite3 "$PM_DB" "SELECT COUNT(*) FROM columns;")
    
    echo -e "${BLUE}🗂️  Projekte: $projects${NC}"
    echo -e "${BLUE}📋 Tasks: $tasks${NC}"
    echo -e "${BLUE}👥 Benutzer: $users${NC}"
    echo -e "${BLUE}📑 Kanban-Spalten: $columns${NC}"
    echo ""
}

# Detaillierte Projekt-Analyse
analyze_projects() {
    echo -e "${CYAN}=== PROJEKT-ANALYSE ===${NC}"
    
    local project_data=$(sqlite3 "$PM_DB" "SELECT id, name, description, is_active FROM projects;")
    
    if [ -n "$project_data" ]; then
        echo -e "${GREEN}📂 Aktive Projekte:${NC}"
        sqlite3 "$PM_DB" "SELECT 
            '  ID: ' || id || ' | Name: ' || name || ' | Status: ' || 
            CASE WHEN is_active = 1 THEN 'Aktiv' ELSE 'Inaktiv' END 
            FROM projects;"
    else
        echo -e "${YELLOW}📂 Keine Projekte gefunden${NC}"
        echo -e "${BLUE}💡 Neue Projekte können über das Web-Interface erstellt werden${NC}"
    fi
    echo ""
}

# Task-Analyse
analyze_tasks() {
    echo -e "${CYAN}=== TASK-ANALYSE ===${NC}"
    
    local task_count=$(sqlite3 "$PM_DB" "SELECT COUNT(*) FROM tasks;")
    
    if [ "$task_count" -gt 0 ]; then
        echo -e "${GREEN}📋 Tasks gefunden: $task_count${NC}"
        
        # Task-Status-Verteilung
        echo -e "${BLUE}📊 Status-Verteilung:${NC}"
        sqlite3 "$PM_DB" "SELECT 
            '  Column ID: ' || column_id || ' | Count: ' || COUNT(*) 
            FROM tasks 
            GROUP BY column_id;"
        
        # AI-Collab Tasks
        local ai_tasks=$(sqlite3 "$PM_DB" "SELECT COUNT(*) FROM tasks WHERE title LIKE '%AI Session%';")
        if [ "$ai_tasks" -gt 0 ]; then
            echo -e "${GREEN}🤖 AI-Collab Tasks: $ai_tasks${NC}"
        fi
    else
        echo -e "${YELLOW}📋 Keine Tasks gefunden${NC}"
        echo -e "${BLUE}💡 Tasks können automatisch von ai-collab importiert werden${NC}"
    fi
    echo ""
}

# Kosten-Tracking Analyse
analyze_costs() {
    echo -e "${CYAN}=== KOSTEN-TRACKING ===${NC}"
    
    # ai-collab Metadaten
    local cost_metadata=$(sqlite3 "$PM_DB" "SELECT COUNT(*) FROM task_has_metadata WHERE name = 'ai_collab_cost';")
    
    if [ "$cost_metadata" -gt 0 ]; then
        echo -e "${GREEN}💰 Kosten-Metadaten gefunden: $cost_metadata Einträge${NC}"
        sqlite3 "$PM_DB" "SELECT 
            '  Task ID: ' || task_id || ' | Kosten: $' || value 
            FROM task_has_metadata 
            WHERE name = 'ai_collab_cost';"
    else
        echo -e "${YELLOW}💰 Keine Kosten-Daten im PM-System${NC}"
        echo -e "${BLUE}💡 Import ai-collab Kosten mit: ./pm-analyzer.sh import-costs${NC}"
    fi
    echo ""
}

# Integration-Status
analyze_integration() {
    echo -e "${CYAN}=== AI-COLLAB INTEGRATION ===${NC}"
    
    # Plugin-Verfügbarkeit
    local plugin_dir="$PM_DIR/plugins/AiCollabIntegration"
    if [ -d "$plugin_dir" ]; then
        echo -e "${GREEN}🔌 ai-collab Plugin installiert${NC}"
        echo -e "${BLUE}📂 Plugin-Pfad: $plugin_dir${NC}"
    else
        echo -e "${YELLOW}🔌 ai-collab Plugin nicht gefunden${NC}"
    fi
    
    # Export-Daten-Status
    local export_dir="$SCRIPT_DIR/data-export"
    if [ -d "$export_dir" ]; then
        local export_files=$(ls -1 "$export_dir"/*.json 2>/dev/null | wc -l)
        echo -e "${GREEN}📤 Export-Dateien: $export_files${NC}"
        
        if [ -f "$export_dir/pm_integration_status.json" ]; then
            local last_export=$(jq -r '.export_timestamp' "$export_dir/pm_integration_status.json" 2>/dev/null)
            echo -e "${BLUE}🕒 Letzter Export: $last_export${NC}"
        fi
    fi
    echo ""
}

# API-Test
test_api() {
    echo -e "${CYAN}=== API-TEST ===${NC}"
    
    if curl -s http://localhost:8080 >/dev/null 2>&1; then
        # Version abrufen
        local version=$(curl -s -X POST http://localhost:8080/jsonrpc.php \
            -H "Content-Type: application/json" \
            -d '{"jsonrpc":"2.0","method":"getVersion","id":1}' | \
            jq -r '.result' 2>/dev/null)
        
        if [ "$version" != "null" ] && [ -n "$version" ]; then
            echo -e "${GREEN}🌐 JSON-RPC API funktional${NC}"
            echo -e "${BLUE}📈 Kanboard Version: $version${NC}"
        else
            echo -e "${YELLOW}🌐 API erreichbar, aber Antwort-Fehler${NC}"
        fi
    else
        echo -e "${RED}🌐 API nicht erreichbar (System offline)${NC}"
        echo -e "${BLUE}💡 Start PM-System: cd $PM_DIR && php -S localhost:8080${NC}"
    fi
    echo ""
}

# Vollständiger Report
full_report() {
    check_pm_system
    analyze_database
    analyze_projects
    analyze_tasks
    analyze_costs
    analyze_integration
    test_api
    
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                    ANALYZER COMPLETE                         ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
}

# Hauptprogramm
case "${1:-full}" in
    "db"|"database")
        check_pm_system
        analyze_database
        ;;
    "projects")
        analyze_projects
        ;;
    "tasks")
        analyze_tasks
        ;;
    "costs")
        analyze_costs
        ;;
    "integration")
        analyze_integration
        ;;
    "api")
        test_api
        ;;
    "full"|"")
        full_report
        ;;
    "help")
        echo "PM-System Analyzer v$VERSION"
        echo ""
        echo "Commands:"
        echo "  full          - Vollständiger Report (Standard)"
        echo "  db            - Datenbank-Analyse"
        echo "  projects      - Projekt-Analyse"
        echo "  tasks         - Task-Analyse"
        echo "  costs         - Kosten-Tracking-Analyse"
        echo "  integration   - Integration-Status"
        echo "  api           - API-Test"
        echo "  help          - Diese Hilfe"
        ;;
    *)
        echo -e "${BLUE}PM-System Analyzer v$VERSION${NC}"
        echo -e "${YELLOW}Verwende '$0 help' für alle Kommandos${NC}"
        ;;
esac