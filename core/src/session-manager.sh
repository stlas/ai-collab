#!/bin/bash
# FILE: ./core/src/session-manager.sh

# session-manager.sh - Erweiterte Session-Verwaltung für ai-collab
# Persistente Kontextverwaltung mit Parameterbeständigkeit

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
LOCAL_DIR="$PROJECT_ROOT/local"
DEV_DIR="$LOCAL_DIR/development"
SESSIONS_DIR="$DEV_DIR"
SNAPSHOTS_DIR="$DEV_DIR/snapshots"

# Session-Dateien
CURRENT_SESSION_FILE="$LOCAL_DIR/temp/current_session"
CONTEXT_STATE_FILE="$LOCAL_DIR/temp/context_state.json"
PARAMETER_CACHE_FILE="$LOCAL_DIR/temp/parameter_cache.json"

# Session initialisieren
init_session() {
    local session_name="$1"
    local project_context="$2"
    
    if [ -z "$session_name" ]; then
        session_name="session_$(date +%Y%m%d_%H%M%S)"
    fi
    
    echo -e "${BLUE}=== SESSION INITIALISIERUNG ===${NC}"
    
    # Session-Verzeichnisse erstellen
    mkdir -p "$SESSIONS_DIR" "$SNAPSHOTS_DIR" "$LOCAL_DIR/temp"
    
    local session_file="$SESSIONS_DIR/$session_name.json"
    
    # Session-Daten initialisieren
    jq -n \
        --arg session_id "$session_name" \
        --arg echo "URL:"_time "$(date -Iseconds)" \
        --arg project "$project_context" \
        '{
            session_id: $session_id,
            echo "URL:"_time: $start_time,
            project_context: $project,
            status: "active",
            parameters: {
                model: "claude-3.5-sonnet",
                optimization_level: "high",
                cost_budget: 5.00,
                language: "de",
                auto_model_selection: true,
                template_usage: true,
                prompt_caching: true
            },
            context: {
                current_task: "",
                recent_operations: [],
                knowledge_base: {},
                custom_rules: []
            },
            statistics: {
                operations_count: 0,
                total_cost: 0.0,
                tokens_used: 0,
                templates_used: 0,
                models_used: {}
            },
            snapshots: []
        }' > "$session_file"
    
    # Als aktuelle Session setzen
    echo "$session_name" > "$CURRENT_SESSION_FILE"
    
    # Parameter-Cache initialisieren
    jq '.parameters' "$session_file" > "$PARAMETER_CACHE_FILE"
    
    # Kontext-State initialisieren
    jq '.context' "$session_file" > "$CONTEXT_STATE_FILE"
    
    echo -e "${GREEN}✅ Session '$session_name' initialisiert${NC}"
    echo -e "${CYAN}📝 Session-Datei: $session_file${NC}"
    
    return 0
}

# Session wiederherstellen
restore_session() {
    local session_name="$1"
    
    if [ -z "$session_name" ]; then
        # Letzte Session finden
        session_name=$(find "$SESSIONS_DIR" -name "*.json" -type f | sort -r | head -1 | basename | sed 's/.json$//')
    fi
    
    local session_file="$SESSIONS_DIR/$session_name.json"
    
    if [ ! -f "$session_file" ]; then
        echo -e "${RED}❌ Session '$session_name' nicht gefunden${NC}"
        return 1
    fi
    
    echo -e "${BLUE}=== SESSION WIEDERHERSTELLUNG ===${NC}"
    
    # Session als aktuelle setzen
    echo "$session_name" > "$CURRENT_SESSION_FILE"
    
    # Parameter wiederherstellen
    jq '.parameters' "$session_file" > "$PARAMETER_CACHE_FILE"
    
    # Kontext wiederherstellen
    jq '.context' "$session_file" > "$CONTEXT_STATE_FILE"
    
    # Session-Info anzeigen
    local echo "URL:"_time=$(jq -r '.start_time' "$session_file")
    local project=$(jq -r '.project_context // "Unbekannt"' "$session_file")
    local operations=$(jq -r '.statistics.operations_count' "$session_file")
    local total_cost=$(jq -r '.statistics.total_cost' "$session_file")
    
    echo -e "${GREEN}✅ Session '$session_name' wiederhergestellt${NC}"
    echo -e "${CYAN}📅 Geecho "URL:"et: $start_time${NC}"
    echo -e "${CYAN}📂 Projekt: $project${NC}"
    echo -e "${CYAN}🔢 Operationen: $operations${NC}"
    echo -e "${CYAN}💰 Gesamtkosten: \$${total_cost}${NC}"
    
    # Aktuelle Parameter anzeigen
    echo ""
    echo -e "${PURPLE}=== AKTUELLE PARAMETER ===${NC}"
    jq -r 'to_entries | .[] | "\(.key): \(.value)"' "$PARAMETER_CACHE_FILE" | sed 's/^/  /'
    
    return 0
}

