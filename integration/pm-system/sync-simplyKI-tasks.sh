#!/bin/bash
# SimplyKI Task Synchronization mit PM-System

PROJECT_JSON="/home/aicollab/ai-collab/integration/pm-system/data-export/simplyKI_project_plan.json"
PM_DB="/home/aicollab/ai-collab/ai-collab-pm/data/db.sqlite"

echo "🔄 Synchronisiere SimplyKI-Tasks mit PM-System..."

# Claude User ID aus PM-System abrufen
CLAUDE_USER_ID=$(sqlite3 "$PM_DB" "SELECT id FROM users WHERE username='claude';" 2>/dev/null || echo "2")
STLAS_USER_ID=$(sqlite3 "$PM_DB" "SELECT id FROM users WHERE username='admin';" 2>/dev/null || echo "1")

echo "👤 Claude User ID: $CLAUDE_USER_ID"
echo "👤 stlas User ID: $STLAS_USER_ID"

# SimplyKI Projekt erstellen/finden
PROJECT_NAME="SimplyKI Meta-Framework"
PROJECT_ID=$(sqlite3 "$PM_DB" "SELECT id FROM projects WHERE name='$PROJECT_NAME';" 2>/dev/null)

if [ -z "$PROJECT_ID" ]; then
    echo "📝 Erstelle neues Projekt: $PROJECT_NAME"
    sqlite3 "$PM_DB" "INSERT INTO projects (name, is_active, description, owner_id) VALUES ('$PROJECT_NAME', 1, 'Meta-Framework für KI-Development-Tools', $STLAS_USER_ID);"
    PROJECT_ID=$(sqlite3 "$PM_DB" "SELECT last_insert_rowid();")
    echo "✅ Projekt erstellt mit ID: $PROJECT_ID"
else
    echo "✅ Projekt gefunden mit ID: $PROJECT_ID"
fi

# Kategorien erstellen
create_category() {
    local category_name="$1"
    local category_id=$(sqlite3 "$PM_DB" "SELECT id FROM project_has_categories WHERE name='$category_name' AND project_id=$PROJECT_ID;" 2>/dev/null)
    
    if [ -z "$category_id" ]; then
        sqlite3 "$PM_DB" "INSERT INTO project_has_categories (name, project_id) VALUES ('$category_name', $PROJECT_ID);"
        category_id=$(sqlite3 "$PM_DB" "SELECT last_insert_rowid();")
        echo "📂 Kategorie erstellt: $category_name (ID: $category_id)"
    fi
    echo "$category_id"
}

REPO_CATEGORY=$(create_category "Repository Setup")
PM_CATEGORY=$(create_category "PM Integration") 
CORE_CATEGORY=$(create_category "Core Infrastructure")
WEB_CATEGORY=$(create_category "Web Frontend")
DOC_CATEGORY=$(create_category "Documentation")

# Tasks aus JSON erstellen
create_task_from_json() {
    local phase_name="$1"
    local task_id="$2"
    local title="$3"
    local assigned_to="$4"
    local priority="$5"
    local description="$6"
    local estimated_hours="$7"
    
    # User ID bestimmen
    local user_id
    if [ "$assigned_to" = "Claude" ]; then
        user_id="$CLAUDE_USER_ID"
    else
        user_id="$STLAS_USER_ID"
    fi
    
    # Kategorie basierend auf Phase
    local category_id
    case "$phase_name" in
        "1_repository_setup") category_id="$REPO_CATEGORY" ;;
        "2_pm_integration") category_id="$PM_CATEGORY" ;;
        "3_core_infrastructure") category_id="$CORE_CATEGORY" ;;
        "4_web_frontend") category_id="$WEB_CATEGORY" ;;
        "5_documentation") category_id="$DOC_CATEGORY" ;;
        *) category_id="$REPO_CATEGORY" ;;
    esac
    
    # Priorität konvertieren
    local priority_num
    case "$priority" in
        "high") priority_num="3" ;;
        "medium") priority_num="2" ;;
        "low") priority_num="1" ;;
        *) priority_num="2" ;;
    esac
    
    # Prüfen ob Task bereits existiert
    local existing_task=$(sqlite3 "$PM_DB" "SELECT id FROM tasks WHERE title='$title' AND project_id=$PROJECT_ID;" 2>/dev/null)
    
    if [ -z "$existing_task" ]; then
        # Task erstellen
        sqlite3 "$PM_DB" "INSERT INTO tasks (title, description, project_id, owner_id, category_id, column_id, priority, time_estimated) VALUES ('$title', '$description', $PROJECT_ID, $user_id, $category_id, 1, $priority_num, $estimated_hours);"
        local new_task_id=$(sqlite3 "$PM_DB" "SELECT last_insert_rowid();")
        echo "✅ Task erstellt: $title (ID: $new_task_id, User: $assigned_to)"
    else
        echo "⚪ Task existiert bereits: $title"
    fi
}

