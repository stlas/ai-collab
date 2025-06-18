#!/bin/bash

# ai-collab Development Cost Tracker
VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEV_COST_FILE="$PROJECT_ROOT/local/development/dev_costs.json"

mkdir -p "$(dirname "$DEV_COST_FILE")"

# Cost calculation per model
declare -A MODEL_COSTS
MODEL_COSTS[claude-3.5-haiku]="0.0025"
MODEL_COSTS[claude-3.5-sonnet]="0.015"
MODEL_COSTS[claude-4-opus]="0.075"
MODEL_COSTS[claude-4-sonnet]="0.030"

# Task complexity multipliers
declare -A COMPLEXITY_MULTIPLIERS
COMPLEXITY_MULTIPLIERS[simple_fix]="1.0"
COMPLEXITY_MULTIPLIERS[code_review]="1.5"
COMPLEXITY_MULTIPLIERS[feature_development]="2.0"
COMPLEXITY_MULTIPLIERS[architecture]="3.0"

function log_dev_session() {
    local description="$1"
    local task_type="$2"
    local duration_minutes="$3"
    local model="$4"

    local base_cost="${MODEL_COSTS[$model]:-0.015}"
    local multiplier="${COMPLEXITY_MULTIPLIERS[$task_type]:-1.5}"
    local cost=$(echo "$base_cost * $multiplier * ($duration_minutes / 10)" | bc -l)

    echo "{\"timestamp\":\"$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")\",\"description\":\"$description\",\"task_type\":\"$task_type\",\"duration_minutes\":$duration_minutes,\"     
model\":\"$model\",\"estimated_cost\":$cost,\"session_type\":\"development_chat\"}" > /tmp/session.json

    if [ -f "$DEV_COST_FILE" ]; then
        jq ". += [$(cat /tmp/session.json)]" "$DEV_COST_FILE" > "$DEV_COST_FILE.tmp"
        mv "$DEV_COST_FILE.tmp" "$DEV_COST_FILE"
    else
        echo "[$(cat /tmp/session.json)]" > "$DEV_COST_FILE"
    fi

    echo "â Development session logged: $description"
    echo "ð° Estimated cost: \$$cost"
}

case "${1:-help}" in
    "log")
        log_dev_session "$2" "$3" "$4" "$5"
        ;;
    *)
        echo "Usage: $0 log <description> <task_type> <duration_minutes> <model>"
        ;;
esac