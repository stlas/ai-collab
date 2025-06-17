#!/bin/bash
# FILE: ./core/src/ai-collab.sh

# ai-collab.sh - AI Development Collaboration Assistant
# Intelligenter Präprozessor für kostenoptimierte KI-Entwicklung

VERSION="2.0.0"
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
CORE_DIR="$PROJECT_ROOT/core"
LOCAL_DIR="$PROJECT_ROOT/local"
PROJECTS_DIR="$PROJECT_ROOT/projects"

# Konfigurationsdateien
CONFIG_DIR="$LOCAL_DIR/config"
DEV_DIR="$LOCAL_DIR/development"
TEMP_DIR="$LOCAL_DIR/temp"

# Initialisierung der lokalen Struktur
init_local_structure() {
    echo -e "${BLUE}=== INITIALISIERE AI-COLLAB STRUKTUR ===${NC}"
    
    # Lokale Verzeichnisse erstellen
    mkdir -p "$CONFIG_DIR" "$DEV_DIR"/{protocols,snapshots,testing} "$TEMP_DIR"
    
    # Standard-Konfiguration erstellen falls nicht vorhanden
    if [ ! -f "$CONFIG_DIR/settings.json" ]; then
        cat > "$CONFIG_DIR/settings.json" << 'EOF'
{
    "default_model": "claude-3.5-sonnet",
    "cost_budget": {
        "daily": 5.00,
        "monthly": 100.00,
        "warning_threshold": 0.8
    },
    "optimization": {
        "auto_model_selection": true,
        "template_reuse": true,
        "prompt_caching": true,
        "batch_processing": true
    },
    "development": {
        "auto_backup": true,
        "session_persistence": true,
        "protocol_logging": true
    },
    "languages": ["de", "en"]
}
EOF
        echo -e "${GREEN}✅ Standard-Konfiguration erstellt${NC}"
    fi
    
    # .env Template erstellen
    if [ ! -f "$CONFIG_DIR/.env.template" ]; then
        cat > "$CONFIG_DIR/.env.template" << 'EOF'
# AI-Collab Umgebungsvariablen
# Kopiere diese Datei zu .env und fülle die Werte aus

# Anthropic API Konfiguration
ANTHROPIC_API_KEY=your_api_key_here
ANTHROPIC_MODEL=claude-3.5-sonnet

# Kostenüberwachung
COST_BUDGET_DAILY=5.00
COST_BUDGET_MONTHLY=100.00
COST_WARNING_THRESHOLD=0.8

# Entwicklungseinstellungen
DEBUG_MODE=false
SESSION_PERSISTENCE=true
AUTO_BACKUP=true

# Projekt-spezifische Einstellungen
DEFAULT_PROJECT=
PROJECT_CONFIG_PATH=
EOF
        echo -e "${GREEN}✅ .env Template erstellt${NC}"
    fi
    
    echo -e "${GREEN}✅ Lokale Struktur initialisiert${NC}"
}

# Laden der Konfiguration
load_config() {
    local config_file="$CONFIG_DIR/settings.json"
    if [ -f "$config_file" ]; then
        # Konfiguration mit jq laden
        DEFAULT_MODEL=$(jq -r '.default_model // "claude-3.5-sonnet"' "$config_file" 2>/dev/null)
        COST_BUDGET_DAILY=$(jq -r '.cost_budget.daily // 5.00' "$config_file" 2>/dev/null)
        AUTO_MODEL_SELECTION=$(jq -r '.optimization.auto_model_selection // true' "$config_file" 2>/dev/null)
    else
        # Fallback-Werte
        DEFAULT_MODEL="claude-3.5-sonnet"
        COST_BUDGET_DAILY="5.00"
        AUTO_MODEL_SELECTION="true"
    fi
    
    # .env laden falls vorhanden
    if [ -f "$CONFIG_DIR/.env" ]; then
        source "$CONFIG_DIR/.env"
    fi
}

# Intelligente Modellauswahl basierend auf Aufgabentyp
select_optimal_model() {
    local task_type="$1"
    local complexity="$2"
    local budget_remaining="$3"
    
    case "$task_type" in
        "simple_fix"|"template"|"documentation")
            echo "claude-3.5-haiku"
            ;;
        "code_review"|"feature_development"|"debugging")
            if [ "$complexity" = "high" ] && [ "$(echo "$budget_remaining > 2.0" | bc -l)" = "1" ]; then
                echo "claude-3.5-sonnet"
            else
                echo "claude-3.5-haiku"
            fi
            ;;
        "architecture"|"complex_analysis"|"critical_decision")
            if [ "$(echo "$budget_remaining > 10.0" | bc -l)" = "1" ]; then
                echo "claude-4-opus"
            else
                echo "claude-3.5-sonnet"
            fi
            ;;
        *)
            echo "$DEFAULT_MODEL"
            ;;
    esac
}

