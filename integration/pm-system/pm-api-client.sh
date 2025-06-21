#!/bin/bash
# PM-System API Client für direkte Kanboard-Integration

PM_DB="/home/aicollab/ai-collab/ai-collab-pm/data/db.sqlite"
PM_URL="http://localhost:8080"

# Benutzer-IDs
CLAUDE_USER_ID=2
ADMIN_USER_ID=1

echo "🔗 PM-System API Client für SimplyKI-Integration"

# Projekt-ID abrufen oder erstellen
get_or_create_project() {
    local project_name="$1"
    local description="$2"
    
    # Prüfen ob Projekt existiert
    local project_id=$(sqlite3 "$PM_DB" "SELECT id FROM projects WHERE name='$project_name';" 2>/dev/null)
    
    if [ -z "$project_id" ]; then
        echo "📝 Erstelle Projekt: $project_name"
        sqlite3 "$PM_DB" "INSERT INTO projects (name, description, owner_id, is_active) VALUES ('$project_name', '$description', $ADMIN_USER_ID, 1);"
        project_id=$(sqlite3 "$PM_DB" "SELECT last_insert_rowid();")
        
        # Standard-Spalten erstellen
        sqlite3 "$PM_DB" "INSERT INTO columns (title, position, project_id) VALUES ('Backlog', 1, $project_id);"
        sqlite3 "$PM_DB" "INSERT INTO columns (title, position, project_id) VALUES ('In Progress', 2, $project_id);"
        sqlite3 "$PM_DB" "INSERT INTO columns (title, position, project_id) VALUES ('Done', 3, $project_id);"
        
        echo "✅ Projekt erstellt mit ID: $project_id"
    else
        echo "✅ Projekt gefunden mit ID: $project_id"
    fi
    
    echo "$project_id"
}

# Task erstellen
create_task() {
    local project_id="$1"
    local title="$2"
    local description="$3"
    local owner_id="$4"
    local priority="$5"
    local column_id="${6:-1}"  # Default: Backlog
    
    # Prüfen ob Task bereits existiert
    local existing_task=$(sqlite3 "$PM_DB" "SELECT id FROM tasks WHERE title='$title' AND project_id=$project_id;" 2>/dev/null)
    
    if [ -z "$existing_task" ]; then
        sqlite3 "$PM_DB" "INSERT INTO tasks (title, description, project_id, owner_id, creator_id, column_id, priority, position, date_creation) VALUES ('$title', '$description', $project_id, $owner_id, $ADMIN_USER_ID, $column_id, $priority, 1, $(date +%s));"
        local task_id=$(sqlite3 "$PM_DB" "SELECT last_insert_rowid();")
        echo "✅ Task erstellt: $title (ID: $task_id, Owner: $owner_id)"
        echo "$task_id"
    else
        echo "⚪ Task existiert bereits: $title (ID: $existing_task)"
        echo "$existing_task"
    fi
}

# Kategorie erstellen
create_category() {
    local project_id="$1"
    local category_name="$2"
    
    local category_id=$(sqlite3 "$PM_DB" "SELECT id FROM project_has_categories WHERE name='$category_name' AND project_id=$project_id;" 2>/dev/null)
    
    if [ -z "$category_id" ]; then
        sqlite3 "$PM_DB" "INSERT INTO project_has_categories (name, project_id) VALUES ('$category_name', $project_id);"
        category_id=$(sqlite3 "$PM_DB" "SELECT last_insert_rowid();")
        echo "📂 Kategorie erstellt: $category_name (ID: $category_id)"
    fi
    echo "$category_id"
}