# JSON parsen und Tasks erstellen
if [ -f "$PROJECT_JSON" ]; then
    echo "📖 Lade Tasks aus $PROJECT_JSON"
    
    # Vereinfachte Task-Erstellung (da wir komplexes JSON-Parsing vermeiden)
    echo "📝 Erstelle Repository Setup Tasks..."
    create_task_from_json "1_repository_setup" "repo_1" "Neues GitHub Repository stlas/SimplyKI erstellen" "Claude" "high" "GitHub Repository mit korrekten Settings, Lizenz und README erstellen" "1"
    create_task_from_json "1_repository_setup" "repo_2" "Basis-Verzeichnisstruktur aufbauen" "Claude" "high" "Ordnerstruktur: web/, core/, tools/, docs/ mit entsprechenden README-Dateien" "2"
    create_task_from_json "1_repository_setup" "repo_3" "ai-collab als Git-Submodul einbinden" "Claude" "medium" "ai-collab Repository als Submodul unter tools/ integrieren" "1"
    create_task_from_json "1_repository_setup" "repo_4" "Repository-Namen und URLs finalisieren" "stlas" "high" "Endgültige Repository-Namen, Branch-Strategien und URL-Struktur festlegen" "0.5"
    
    echo "📝 Erstelle PM Integration Tasks..."
    create_task_from_json "2_pm_integration" "pm_1" "Claude-User im PM-System anlegen" "Claude" "high" "Benutzer Claude im Kanboard-System anlegen für Task-Zuweisungen" "0.5"
    create_task_from_json "2_pm_integration" "pm_2" "Alle Tasks ins PM-System exportieren" "Claude" "high" "Automatischen Export aller SimplyKI-Tasks ins PM-System implementieren" "1"
    create_task_from_json "2_pm_integration" "pm_3" "PM-System für Multi-Repository konfigurieren" "stlas" "medium" "Kanboard-Setup für mehrere Repositories und Cross-Projekt-Tasks" "2"
    
    echo "📝 Erstelle Core Infrastructure Tasks..."
    create_task_from_json "3_core_infrastructure" "core_1" "Zentrale Konfiguration (config/, auth/)" "Claude" "high" "Einheitliches Config-System für alle SimplyKI-Tools entwickeln" "3"
    create_task_from_json "3_core_infrastructure" "core_2" "Plugin-System-Architektur entwerfen" "Claude" "high" "Modulares Plugin-System für einfache Integration neuer KI-Tools" "4"
    create_task_from_json "3_core_infrastructure" "core_3" "API-Struktur für Tool-Integration definieren" "Claude" "medium" "REST-API für Kommunikation zwischen Tools und Web-Frontend" "3"
    
    echo "📝 Erstelle Web Frontend Tasks..."
    create_task_from_json "4_web_frontend" "web_1" "Web-Dashboard Grundstruktur" "Claude" "medium" "Responsive Web-Interface als zentrale Anlaufstelle für alle Tools" "6"
    create_task_from_json "4_web_frontend" "web_2" "Tool-Integration-Framework" "Claude" "medium" "Framework zur einfachen Integration neuer Tools ins Web-Dashboard" "4"
    create_task_from_json "4_web_frontend" "web_3" "Landing-Page Konzept für SimplyKI" "stlas" "low" "Marketing-orientierte Landing-Page mit Tool-Übersicht und Features" "3"
    
    echo "📝 Erstelle Documentation Tasks..."
    create_task_from_json "5_documentation" "doc_1" "SimplyKI Meta-Framework README schreiben" "Claude" "high" "Umfassende Dokumentation des Meta-Framework-Konzepts" "2"
    create_task_from_json "5_documentation" "doc_2" "Cross-Repository Development-Workflow dokumentieren" "Claude" "medium" "Workflow für Entwicklung über mehrere Repositories hinweg" "2"
    create_task_from_json "5_documentation" "doc_3" "Community-Guidelines erstellen" "stlas" "low" "Richtlinien für Contributors und Community-Mitglieder" "2"
    
else
    echo "❌ JSON-Datei nicht gefunden: $PROJECT_JSON"
    exit 1
fi

echo ""
echo "🎯 SimplyKI Task-Synchronisation abgeschlossen!"
echo "📊 Projekt-ID: $PROJECT_ID"
echo "👥 User-IDs: Claude=$CLAUDE_USER_ID, stlas=$STLAS_USER_ID"
echo ""
echo "🌐 PM-System öffnen: http://localhost:8080"
echo "   Login: claude / password (für Claude-Tasks)"
echo "   Login: admin / admin (für stlas-Tasks)"