# Kosten-Tracking
track_costs() {
    local model="$1"
    local input_tokens="$2"
    local output_tokens="$3"
    
    local cost_file="$DEV_DIR/cost_tracking.json"
    local date=$(date +"%Y-%m-%d")
    
    # Kosten berechnen (vereinfacht)
    local input_cost=0
    local output_cost=0
    
    case "$model" in
        "claude-3.5-haiku")
            input_cost=$(echo "$input_tokens * 0.8 / 1000000" | bc -l)
            output_cost=$(echo "$output_tokens * 4.0 / 1000000" | bc -l)
            ;;
        "claude-3.5-sonnet")
            input_cost=$(echo "$input_tokens * 3.0 / 1000000" | bc -l)
            output_cost=$(echo "$output_tokens * 15.0 / 1000000" | bc -l)
            ;;
        "claude-4-opus")
            input_cost=$(echo "$input_tokens * 15.0 / 1000000" | bc -l)
            output_cost=$(echo "$output_tokens * 75.0 / 1000000" | bc -l)
            ;;
    esac
    
    local total_cost=$(echo "$input_cost + $output_cost" | bc -l)
    
    # Kosten protokollieren
    if [ ! -f "$cost_file" ]; then
        echo '{}' > "$cost_file"
    fi
    
    jq --arg date "$date" \
       --arg model "$model" \
       --arg cost "$total_cost" \
       '.[$date] += [{"model": $model, "cost": ($cost | tonumber), "timestamp": now}]' \
       "$cost_file" > "${cost_file}.tmp" && mv "${cost_file}.tmp" "$cost_file"
    
    echo "$total_cost"
}

# Session-Management
start_session() {
    echo -e "${CYAN}🤖 Starte AI-Collab Session v$VERSION...${NC}"
    
    # Auto-Initialisierung falls nötig
    if [ ! -f "$CONFIG_DIR/settings.json" ]; then
        echo -e "${YELLOW}⚠️  Erste Nutzung erkannt - initialisiere System...${NC}"
        init_local_structure
    fi
    
    # Konfiguration laden
    load_config
    
    # Session-ID generieren
    local session_id="session_$(date +%Y%m%d_%H%M%S)"
    local session_file="$DEV_DIR/protocols/$session_id.json"
    
    # Session initialisieren
    jq -n \
        --arg id "$session_id" \
        --arg start "$(date -Iseconds)" \
        --arg model "$DEFAULT_MODEL" \
        '{
            session_id: $id,
            start_time: $start,
            default_model: $model,
            total_cost: 0,
            operations: [],
            context: {}
        }' > "$session_file"
    
    echo "$session_id" > "$TEMP_DIR/current_session"
    
    echo -e "${GREEN}✅ Session $session_id gestartet${NC}"
    echo -e "${BLUE}💡 Verwende 'ai-collab.sh optimize <prompt>' für kostenoptimierte Entwicklung${NC}"
    
    # Letzte Session wiederherstellen falls vorhanden
    if [ -d "$SESSIONS_DIR" ] && [ "$(ls -A "$SESSIONS_DIR" 2>/dev/null)" ]; then
        local last_session=$(find "$SESSIONS_DIR" -name "*.json" -type f | sort -r | head -1 | basename | sed 's/.json$//')
        if [ -n "$last_session" ] && [ "$last_session" != "$session_id" ]; then
            echo -e "${CYAN}🔄 Letzte Session gefunden: $last_session${NC}"
            echo -e "${CYAN}💡 Zum Wiederherstellen: 'session-manager.sh restore $last_session'${NC}"
        fi
    fi
}

