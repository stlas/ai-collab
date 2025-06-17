#!/bin/bash
# FILE: ./integration/pm-system/ai-collab-pm-integration.sh

# ai-collab-pm-integration.sh - Projektmanagement-Integration für ai-collab
# Verbindet ai-collab-Daten mit Kanboard-basiertem PM-System

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
LOCAL_DIR="$PROJECT_ROOT/local"
DEV_DIR="$LOCAL_DIR/development"
PM_DIR="$PROJECT_ROOT/integration/pm-system"

# ai-collab-pm Pfad (external)
AI_COLLAB_PM_ROOT="/mnt/a/Dokumente/Entwicklung/Powershell/ai-collab-pm"

# Kosten-Tracking für PM-Integration
PM_INTEGRATION_COSTS="$DEV_DIR/pm_integration_costs.json"

# Initialisiere Kosten-Tracking
init_pm_cost_tracking() {
    if [ ! -f "$PM_INTEGRATION_COSTS" ]; then
        cat > "$PM_INTEGRATION_COSTS" << 'EOF'
{
  "pm_integration_project": "ai-collab-pm",
  "start_date": "2025-06-17",
  "budget_allocation": {
    "total_budget_eur": 500,
    "kanboard_customization": 100,
    "integration_development": 250,
    "ui_customization": 100,
    "testing_deployment": 50
  },
  "cost_tracking": {
    "total_spent_usd": 0,
    "daily_costs": []
  },
  "development_phases": [
    {
      "phase": "setup_fork",
      "status": "in_progress", 
      "estimated_cost": 20,
      "actual_cost": 0
    },
    {
      "phase": "data_integration",
      "status": "pending",
      "estimated_cost": 100,
      "actual_cost": 0
    },
    {
      "phase": "web_interface",
      "status": "pending", 
      "estimated_cost": 150,
      "actual_cost": 0
    },
    {
      "phase": "testing_deployment",
      "status": "pending",
      "estimated_cost": 50,
      "actual_cost": 0
    }
  ]
}
EOF
        echo -e "${GREEN}✅ PM-Integration Kosten-Tracking initialisiert${NC}"
    fi
}