# Parameter aktualisieren
update_parameters() {
    local param_name="$1"
    local param_value="$2"
    
    if [ -z "$param_name" ] || [ -z "$param_value" ]; then
        echo "Usage: update_parameters <parameter_name> <parameter_value>"
        return 1
    fi
    
    # Parameter in Cache aktualisieren
    jq --arg name "$param_name" --arg value "$param_value" \
        '.[$name] = $value' \
        "$PARAMETER_CACHE_FILE" > "${PARAMETER_CACHE_FILE}.tmp" && \
        mv "${PARAMETER_CACHE_FILE}.tmp" "$PARAMETER_CACHE_FILE"
    
    # Parameter in Session-Datei aktualisieren
    local session_name=$(get_current_session)
    if [ -n "$session_name" ]; then
        local session_file="$SESSIONS_DIR/$session_name.json"
        jq --arg name "$param_name" --arg value "$param_value" \
            '.parameters[$name] = $value' \
            "$session_file" > "${session_file}.tmp" && \
            mv "${session_file}.tmp" "$session_file"
    fi
    
    echo -e "${GREEN}✅ Parameter '$param_name' auf '$param_value' gesetzt${NC}"
}

# Aktuelle Session abrufen
get_current_session() {
    if [ -f "$CURRENT_SESSION_FILE" ]; then
        cat "$CURRENT_SESSION_FILE"
    else
        echo ""
    fi
}

# Parameter abrufen
get_parameter() {
    local param_name="$1"
    
    if [ -f "$PARAMETER_CACHE_FILE" ]; then
        jq -r --arg name "$param_name" '.[$name] // empty' "$PARAMETER_CACHE_FILE"
    fi
}

# Kontext aktualisieren
update_context() {
    local context_key="$1"
    local context_value="$2"
    
    if [ -z "$context_key" ]; then
        echo "Usage: update_context <key> <value>"
        return 1
    fi
    
    # Kontext in State-Datei aktualisieren
    jq --arg key "$context_key" --arg value "$context_value" \
        '.[$key] = $value' \
        "$CONTEXT_STATE_FILE" > "${CONTEXT_STATE_FILE}.tmp" && \
        mv "${CONTEXT_STATE_FILE}.tmp" "$CONTEXT_STATE_FILE"
    
    # Kontext in Session-Datei aktualisieren
    local session_name=$(get_current_session)
    if [ -n "$session_name" ]; then
        local session_file="$SESSIONS_DIR/$session_name.json"
        jq --arg key "$context_key" --arg value "$context_value" \
            '.context[$key] = $value' \
            "$session_file" > "${session_file}.tmp" && \
            mv "${session_file}.tmp" "$session_file"
    fi
    
    echo -e "${GREEN}✅ Kontext '$context_key' aktualisiert${NC}"
}

# Snapshot erstellen
create_snapshot() {
    local snapshot_name="$1"
    local description="$2"
    
    if [ -z "$snapshot_name" ]; then
        snapshot_name="snapshot_$(date +%Y%m%d_%H%M%S)"
    fi
    
    local session_name=$(get_current_session)
    if [ -z "$session_name" ]; then
        echo -e "${RED}❌ Keine aktive Session${NC}"
        return 1
    fi
    
    echo -e "${BLUE}=== SNAPSHOT ERSTELLEN ===${NC}"
    
    local snapshot_file="$SNAPSHOTS_DIR/$snapshot_name.json"
    local session_file="$SESSIONS_DIR/$session_name.json"
    
    # Snapshot erstellen
    jq -n \
        --arg name "$snapshot_name" \
        --arg timestamp "$(date -Iseconds)" \
        --arg description "$description" \
        --arg session "$session_name" \
        --slurpfile session_data "$session_file" \
        --slurpfile context_state "$CONTEXT_STATE_FILE" \
        --slurpfile parameter_cache "$PARAMETER_CACHE_FILE" \
        '{
            snapshot_name: $name,
            timestamp: $timestamp,
            description: $description,
            session_id: $session,
            session_data: $session_data[0],
            context_state: $context_state[0],
            parameter_cache: $parameter_cache[0]
        }' > "$snapshot_file"
    
    # Snapshot in Session registrieren
    jq --arg snapshot "$snapshot_name" \
        '.snapshots += [$snapshot]' \
        "$session_file" > "${session_file}.tmp" && \
        mv "${session_file}.tmp" "$session_file"
    
    echo -e "${GREEN}✅ Snapshot '$snapshot_name' erstellt${NC}"
    echo -e "${CYAN}📸 Datei: $snapshot_file${NC}"
}