# Prompt-Optimierung mit intelligenter Modellwahl
optimize_prompt() {
    local prompt="$1"
    local task_type="$2"
    local complexity="${3:-medium}"
    
    if [ -z "$prompt" ]; then
        echo -e "${RED}❌ Prompt erforderlich${NC}"
        echo "Usage: $0 optimize \"<prompt>\" [task_type] [complexity]"
        return 1
    fi
    
    load_config
    
    # Tagesbudget prüfen
    local budget_remaining=$(get_remaining_budget)
    
    # Optimales Modell auswählen
    local selected_model
    if [ "$AUTO_MODEL_SELECTION" = "true" ]; then
        selected_model=$(select_optimal_model "$task_type" "$complexity" "$budget_remaining")
    else
        selected_model="$DEFAULT_MODEL"
    fi
    
    echo -e "${CYAN}🎯 Optimiere Prompt mit $selected_model...${NC}"
    echo -e "${YELLOW}💰 Verbleibendes Tagesbudget: \$${budget_remaining}${NC}"
    
    # Template-basierte Optimierung
    local optimized_prompt=$(optimize_with_templates "$prompt" "$task_type")
    
    echo -e "${GREEN}✅ Prompt optimiert für $selected_model${NC}"
    echo -e "${BLUE}📝 Optimierter Prompt:${NC}"
    echo "\"$optimized_prompt\""
    echo ""
    echo -e "${CYAN}💡 Geschätzte Kosten: \$$(estimate_cost "$optimized_prompt" "$selected_model")${NC}"
}

# Template-basierte Prompt-Optimierung
optimize_with_templates() {
    local prompt="$1"
    local task_type="$2"
    
    # Basis-Templates laden
    local template_dir="$CORE_DIR/templates"
    local template_file="$template_dir/${task_type:-general}.template"
    
    if [ -f "$template_file" ]; then
        # Template anwenden
        sed "s/\${PROMPT}/$prompt/g" "$template_file"
    else
        # Fallback: Generische Optimierung
        echo "Optimiere folgenden Code/Task: $prompt. 
        Verwende beste Praktiken, sei spezifisch und kosteneffizient.
        Fokussiere auf das Wesentliche."
    fi
}

# Kostenabschätzung
estimate_cost() {
    local prompt="$1"
    local model="$2"
    
    # Vereinfachte Token-Schätzung (4 Zeichen = 1 Token)
    local estimated_input_tokens=$((${#prompt} / 4))
    local estimated_output_tokens=$((estimated_input_tokens / 2))
    
    case "$model" in
        "claude-3.5-haiku")
            echo "$(echo "scale=4; ($estimated_input_tokens * 0.8 + $estimated_output_tokens * 4.0) / 1000000" | bc -l)"
            ;;
        "claude-3.5-sonnet")
            echo "$(echo "scale=4; ($estimated_input_tokens * 3.0 + $estimated_output_tokens * 15.0) / 1000000" | bc -l)"
            ;;
        "claude-4-opus")
            echo "$(echo "scale=4; ($estimated_input_tokens * 15.0 + $estimated_output_tokens * 75.0) / 1000000" | bc -l)"
            ;;
        *)
            echo "0.01"
            ;;
    esac
}

# Verbleibendes Budget abrufen
get_remaining_budget() {
    local cost_file="$DEV_DIR/cost_tracking.json"
    local today=$(date +"%Y-%m-%d")
    
    if [ -f "$cost_file" ]; then
        local today_cost=$(jq -r --arg date "$today" '.[$date] // [] | map(.cost) | add // 0' "$cost_file" 2>/dev/null || echo "0")
        echo "$(echo "$COST_BUDGET_DAILY - $today_cost" | bc -l)"
    else
        echo "$COST_BUDGET_DAILY"
    fi
}

# Projekt hinzufügen
add_project() {
    local project_path="$1"
    local project_name="$2"
    
    if [ -z "$project_path" ]; then
        echo "Usage: $0 add-project <project_path> [project_name]"
        return 1
    fi
    
    if [ ! -d "$project_path" ]; then
        echo -e "${RED}❌ Projekt-Pfad existiert nicht: $project_path${NC}"
        return 1
    fi
    
    # Projekt-Name ableiten falls nicht angegeben
    if [ -z "$project_name" ]; then
        project_name=$(basename "$project_path")
    fi
    
    local link_path="$PROJECTS_DIR/$project_name"
    
    # Symlink erstellen
    ln -sf "$(realpath "$project_path")" "$link_path"
    
    echo -e "${GREEN}✅ Projekt '$project_name' hinzugefügt${NC}"
    echo -e "${CYAN}🔗 Verlinkt: $link_path -> $project_path${NC}"
}