# ai-collab Session-Daten für PM-System exportieren
export_session_data() {
    echo -e "${BLUE}=== EXPORT AI-COLLAB DATEN FÜR PM-SYSTEM ===${NC}"
    
    local export_dir="$PM_DIR/data-export"
    mkdir -p "$export_dir"
    
    # Session-Protokolle exportieren
    if [ -d "$DEV_DIR/protocols" ]; then
        echo -e "${CYAN}📋 Exportiere Session-Protokolle...${NC}"
        cp -r "$DEV_DIR/protocols/"* "$export_dir/" 2>/dev/null || true
    fi
    
    # Statistiken exportieren
    if [ -f "$DEV_DIR/claude_code_statistics.json" ]; then
        echo -e "${CYAN}📊 Exportiere Kosten-Statistiken...${NC}"
        cp "$DEV_DIR/claude_code_statistics.json" "$export_dir/"
    fi
    
    # Aktuelle Projekte exportieren  
    if [ -d "$PROJECT_ROOT/projects" ]; then
        echo -e "${CYAN}📁 Exportiere Projekt-Liste...${NC}"
        ls -la "$PROJECT_ROOT/projects" > "$export_dir/projects_list.txt" 2>/dev/null || true
    fi
    
    # PM-Integration-Status
    local pm_status_json="$export_dir/pm_integration_status.json"
    cat > "$pm_status_json" << EOF
{
  "export_timestamp": "$(date -Iseconds)",
  "ai_collab_version": "2.0.0",
  "pm_integration_version": "$VERSION",
  "data_sources": {
    "session_protocols": $([ -d "$DEV_DIR/protocols" ] && ls "$DEV_DIR/protocols"/*.json 2>/dev/null | wc -l || echo 0),
    "cost_statistics": $([ -f "$DEV_DIR/claude_code_statistics.json" ] && echo "true" || echo "false"),
    "active_projects": $([ -d "$PROJECT_ROOT/projects" ] && ls "$PROJECT_ROOT/projects" 2>/dev/null | wc -l || echo 0)
  },
  "integration_status": "data_export_completed"
}
EOF
    
    echo -e "${GREEN}✅ Daten-Export nach $export_dir abgeschlossen${NC}"
    echo -e "${CYAN}📄 Status: $pm_status_json${NC}"
}

# Kanboard-Plugin für ai-collab-Integration erstellen
create_kanboard_plugin() {
    echo -e "${BLUE}=== ERSTELLE KANBOARD AI-COLLAB PLUGIN ===${NC}"
    
    local plugin_dir="$AI_COLLAB_PM_ROOT/plugins/AiCollabIntegration"
    
    if [ ! -d "$AI_COLLAB_PM_ROOT" ]; then
        echo -e "${RED}❌ ai-collab-pm nicht gefunden: $AI_COLLAB_PM_ROOT${NC}"
        echo -e "${YELLOW}💡 Führe zuerst: git clone https://github.com/kanboard/kanboard.git ai-collab-pm${NC}"
        return 1
    fi
    
    mkdir -p "$plugin_dir"
    
    # Plugin-Hauptdatei
    cat > "$plugin_dir/Plugin.php" << 'EOF'
<?php

namespace Kanboard\Plugin\AiCollabIntegration;

use Kanboard\Core\Plugin\Base;

class Plugin extends Base
{
    public function initialize()
    {
        $this->template->setTemplateOverride('header', 'aicollab:layout/header');
        
        // Add custom CSS
        $this->hook->on('template:layout:css', array('template' => 'plugins/AiCollabIntegration/Assets/css/ai-collab.css'));
        
        // Add custom JS  
        $this->hook->on('template:layout:js', array('template' => 'plugins/AiCollabIntegration/Assets/js/ai-collab.js'));
        
        // Add menu items
        $this->template->hook->attach('template:config:sidebar', 'aicollab:config/sidebar');
        
        // Session import hook
        $this->hook->on('app.bootstrap', array($this, 'importAiCollabSessions'));
    }
    
    public function getPluginName()
    {
        return 'ai-collab Integration';
    }
    
    public function getPluginVersion()
    {
        return '1.0.0';
    }
    
    public function getPluginAuthor()
    {
        return 'sTLAs';
    }
    
    public function getPluginDescription()
    {
        return 'Integration of ai-collab development sessions and cost tracking into Kanboard project management.';
    }
    
    public function getPluginHomepage()
    {
        return 'https://github.com/stlas/ai-collab';
    }
    
    public function importAiCollabSessions()
    {
        // Auto-import ai-collab session data
        $dataDir = '/mnt/a/Dokumente/Entwicklung/Powershell/ai-collab/integration/pm-system/data-export/';
        
        if (is_dir($dataDir)) {
            $this->importSessionsFromDirectory($dataDir);
        }
    }
    
    private function importSessionsFromDirectory($dir)
    {
        $files = glob($dir . 'session_*.json');
        
        foreach ($files as $file) {
            $sessionData = json_decode(file_get_contents($file), true);
            
            if ($sessionData) {
                $this->createTaskFromSession($sessionData);
            }
        }
    }
    
    private function createTaskFromSession($sessionData)
    {
        // Create project if not exists
        $projectId = $this->getOrCreateProject('ai-collab');
        
        // Create task from session
        $taskData = array(
            'title' => 'AI Session: ' . $sessionData['session_id'],
            'project_id' => $projectId,
            'description' => 'AI development session - Cost: $' . ($sessionData['total_cost'] ?? 0),
            'color_id' => 'green',
            'category_id' => $this->getOrCreateCategory($projectId, 'AI Development')
        );
        
        $this->taskCreation->create($taskData);
    }
    
    private function getOrCreateProject($name)
    {
        $project = $this->project->getByName($name);
        
        if (!$project) {
            return $this->project->create(array('name' => $name));
        }
        
        return $project['id'];
    }
    
    private function getOrCreateCategory($projectId, $name)
    {
        $category = $this->category->getByName($projectId, $name);
        
        if (!$category) {
            return $this->category->create(array(
                'project_id' => $projectId,
                'name' => $name
            ));
        }
        
        return $category['id'];
    }
}
EOF
    
    # Plugin CSS
    mkdir -p "$plugin_dir/Assets/css"
    cat > "$plugin_dir/Assets/css/ai-collab.css" << 'EOF'
/* ai-collab Kanboard Theme */
:root {
    --ai-collab-primary: #4F46E5;
    --ai-collab-secondary: #06B6D4; 
    --ai-collab-success: #10B981;
    --ai-collab-warning: #F59E0B;
    --ai-collab-danger: #EF4444;
}

.ai-collab-header {
    background: linear-gradient(90deg, var(--ai-collab-primary), var(--ai-collab-secondary));
    color: white;
    padding: 10px;
    border-radius: 4px;
    margin-bottom: 20px;
}

.ai-collab-cost-indicator {
    background: var(--ai-collab-success);
    color: white;
    padding: 4px 8px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: bold;
}

.ai-collab-session-task {
    border-left: 4px solid var(--ai-collab-primary);
    background: rgba(79, 70, 229, 0.05);
}

.ai-collab-stats-widget {
    background: white;
    border: 1px solid #E5E7EB;
    border-radius: 8px;
    padding: 16px;
    margin: 16px 0;
}

.ai-collab-cost-chart {
    height: 200px;
    width: 100%;
}
EOF
    
    # Plugin JavaScript
    mkdir -p "$plugin_dir/Assets/js"
    cat > "$plugin_dir/Assets/js/ai-collab.js" << 'EOF'
// ai-collab Kanboard Integration JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Add ai-collab branding
    addAiCollabHeader();
    
    // Real-time cost updates
    if (typeof aiCollabCostData !== 'undefined') {
        renderCostChart();
    }
    
    // Auto-refresh session data every 5 minutes
    setInterval(refreshSessionData, 300000);
});

function addAiCollabHeader() {
    const header = document.createElement('div');
    header.className = 'ai-collab-header';
    header.innerHTML = `
        <h3>🤖 ai-collab Project Management</h3>
        <p>KI-optimierte Entwicklung mit Kosten-Tracking</p>
    `;
    
    const main = document.querySelector('main') || document.body;
    main.insertBefore(header, main.firstChild);
}

function renderCostChart() {
    // Simple cost visualization
    const chartContainer = document.createElement('div');
    chartContainer.className = 'ai-collab-stats-widget';
    chartContainer.innerHTML = `
        <h4>💰 Entwicklungskosten</h4>
        <div class="ai-collab-cost-chart" id="cost-chart">
            <p>Heute: $${aiCollabCostData.today || 0}</p>
            <p>Monat: $${aiCollabCostData.month || 0}</p>
            <p>Gesamt: $${aiCollabCostData.total || 0}</p>
        </div>
    `;
    
    document.querySelector('main').appendChild(chartContainer);
}

function refreshSessionData() {
    // Auto-refresh session data via AJAX
    fetch('/plugins/AiCollabIntegration/refresh-sessions')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                location.reload();
            }
        })
        .catch(error => console.log('ai-collab refresh failed:', error));
}
EOF
    
    # Plugin-Template
    mkdir -p "$plugin_dir/Template/config"
    cat > "$plugin_dir/Template/config/sidebar.php" << 'EOF'