# SimplyKI-Tasks synchronisieren
sync_simplyKI_tasks() {
    echo "🔄 Synchronisiere SimplyKI-Tasks mit PM-System..."
    
    # Projekt erstellen/abrufen
    local project_id=$(get_or_create_project "SimplyKI Meta-Framework" "Entwicklung des Meta-Frameworks für KI-Development-Tools")
    
    # Kategorien erstellen
    local repo_cat=$(create_category "$project_id" "Repository Setup")
    local pm_cat=$(create_category "$project_id" "PM Integration")
    local core_cat=$(create_category "$project_id" "Core Infrastructure")
    local web_cat=$(create_category "$project_id" "Web Frontend")
    local doc_cat=$(create_category "$project_id" "Documentation")
    
    # Standard-Spalten-IDs abrufen
    local backlog_col=$(sqlite3 "$PM_DB" "SELECT id FROM columns WHERE project_id=$project_id AND title='Backlog';" 2>/dev/null)
    local progress_col=$(sqlite3 "$PM_DB" "SELECT id FROM columns WHERE project_id=$project_id AND title='In Progress';" 2>/dev/null)
    local done_col=$(sqlite3 "$PM_DB" "SELECT id FROM columns WHERE project_id=$project_id AND title='Done';" 2>/dev/null)
    
    echo "📊 Spalten: Backlog=$backlog_col, Progress=$progress_col, Done=$done_col"
    
    # Tasks erstellen - Repository Setup (Completed)
    create_task "$project_id" "GitHub Repository stlas/SimplyKI erstellen" "GitHub Repository mit korrekten Settings, Lizenz und README erstellen" "$CLAUDE_USER_ID" "3" "$done_col"
    create_task "$project_id" "Basis-Verzeichnisstruktur aufbauen" "Ordnerstruktur: web/, core/, tools/, docs/ mit entsprechenden README-Dateien" "$CLAUDE_USER_ID" "3" "$done_col"
    create_task "$project_id" "ai-collab als Git-Submodul einbinden" "ai-collab Repository als Submodul unter tools/ integrieren" "$CLAUDE_USER_ID" "2" "$done_col"
    create_task "$project_id" "Repository-Namen und URLs finalisieren" "Endgültige Repository-Namen, Branch-Strategien und URL-Struktur festlegen" "$ADMIN_USER_ID" "3" "$done_col"
    
    # PM Integration Tasks
    create_task "$project_id" "Claude-User im PM-System anlegen" "Benutzer Claude im Kanboard-System anlegen für Task-Zuweisungen" "$CLAUDE_USER_ID" "3" "$done_col"
    create_task "$project_id" "PM-System API-Client entwickeln" "Direkter API-Client für Kanboard-Integration mit Task-Synchronisation" "$CLAUDE_USER_ID" "3" "$progress_col"
    create_task "$project_id" "PM-System für Multi-Repository konfigurieren" "Kanboard-Setup für mehrere Repositories und Cross-Projekt-Tasks" "$ADMIN_USER_ID" "2" "$backlog_col"
    
    # Core Infrastructure Tasks
    create_task "$project_id" "Core-Setup-Script (setup.sh) entwickeln" "Automatisches Setup-Script für SimplyKI-Core-Infrastruktur" "$CLAUDE_USER_ID" "3" "$done_col"
    create_task "$project_id" "Plugin-System-Architektur implementieren" "Modulares Plugin-System für einfache Integration neuer KI-Tools" "$CLAUDE_USER_ID" "3" "$done_col"
    create_task "$project_id" "Authentication & Database-Schema erstellen" "User-Management, Sessions und SQLite-Schema für Production" "$CLAUDE_USER_ID" "3" "$done_col"
    create_task "$project_id" "API-Struktur für Tool-Integration definieren" "REST-API für Kommunikation zwischen Tools und Web-Frontend" "$CLAUDE_USER_ID" "2" "$backlog_col"
    
    # Web Frontend Tasks
    create_task "$project_id" "Vue.js Web-App Grundstruktur" "Vue.js-basierte SPA mit Routing, Stores und Component-Architektur" "$CLAUDE_USER_ID" "3" "$progress_col"
    create_task "$project_id" "User Authentication & Dashboard" "Login/Register-System mit benutzerfreundlichem Dashboard" "$CLAUDE_USER_ID" "2" "$progress_col"
    create_task "$project_id" "ai-collab Web-Interface entwickeln" "Browser-basierte Oberfläche für ai-collab-Tool" "$CLAUDE_USER_ID" "2" "$progress_col"
    create_task "$project_id" "SimplyKI.net Live-Platform vorbereiten" "Production-ready Deployment für SimplyKI.net Domain" "$CLAUDE_USER_ID" "3" "$progress_col"
    
    # Documentation Tasks
    create_task "$project_id" "SimplyKI Meta-Framework README schreiben" "Umfassende Dokumentation des Meta-Framework-Konzepts" "$CLAUDE_USER_ID" "3" "$done_col"
    create_task "$project_id" "API-Dokumentation erstellen" "Technische API-Docs für Plugin-Entwickler" "$CLAUDE_USER_ID" "2" "$backlog_col"
    create_task "$project_id" "User-Guide für SimplyKI.net schreiben" "Benutzerhandbuch für Web-Platform" "$CLAUDE_USER_ID" "2" "$backlog_col"
    
    # Domain & Deployment Tasks
    create_task "$project_id" "SimplyKI.net Domain-Hosting einrichten" "Node.js-Hosting und Domain-Konfiguration" "$ADMIN_USER_ID" "3" "$progress_col"
    create_task "$project_id" "GitHub Actions CI/CD Pipeline" "Automatisches Deployment von GitHub zu SimplyKI.net" "$CLAUDE_USER_ID" "2" "$progress_col"
    create_task "$project_id" "Production-Konfiguration & Monitoring" "Environment-Setup und Monitoring für Live-Platform" "$CLAUDE_USER_ID" "2" "$backlog_col"
    
    echo ""
    echo "🎯 SimplyKI Task-Synchronisation abgeschlossen!"
    echo "📊 Projekt-ID: $project_id"
    echo "👥 Users: Claude (ID: $CLAUDE_USER_ID), Admin (ID: $ADMIN_USER_ID)"
    echo ""
    echo "🌐 PM-System öffnen:"
    echo "   URL: http://localhost:8080"
    echo "   Login: admin / admin (für Admin-Tasks)"
    echo "   Login: claude / password (für Claude-Tasks)"
}