# Status anzeigen
show_status() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                    AI-COLLAB STATUS                          ║${NC}"
    echo -e "${PURPLE}║          AI Development Collaboration Assistant              ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    load_config
    
    # System-Status
    echo -e "${CYAN}=== SYSTEM-STATUS ===${NC}"
    echo -e "${GREEN}✅ Version: $VERSION${NC}"
    echo -e "${GREEN}✅ Konfiguration: $([ -f "$CONFIG_DIR/settings.json" ] && echo "OK" || echo "MISSING")${NC}"
    echo -e "${GREEN}✅ API-Konfiguration: $([ -f "$CONFIG_DIR/.env" ] && echo "OK" || echo "MISSING")${NC}"
    
    # Budget-Status
    echo ""
    echo -e "${CYAN}=== BUDGET-STATUS ===${NC}"
    local remaining_budget=$(get_remaining_budget)
    echo -e "${YELLOW}💰 Tagesbudget: \$${COST_BUDGET_DAILY}${NC}"
    echo -e "${YELLOW}💸 Verbleibend: \$${remaining_budget}${NC}"
    
    # Aktuelle Session
    echo ""
    echo -e "${CYAN}=== SESSION-STATUS ===${NC}"
    if [ -f "$TEMP_DIR/current_session" ]; then
        local session_id=$(cat "$TEMP_DIR/current_session")
        echo -e "${GREEN}🟢 Aktive Session: $session_id${NC}"
    else
        echo -e "${YELLOW}⚪ Keine aktive Session${NC}"
    fi
    
    # Projekte
    echo ""
    echo -e "${CYAN}=== PROJEKTE ===${NC}"
    if [ -d "$PROJECTS_DIR" ] && [ "$(ls -A "$PROJECTS_DIR" 2>/dev/null)" ]; then
        find "$PROJECTS_DIR" -type l | while read -r link; do
            local name=$(basename "$link")
            local target=$(readlink "$link")
            echo -e "${GREEN}📂 $name -> $target${NC}"
        done
    else
        echo -e "${YELLOW}📂 Keine Projekte verlinkt${NC}"
    fi
}

# Template-System
create_template() {
    local template_name="$1"
    local template_type="$2"
    
    if [ -z "$template_name" ]; then
        echo "Usage: $0 create-template <name> [type]"
        return 1
    fi
    
    local template_dir="$CORE_DIR/templates"
    mkdir -p "$template_dir"
    
    local template_file="$template_dir/$template_name.template"
    
    case "$template_type" in
        "code_review")
            cat > "$template_file" << 'EOF'
Führe eine Code-Review für folgenden Code durch: ${PROMPT}

Fokussiere auf:
- Code-Qualität und Best Practices
- Potenzielle Bugs oder Sicherheitsprobleme
- Performance-Optimierungen
- Verbesserungsvorschläge

Halte die Antwort strukturiert und actionable.
EOF
            ;;
        "bug_fix")
            cat > "$template_file" << 'EOF'
Analysiere und behebe folgenden Bug: ${PROMPT}

Vorgehen:
1. Problem-Identifikation
2. Root-Cause-Analyse  
3. Lösungsvorschlag mit Code
4. Testing-Empfehlungen

Fokussiere auf eine saubere, testbare Lösung.
EOF
            ;;
        "feature")
            cat > "$template_file" << 'EOF'
Implementiere folgendes Feature: ${PROMPT}

Berücksichtige:
- Modular und erweiterbar
- Error-Handling
- Documentation
- Testing-Strategie

Liefere vollständigen, produktionsreifen Code.
EOF
            ;;
        *)
            cat > "$template_file" << 'EOF'
Bearbeite folgende Aufgabe: ${PROMPT}

Anforderungen:
- Präzise und effiziente Lösung
- Berücksichtigung von Best Practices
- Klare Dokumentation
- Wartbarer Code

Halte die Antwort fokussiert und umsetzbar.
EOF
            ;;
    esac
    
    echo -e "${GREEN}✅ Template '$template_name' erstellt${NC}"
    echo -e "${CYAN}📝 Datei: $template_file${NC}"
}

# GitHub-Integration
integrate_github() {
    local action="$1"
    shift
    
    # GitHub-Integration-Skript aufrufen
    local github_script="$CORE_DIR/src/github-integration.sh"
    if [ -f "$github_script" ]; then
        "$github_script" "$action" "$@"
    else
        echo -e "${RED}❌ GitHub-Integration nicht gefunden${NC}"
        return 1
    fi
}

