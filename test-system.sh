#!/bin/bash
# TEST: ai-collab System Test für WSL-Umgebung

echo "=== AI-COLLAB SYSTEM TEST ==="
echo ""

# Basispfad setzen
AI_COLLAB_DIR="$(dirname "$(realpath "$0")")"
echo "AI-Collab Verzeichnis: $AI_COLLAB_DIR"

# 1. Struktur-Test
echo ""
echo "1. STRUKTUR-TEST:"
echo "   ✓ Hauptverzeichnis: $([ -d "$AI_COLLAB_DIR" ] && echo "OK" || echo "FEHLT")"
echo "   ✓ Core-Verzeichnis: $([ -d "$AI_COLLAB_DIR/core" ] && echo "OK" || echo "FEHLT")"
echo "   ✓ Src-Verzeichnis: $([ -d "$AI_COLLAB_DIR/core/src" ] && echo "OK" || echo "FEHLT")"
echo "   ✓ Templates: $([ -d "$AI_COLLAB_DIR/core/templates" ] && echo "OK" || echo "FEHLT")"
echo "   ✓ Projects: $([ -d "$AI_COLLAB_DIR/projects" ] && echo "OK" || echo "FEHLT")"

# 2. Skript-Test
echo ""
echo "2. SKRIPT-VERFÜGBARKEIT:"
echo "   ✓ ai-collab.sh: $([ -f "$AI_COLLAB_DIR/core/src/ai-collab.sh" ] && echo "OK" || echo "FEHLT")"
echo "   ✓ session-manager.sh: $([ -f "$AI_COLLAB_DIR/core/src/session-manager.sh" ] && echo "OK" || echo "FEHLT")"
echo "   ✓ cost-optimizer.sh: $([ -f "$AI_COLLAB_DIR/core/src/cost-optimizer.sh" ] && echo "OK" || echo "FEHLT")"

# 3. Ausführungsrechte-Test
echo ""
echo "3. AUSFÜHRUNGSRECHTE:"
echo "   ✓ ai-collab.sh: $([ -x "$AI_COLLAB_DIR/core/src/ai-collab.sh" ] && echo "OK" || echo "FEHLT")"
echo "   ✓ session-manager.sh: $([ -x "$AI_COLLAB_DIR/core/src/session-manager.sh" ] && echo "OK" || echo "FEHLT")"
echo "   ✓ cost-optimizer.sh: $([ -x "$AI_COLLAB_DIR/core/src/cost-optimizer.sh" ] && echo "OK" || echo "FEHLT")"

# 4. Template-Test
echo ""
echo "4. TEMPLATES:"
template_count=$(find "$AI_COLLAB_DIR/core/templates" -name "*.template" 2>/dev/null | wc -l)
echo "   ✓ Template-Anzahl: $template_count"
if [ "$template_count" -gt 0 ]; then
    find "$AI_COLLAB_DIR/core/templates" -name "*.template" -exec basename {} .template \; | while read template; do
        echo "     - $template"
    done
fi

# 5. Projekt-Link-Test
echo ""
echo "5. PROJEKT-VERKNÜPFUNGEN:"
if [ -d "$AI_COLLAB_DIR/projects" ]; then
    project_count=$(find "$AI_COLLAB_DIR/projects" -type l 2>/dev/null | wc -l)
    echo "   ✓ Verknüpfte Projekte: $project_count"
    if [ "$project_count" -gt 0 ]; then
        find "$AI_COLLAB_DIR/projects" -type l | while read link; do
            project_name=$(basename "$link")
            target=$(readlink "$link")
            if [ -d "$target" ]; then
                echo "     ✓ $project_name -> $target"
            else
                echo "     ❌ $project_name -> $target (BROKEN)"
            fi
        done
    fi
fi

# 6. Funktionstest (Hilfe-Kommandos)
echo ""
echo "6. FUNKTIONSTEST:"

# AI-Collab Hilfe-Test
echo "   ✓ ai-collab.sh help:"
if "$AI_COLLAB_DIR/core/src/ai-collab.sh" help >/dev/null 2>&1; then
    echo "     OK - Hilfe funktioniert"
else
    echo "     FEHLER - Hilfe funktioniert nicht"
fi

# Session-Manager Hilfe-Test
echo "   ✓ session-manager.sh help:"
if "$AI_COLLAB_DIR/core/src/session-manager.sh" help >/dev/null 2>&1; then
    echo "     OK - Hilfe funktioniert"
else
    echo "     FEHLER - Hilfe funktioniert nicht"
fi

# Cost-Optimizer Hilfe-Test
echo "   ✓ cost-optimizer.sh help:"
if "$AI_COLLAB_DIR/core/src/cost-optimizer.sh" help >/dev/null 2>&1; then
    echo "     OK - Hilfe funktioniert"
else
    echo "     FEHLER - Hilfe funktioniert nicht"
fi

echo ""
echo "=== TEST ABGESCHLOSSEN ==="
echo ""

# WSL-spezifische Hinweise
echo "WSL-SPEZIFISCHE HINWEISE:"
echo "• Verwende absolute Pfade für Skript-Aufrufe"
echo "• Lokale Konfiguration wird in local/ erstellt (nicht versioniert)"
echo "• API-Keys müssen in local/config/.env gesetzt werden"
echo ""

echo "NÄCHSTE SCHRITTE:"
echo "1. System initialisieren: $AI_COLLAB_DIR/core/src/ai-collab.sh init"
echo "2. Erste Session starten: $AI_COLLAB_DIR/core/src/ai-collab.sh start"
echo "3. Status prüfen: $AI_COLLAB_DIR/core/src/ai-collab.sh status"