<li <?= $this->app->checkMenuSelection('AiCollabIntegrationController') ?>>
    <?= $this->url->link('🤖 ai-collab', 'AiCollabIntegrationController', 'show') ?>
</li>
EOF
    
    echo -e "${GREEN}✅ Kanboard ai-collab Plugin erstellt: $plugin_dir${NC}"
    echo -e "${CYAN}📁 Plugin-Struktur:${NC}"
    echo -e "  Plugin.php - Hauptlogik"
    echo -e "  Assets/css/ai-collab.css - Styling"  
    echo -e "  Assets/js/ai-collab.js - Frontend-Logic"
    echo -e "  Template/config/sidebar.php - Navigation"
}

# Kosten für PM-Integration tracken
track_pm_development_cost() {
    local cost_usd="$1"
    local description="$2"
    local phase="${3:-general}"
    
    if [ -z "$cost_usd" ]; then
        echo -e "${RED}❌ Keine Kosten angegeben${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}💰 Tracke PM-Entwicklungskosten: \$$cost_usd${NC}"
    
    # Update JSON mit neuen Kosten
    local temp_file=$(mktemp)
    jq --arg date "$(date -Iseconds)" \
       --arg cost "$cost_usd" \
       --arg desc "$description" \
       --arg phase "$phase" \
       '.cost_tracking.total_spent_usd += ($cost | tonumber) |
        .cost_tracking.daily_costs += [{
          "date": $date,
          "cost_usd": ($cost | tonumber), 
          "description": $desc,
          "phase": $phase
        }] |
        .development_phases |= map(
          if .phase == $phase then 
            .actual_cost += ($cost | tonumber) 
          else . end
        )' "$PM_INTEGRATION_COSTS" > "$temp_file"
    
    mv "$temp_file" "$PM_INTEGRATION_COSTS"
    
    echo -e "${GREEN}✅ Kosten getrackt: \$$cost_usd für $description${NC}"
    
    # Budget-Check
    local total_spent=$(jq -r '.cost_tracking.total_spent_usd' "$PM_INTEGRATION_COSTS")
    local total_budget=$(jq -r '.budget_allocation.total_budget_eur' "$PM_INTEGRATION_COSTS")
    local budget_usd=$(echo "$total_budget * 1.1" | bc -l) # Rough EUR->USD conversion
    
    echo -e "${CYAN}📊 Budget-Status: \$$total_spent / \$$budget_usd${NC}"
    
    if (( $(echo "$total_spent > $budget_usd" | bc -l) )); then
        echo -e "${RED}⚠️  BUDGET-WARNUNG: Überschreitung um \$$(echo "$total_spent - $budget_usd" | bc -l)${NC}"
    fi
}