# Snapshot wiederherstellen
restore_snapshot() {
    local snapshot_name="$1"
    
    if [ -z "$snapshot_name" ]; then
        echo "Usage: restore_snapshot <snapshot_name>"
        return 1
    fi
    
    local snapshot_file="$SNAPSHOTS_DIR/$snapshot_name.json"
    
    if [ ! -f "$snapshot_file" ]; then
        echo -e "${RED}❌ Snapshot '$snapshot_name' nicht gefunden${NC}"
        return 1
    fi
    
    echo -e "${BLUE}=== SNAPSHOT WIEDERHERSTELLEN ===${NC}"
    
    # Parameter wiederherstellen
    jq '.parameter_cache' "$snapshot_file" > "$PARAMETER_CACHE_FILE"
    
    # Kontext wiederherstellen
    jq '.context_state' "$snapshot_file" > "$CONTEXT_STATE_FILE"
    
    # Session-Info anzeigen
    local description=$(jq -r '.description // "Keine Beschreibung"' "$snapshot_file")
    local timestamp=$(jq -r '.timestamp' "$snapshot_file")
    
    echo -e "${GREEN}✅ Snapshot '$snapshot_name' wiederhergestellt${NC}"
    echo -e "${CYAN}📅 Erstellt: $timestamp${NC}"
    echo -e "${CYAN}📝 Beschreibung: $description${NC}"
}