# GitHub Setup Wizard
github_setup_wizard() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                  AI-COLLAB GITHUB SETUP                      ║${NC}"
    echo -e "${PURPLE}║              Vollautomatische Einrichtung                    ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${CYAN}🚀 Dieser Wizard richtet GitHub-Integration vollautomatisch ein:${NC}"
    echo -e "${GREEN}✅ GitHub CLI Installation${NC}"
    echo -e "${GREEN}✅ Authentication (Browser oder Token)${NC}"
    echo -e "${GREEN}✅ Git-Konfiguration${NC}"
    echo -e "${GREEN}✅ Repository-Verbindung${NC}"
    echo ""
    
    echo -e "${YELLOW}Möchtest du fortfahren? (y/n): ${NC}"
    read -r confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}❌ Setup abgebrochen${NC}"
        return 0
    fi
    
    # GitHub CLI Setup starten
    integrate_github "init"
}

# Auto-Release mit Session-Daten
auto_release() {
    local version="$1"
    local title="$2"
    
    if [ -z "$version" ]; then
        echo -e "${RED}❌ Version erforderlich${NC}"
        echo "Usage: $0 release <version> [title]"
        return 1
    fi
    
    if [ -z "$title" ]; then
        title="$version: AI-assisted development update"
    fi
    
    echo -e "${BLUE}=== AI-COLLAB AUTO-RELEASE ===${NC}"
    
    # Session-Statistiken für Release-Notes
    local session_stats=""
    if [ -f "$DEV_DIR/usage_analytics.json" ]; then
        local total_operations=$(jq -r '.total_operations // 0' "$DEV_DIR/usage_analytics.json")
        local total_cost=$(jq -r '.total_cost // 0' "$DEV_DIR/usage_analytics.json")
        local template_usage=$(jq -r '.optimization_stats.template_reuse // 0' "$DEV_DIR/usage_analytics.json")
        
        session_stats="## 📊 Development Stats

- **Operations**: $total_operations AI-assistierte Operationen
- **Kosten**: \$${total_cost} Gesamtkosten
- **Template-Nutzung**: $template_usage mal wiederverwendet
- **Entwickelt mit**: ai-collab Session-Management"
    fi
    
    # Auto-Commit aktueller Änderungen
    integrate_github "commit" "$title" "true"
    
    # Release erstellen
    integrate_github "release" "$version" "$title" "$session_stats"
}

# Hauptprogramm
case "${1:-help}" in
    "init")
        init_local_structure
        ;;
    "start")
        start_session
        ;;
    "optimize")
        optimize_prompt "$2" "$3" "$4"
        ;;
    "status")
        show_status
        ;;
    "add-project")
        add_project "$2" "$3"
        ;;
    "create-template")
        create_template "$2" "$3"
        ;;
    "github")
        integrate_github "$2" "$3" "$4" "$5" "$6"
        ;;
    "github-setup")
        github_setup_wizard
        ;;
    "release")
        auto_release "$2" "$3"
        ;;
    "config")
        echo -e "${CYAN}Konfigurationsdatei öffnen:${NC}"
        echo "$CONFIG_DIR/settings.json"
        ;;
    "help")
        echo "ai-collab - AI Development Collaboration Assistant v$VERSION"
        echo ""
        echo "Commands:"
        echo "  init                           - Initialisiere ai-collab Struktur"
        echo "  start                          - Neue AI-Session starten"
        echo "  optimize \"<prompt>\" [type] [complexity] - Prompt optimieren"
        echo "  status                         - Aktuellen Status anzeigen"
        echo "  add-project <path> [name]      - Projekt hinzufügen"
        echo "  create-template <name> [type]  - Neues Template erstellen"
        echo "  github <action> [args...]      - GitHub Integration"
        echo "  github-setup                   - GitHub Setup Wizard (Vollautomatisch)"
        echo "  release <version> [title]      - Auto-Release mit Session-Stats"
        echo "  config                         - Konfiguration anzeigen"
        echo "  help                           - Diese Hilfe"
        echo ""
        echo "Beispiele:"
        echo "  $0 init"
        echo "  $0 start"
        echo "  $0 optimize \"Fix login bug\" bug_fix high"
        echo "  $0 add-project /path/to/project MyProject"
        echo "  $0 create-template code-review code_review"
        echo "  $0 github-setup                   # Vollautomatisches GitHub Setup"
        echo "  $0 github commit \"New feature\"   # Auto-commit & push"
        echo "  $0 release v2.1.0 \"GitHub Integration\" # Auto-release"
        ;;
    *)
        echo -e "${BLUE}ai-collab - AI Development Collaboration Assistant v$VERSION${NC}"
        echo -e "${YELLOW}Verwende '$0 help' für alle Kommandos oder '$0 start' zum Starten${NC}"
        ;;
esac