# PM-System Status anzeigen
show_pm_status() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                AI-COLLAB PM INTEGRATION                      ║${NC}"
    echo -e "${PURPLE}║              Projektmanagement-System Status                 ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Kosten-Status
    if [ -f "$PM_INTEGRATION_COSTS" ]; then
        local total_spent=$(jq -r '.cost_tracking.total_spent_usd' "$PM_INTEGRATION_COSTS")
        local total_budget=$(jq -r '.budget_allocation.total_budget_eur' "$PM_INTEGRATION_COSTS")
        
        echo -e "${CYAN}=== BUDGET-STATUS ===${NC}"
        echo -e "${YELLOW}💰 Budget: ${total_budget}€ (~\$$(echo "$total_budget * 1.1" | bc -l))${NC}"
        echo -e "${YELLOW}💸 Ausgegeben: \$$total_spent${NC}"
        echo ""
    fi
    
    # Entwicklungsphasen
    echo -e "${CYAN}=== ENTWICKLUNGSPHASEN ===${NC}"
    if [ -f "$PM_INTEGRATION_COSTS" ]; then
        jq -r '.development_phases[] | "  \(.phase): \(.status) - $\(.actual_cost)/$\(.estimated_cost)"' "$PM_INTEGRATION_COSTS"
    fi
    echo ""
    
    # Export-Status
    echo -e "${CYAN}=== DATEN-EXPORT ===${NC}"
    local export_dir="$PM_DIR/data-export"
    if [ -d "$export_dir" ]; then
        echo -e "${GREEN}✅ Export-Verzeichnis: $export_dir${NC}"
        echo -e "${CYAN}📄 Dateien: $(ls "$export_dir" 2>/dev/null | wc -l)${NC}"
    else
        echo -e "${YELLOW}⚠️  Noch kein Daten-Export${NC}"
    fi
    echo ""
    
    # Kanboard-Status
    echo -e "${CYAN}=== KANBOARD-STATUS ===${NC}"
    if [ -d "$AI_COLLAB_PM_ROOT" ]; then
        echo -e "${GREEN}✅ ai-collab-pm geklont: $AI_COLLAB_PM_ROOT${NC}"
        
        local plugin_dir="$AI_COLLAB_PM_ROOT/plugins/AiCollabIntegration"
        if [ -d "$plugin_dir" ]; then
            echo -e "${GREEN}✅ ai-collab Plugin installiert${NC}"
        else
            echo -e "${YELLOW}⚠️  Plugin noch nicht installiert${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  ai-collab-pm noch nicht geklont${NC}"
    fi
}

# Hauptprogramm
case "${1:-help}" in
    "init")
        init_pm_cost_tracking
        ;;
    "export")
        export_session_data
        track_pm_development_cost "5.00" "Session-Daten-Export" "data_integration"
        ;;
    "create-plugin")
        create_kanboard_plugin
        track_pm_development_cost "15.00" "Kanboard-Plugin-Erstellung" "setup_fork"
        ;;
    "track-cost")
        track_pm_development_cost "$2" "$3" "$4"
        ;;
    "status")
        show_pm_status
        ;;
    "help")
        echo "ai-collab PM-Integration v$VERSION"
        echo ""
        echo "Commands:"
        echo "  init          - Initialisiere PM-Integration"
        echo "  export        - Exportiere ai-collab Daten"
        echo "  create-plugin - Erstelle Kanboard-Plugin"
        echo "  track-cost <amount> <description> [phase] - Tracke Entwicklungskosten"
        echo "  status        - Zeige PM-Integration Status"
        echo "  help          - Diese Hilfe"
        echo ""
        echo "Beispiele:"
        echo "  $0 init"
        echo "  $0 export"
        echo "  $0 create-plugin"
        echo "  $0 track-cost 25.50 \"Web-Interface Development\" web_interface"
        echo "  $0 status"
        ;;
    *)
        echo -e "${BLUE}ai-collab PM-Integration v$VERSION${NC}"
        echo -e "${YELLOW}Verwende '$0 help' für alle Kommandos${NC}"
        ;;
esac