# Task-Status aktualisieren
update_task_status() {
    local task_id="$1"
    local column_id="$2"
    local description="$3"
    
    sqlite3 "$PM_DB" "UPDATE tasks SET column_id=$column_id WHERE id=$task_id;"
    echo "✅ Task $task_id Status aktualisiert → Spalte $column_id"
    
    if [ -n "$description" ]; then
        sqlite3 "$PM_DB" "INSERT INTO comments (task_id, user_id, comment, date_creation) VALUES ($task_id, $CLAUDE_USER_ID, '$description', $(date +%s));"
        echo "💬 Kommentar hinzugefügt: $description"
    fi
}

# Tasks anzeigen
show_tasks() {
    local project_id="$1"
    
    echo "📋 Tasks für Projekt $project_id:"
    sqlite3 "$PM_DB" "
        SELECT 
            t.id,
            t.title,
            u.username as owner,
            c.title as status,
            t.priority
        FROM tasks t
        LEFT JOIN users u ON t.owner_id = u.id
        LEFT JOIN columns c ON t.column_id = c.id
        WHERE t.project_id = $project_id
        ORDER BY t.priority DESC, t.position;
    " | while IFS='|' read -r id title owner status priority; do
        echo "  [$id] $title (Owner: $owner, Status: $status, Priority: $priority)"
    done
}

# PM-System Status
show_pm_status() {
    echo "🔍 PM-System Status:"
    echo "  Database: $PM_DB"
    echo "  Users: $(sqlite3 "$PM_DB" "SELECT COUNT(*) FROM users;")"
    echo "  Projects: $(sqlite3 "$PM_DB" "SELECT COUNT(*) FROM projects;")"
    echo "  Tasks: $(sqlite3 "$PM_DB" "SELECT COUNT(*) FROM tasks;")"
    echo ""
}

# Hauptprogramm
case "${1:-help}" in
    "sync")
        sync_simplyKI_tasks
        ;;
    "status")
        show_pm_status
        ;;
    "tasks")
        show_tasks "${2:-1}"
        ;;
    "update")
        update_task_status "$2" "$3" "$4"
        ;;
    "help")
        echo "PM-System API Client für SimplyKI"
        echo ""
        echo "Commands:"
        echo "  sync              - SimplyKI-Tasks mit PM-System synchronisieren"
        echo "  status            - PM-System Status anzeigen"
        echo "  tasks [project]   - Tasks für Projekt anzeigen"
        echo "  update <id> <col> [comment] - Task-Status aktualisieren"
        echo "  help              - Diese Hilfe"
        echo ""
        echo "Beispiele:"
        echo "  $0 sync"
        echo "  $0 tasks 1"
        echo "  $0 update 5 3 'Task abgeschlossen'"
        ;;
    *)
        echo "🔗 PM-System API Client"
        echo "Verwende '$0 help' für alle Kommandos"
        ;;
esac