# Session-Statistiken aktualisieren
update_statistics() {
    local operation_type="$1"
    local cost="$2"
    local tokens="$3"
    local model="$4"
    
    local session_name=$(get_current_session)
    if [ -z "$session_name" ]; then
        return 1
    fi
    
    local session_file="$SESSIONS_DIR/$session_name.json"
    
    # Statistiken aktualisieren
    jq --arg op_type "$operation_type" \
       --arg cost "$cost" \
       --arg tokens "$tokens" \
       --arg model "$model" \
       '.statistics.operations_count += 1 |
        .statistics.total_cost += ($cost | tonumber) |
        .statistics.tokens_used += ($tokens | tonumber) |
        .statistics.models_used[$model] = (.statistics.models_used[$model] // 0) + 1 |
        .context.recent_operations += [{
            type: $op_type,
            timestamp: now,
            cost: ($cost | tonumber),
            tokens: ($tokens | tonumber),
            model: $model
        }] |
        .context.recent_operations = .context.recent_operations[-10:]' \
       "$session_file" > "${session_file}.tmp" && \
       mv "${session_file}.tmp" "$session_file"
}

# Session beenden
end_session() {
    local session_name=$(get_current_session)
    
    if [ -z "$session_name" ]; then
        echo -e "${YELLOW}⚠️  Keine aktive Session${NC}"
        return 0
    fi
    
    echo -e "${BLUE}=== SESSION BEENDEN ===${NC}"
    
    local session_file="$SESSIONS_DIR/$session_name.json"
    
    # Session als beendet markieren
    jq --arg end_time "$(date -Iseconds)" \
        '.status = "completed" | .end_time = $end_time' \
        "$session_file" > "${session_file}.tmp" && \
        mv "${session_file}.tmp" "$session_file"
    
    # Finaler Snapshot
    create_snapshot "final_${session_name}" "Automatischer Snapshot beim Session-Ende"
    
    # Temporäre Dateien löschen
    rm -f "$CURRENT_SESSION_FILE" "$CONTEXT_STATE_FILE" "$PARAMETER_CACHE_FILE"
    
    # Session-Zusammenfassung
    local operations=$(jq -r '.statistics.operations_count' "$session_file")
    local total_cost=$(jq -r '.statistics.total_cost' "$session_file")
    local duration=$(jq -r 'if .end_time and .echo "URL:"_time then (((.end_time | fromdateiso8601) - (.start_time | fromdateiso8601)) / 3600) else 0 end' "$session_file")
    
    echo -e "${GREEN}✅ Session '$session_name' beendet${NC}"
    echo -e "${CYAN}⏱️  Dauer: $(printf "%.1f" "$duration") Stunden${NC}"
    echo -e "${CYAN}🔢 Operationen: $operations${NC}"
    echo -e "${CYAN}💰 Gesamtkosten: \$${total_cost}${NC}"
}

# Session-Liste anzeigen
list_sessions() {
    echo -e "${CYAN}=== VERFÜGBARE SESSIONS ===${NC}"
    
    if [ ! -d "$SESSIONS_DIR" ] || [ -z "$(ls -A "$SESSIONS_DIR" 2>/dev/null)" ]; then
        echo -e "${YELLOW}Keine Sessions gefunden${NC}"
        return 0
    fi
    
    local current_session=$(get_current_session)
    
    echo -e "${BLUE}NAME                     STATUS   PROJEKT      OPS   STARTZEIT${NC}"
    echo -e "${BLUE}--------------------------------------------------------------------${NC}"
    
    find "$SESSIONS_DIR" -name "session_*.json" -type f | sort -r | while read -r session_file; do
        local session_name=$(basename "$session_file" .json)
        local status=$(jq -r '.status // "active"' "$session_file")
        local start_time=$(jq -r '.start_time' "$session_file")
        local project=$(jq -r '.context.project // "Unbekannt"' "$session_file")
        local operations=$(jq -r '.operations | length' "$session_file")
        
        local marker=""
        if [ "$session_name" = "$current_session" ]; then
            marker="🟢 "
        fi
        
        echo -e "${marker}${session_name} (${status}) - ${project} - ${operations} ops - ${start_time}"
    done
}

# Session-Details anzeigen
show_session_details() {
    local session_name="${1:-$(get_current_session)}"
    
    if [ -z "$session_name" ]; then
        echo -e "${RED}Fehler: Keine Session angegeben und keine aktive Session gefunden${NC}"
        return 1
    fi
    
    local session_file="$SESSIONS_DIR/${session_name}.json"
    
    if [ ! -f "$session_file" ]; then
        echo -e "${RED}Fehler: Session '$session_name' nicht gefunden${NC}"
        return 1
    fi
    
    echo -e "${CYAN}=== SESSION-DETAILS: $session_name ===${NC}"
    echo ""
    
    # Basis-Informationen
    echo -e "${BLUE}Basis-Informationen:${NC}"
    echo "  Session ID:    $(jq -r '.session_id' "$session_file")"
    echo "  Startzeit:     $(jq -r '.start_time' "$session_file")"
    echo "  Standard-Modell: $(jq -r '.default_model // "Nicht gesetzt"' "$session_file")"
    echo "  Gesamtkosten:  $(jq -r '.total_cost // 0' "$session_file")€"
    echo "  Status:        $(jq -r '.status // "active"' "$session_file")"
    echo ""
    
    # Kontext-Informationen
    echo -e "${BLUE}Kontext:${NC}"
    local context_keys=$(jq -r '.context | keys[]' "$session_file" 2>/dev/null)
    if [ -n "$context_keys" ]; then
        echo "$context_keys" | while read -r key; do
            local value=$(jq -r ".context.${key}" "$session_file")
            echo "  ${key}: ${value}"
        done
    else
        echo "  (Kein Kontext gespeichert)"
    fi
    echo ""
    
    # Operationen
    echo -e "${BLUE}Operationen ($(jq -r '.operations | length' "$session_file")):${NC}"
    local ops_count=$(jq -r '.operations | length' "$session_file")
    if [ "$ops_count" -gt 0 ]; then
        jq -r '.operations[] | "  [\(.timestamp)] \(.type): \(.description // "Keine Beschreibung")"' "$session_file"
    else
        echo "  (Keine Operationen aufgezeichnet)"
    fi
    echo ""
    
    # Rohdaten (optional)
    if [ "$2" = "--raw" ]; then
        echo -e "${BLUE}Rohdaten (JSON):${NC}"
        jq '.' "$session_file"
    fi
}

# Leere Sessions bereinigen
cleanup_sessions() {
    local force_cleanup=false
    if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
        force_cleanup=true
    fi
    
    if [ ! -d "$SESSIONS_DIR" ]; then
        echo -e "${YELLOW}Keine Sessions gefunden${NC}"
        return 0
    fi
    
    local empty_sessions=()
    local current_session=$(get_current_session)
    
    echo -e "${CYAN}=== SESSIONS ANALYSIEREN ===${NC}"
    
    # Leere Sessions identifizieren
    while IFS= read -r -d '' session_file; do
        local session_name=$(basename "$session_file" .json)
        local operations_count=$(jq -r '.operations | length' "$session_file")
        local context_keys=$(jq -r '.context | keys | length' "$session_file")
        local total_cost=$(jq -r '.total_cost // 0' "$session_file")
        
        # Session gilt als leer wenn: keine Operationen, kein Kontext, keine Kosten
        if [ "$operations_count" -eq 0 ] && [ "$context_keys" -eq 0 ] && [ "$total_cost" = "0" ]; then
            if [ "$session_name" = "$current_session" ]; then
                echo -e "${YELLOW}⚠️  $session_name (aktuelle Session, wird übersprungen)${NC}"
            else
                echo -e "${RED}🗑️  $session_name (leer)${NC}"
                empty_sessions+=("$session_file")
            fi
        else
            echo -e "${GREEN}✅ $session_name (enthält Daten)${NC}"
        fi
    done < <(find "$SESSIONS_DIR" -name "session_*.json" -type f -print0)
    
    if [ ${#empty_sessions[@]} -eq 0 ]; then
        echo -e "${GREEN}Keine leeren Sessions zum Bereinigen gefunden${NC}"
        return 0
    fi
    
    echo ""
    echo -e "${CYAN}Gefunden: ${#empty_sessions[@]} leere Session(s)${NC}"
    
    if [ "$force_cleanup" = false ]; then
        echo -e "${YELLOW}Wirklich löschen? (j/N):${NC}"
        read -r confirm
        if [[ ! "$confirm" =~ ^[Jj]$ ]]; then
            echo -e "${YELLOW}Abgebrochen${NC}"
            return 0
        fi
    fi
    
    # Leere Sessions löschen
    local deleted_count=0
    for session_file in "${empty_sessions[@]}"; do
        if rm "$session_file" 2>/dev/null; then
            local session_name=$(basename "$session_file" .json)
            echo -e "${GREEN}✅ Gelöscht: $session_name${NC}"
            deleted_count=$((deleted_count + 1))
        else
            local session_name=$(basename "$session_file" .json)
            echo -e "${RED}❌ Fehler beim Löschen: $session_name${NC}"
        fi
    done
    
    echo ""
    echo -e "${CYAN}Bereinigung abgeschlossen: $deleted_count Session(s) gelöscht${NC}"
}

# Hauptprogramm
case "${1:-help}" in
    "init")
        init_session "$2" "$3"
        ;;
    "restore")
        restore_session "$2"
        ;;
    "set"|"update")
        update_parameters "$2" "$3"
        ;;
    "get")
        get_parameter "$2"
        ;;
    "context")
        update_context "$2" "$3"
        ;;
    "snapshot")
        create_snapshot "$2" "$3"
        ;;
    "restore-snapshot")
        restore_snapshot "$2"
        ;;
    "end")
        end_session
        ;;
    "list")
        list_sessions
        ;;
    "show"|"details")
        show_session_details "$2" "$3"
        ;;
    "cleanup")
        cleanup_sessions "$2"
        ;;
    "current")
        get_current_session
        ;;
    "help")
        echo "Session Manager für ai-collab v$VERSION"
        echo ""
        echo "Commands:"
        echo "  init [name] [project]     - Neue Session initialisieren"
        echo "  restore [name]            - Session wiederherstellen"
        echo "  set <param> <value>       - Parameter setzen"
        echo "  get <param>               - Parameter abrufen"
        echo "  context <key> <value>     - Kontext aktualisieren"
        echo "  snapshot [name] [desc]    - Snapshot erstellen"
        echo "  restore-snapshot <name>   - Snapshot wiederherstellen"
        echo "  end                       - Aktuelle Session beenden"
        echo "  list                      - Alle Sessions auflisten"
        echo "  current                   - Aktuelle Session anzeigen"
        echo "  help                      - Diese Hilfe"
        ;;
    *)
        echo -e "${BLUE}Session Manager für ai-collab${NC}"
        echo -e "${YELLOW}Verwende '$0 help' für alle Kommandos${NC}"
        ;;
esac