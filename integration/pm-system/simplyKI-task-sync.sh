#!/bin/bash

# SimplyKI Task Synchronisation Script
# Synchronisiert Tasks zwischen PM-System und internen Systemen

set -euo pipefail

# Konfiguration
PM_DB="/home/aicollab/ai-collab/ai-collab-pm/data/db.sqlite"
PROJECT_ID=1
ADMIN_USER_ID=1
CLAUDE_USER_ID=2

# Logging-Funktion
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Prüfe ob PM-Datenbank existiert und erreichbar ist
check_database() {
    if [[ ! -f "$PM_DB" ]]; then
        log "FEHLER: PM-Datenbank nicht gefunden: $PM_DB"
        exit 1
    fi
    
    if ! sqlite3 "$PM_DB" "SELECT 1 FROM projects WHERE id = $PROJECT_ID;" > /dev/null 2>&1; then
        log "FEHLER: SimplyKI Projekt (ID: $PROJECT_ID) nicht gefunden"
        exit 1
    fi
    
    log "PM-Datenbank erfolgreich verbunden"
}

# Zeige aktuellen Task-Status
show_task_status() {
    log "=== SimplyKI Task-Status ==="
    
    echo
    echo "📝 TO DO:"
    sqlite3 "$PM_DB" "
    SELECT '  - ' || t.title || ' (Besitzer: ' || COALESCE(u.username, 'Unassigned') || ')'
    FROM tasks t
    LEFT JOIN users u ON t.owner_id = u.id
    JOIN columns c ON t.column_id = c.id
    WHERE t.project_id = $PROJECT_ID AND c.title = 'To Do'
    ORDER BY t.position;
    "
    
    echo
    echo "🔄 IN PROGRESS:"
    sqlite3 "$PM_DB" "
    SELECT '  - ' || t.title || ' (Besitzer: ' || COALESCE(u.username, 'Unassigned') || ')'
    FROM tasks t
    LEFT JOIN users u ON t.owner_id = u.id
    JOIN columns c ON t.column_id = c.id
    WHERE t.project_id = $PROJECT_ID AND c.title = 'In Progress'
    ORDER BY t.position;
    "
    
    echo
    echo "🔍 REVIEW:"
    sqlite3 "$PM_DB" "
    SELECT '  - ' || t.title || ' (Besitzer: ' || COALESCE(u.username, 'Unassigned') || ')'
    FROM tasks t
    LEFT JOIN users u ON t.owner_id = u.id
    JOIN columns c ON t.column_id = c.id
    WHERE t.project_id = $PROJECT_ID AND c.title = 'Review'
    ORDER BY t.position;
    "
    
    echo
    echo "✅ DONE:"
    sqlite3 "$PM_DB" "
    SELECT '  - ' || t.title || ' (Besitzer: ' || COALESCE(u.username, 'Unassigned') || ')'
    FROM tasks t
    LEFT JOIN users u ON t.owner_id = u.id
    JOIN columns c ON t.column_id = c.id
    WHERE t.project_id = $PROJECT_ID AND c.title = 'Done'
    ORDER BY t.position;
    "
    echo
}

# Statistiken anzeigen
show_statistics() {
    log "=== SimplyKI Task-Statistiken ==="
    
    echo "📊 Task-Verteilung nach Status:"
    sqlite3 "$PM_DB" "
    SELECT 
        c.title || ': ' || COUNT(t.id) || ' Tasks'
    FROM columns c
    LEFT JOIN tasks t ON c.id = t.column_id AND t.project_id = $PROJECT_ID
    WHERE c.project_id = $PROJECT_ID
    GROUP BY c.id, c.title
    ORDER BY c.position;
    "
    
    echo
    echo "👥 Task-Verteilung nach Benutzer:"
    sqlite3 "$PM_DB" "
    SELECT 
        COALESCE(u.username, 'Unassigned') || ': ' || COUNT(t.id) || ' Tasks'
    FROM tasks t
    LEFT JOIN users u ON t.owner_id = u.id
    WHERE t.project_id = $PROJECT_ID
    GROUP BY u.username
    ORDER BY COUNT(t.id) DESC;
    "
    echo
}

# Hauptfunktion
main() {
    local command="${1:-status}"
    
    check_database
    
    case "$command" in
        "status"|"show")
            show_task_status
            ;;
        "stats"|"statistics")
            show_statistics
            ;;
        "help"|"-h"|"--help")
            echo "SimplyKI Task Synchronisation"
            echo
            echo "Verfügbare Kommandos:"
            echo "  status, show       - Zeige aktuellen Task-Status"
            echo "  stats, statistics  - Zeige Task-Statistiken"
            echo "  help               - Diese Hilfe"
            ;;
        *)
            log "Unbekanntes Kommando: $command"
            echo "Verwende '$0 help' für verfügbare Kommandos"
            exit 1
            ;;
    esac
}

# Skript ausführen
main "$@"