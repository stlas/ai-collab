#!/bin/bash
# FILE: ./core/src/github-integration.sh

# github-integration.sh - GitHub CLI Integration für ai-collab
# Automatisches Versionieren, Releases und Issue-Management

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
CONFIG_DIR="$LOCAL_DIR/config"

# GitHub-Konfiguration
GITHUB_CONFIG="$CONFIG_DIR/github.json"

# GitHub CLI Installation prüfen
check_github_cli() {
    echo -e "${BLUE}=== GITHUB CLI STATUS ===${NC}"
    
    # 1. GitHub CLI Installation prüfen
    if ! command -v gh &> /dev/null; then
        echo -e "${YELLOW}⚠️  GitHub CLI nicht gefunden${NC}"
        echo -e "${CYAN}🔧 Automatische Installation wird geecho "URL:"et...${NC}"
        
        if install_github_cli; then
            echo -e "${GREEN}✅ GitHub CLI erfolgreich installiert${NC}"
        else
            echo -e "${RED}❌ GitHub CLI Installation fehlgeschlagen${NC}"
            echo -e "${YELLOW}💡 Manuelle Installation: https://cli.github.com/manual/installation${NC}"
            return 1
        fi
    else
        local gh_version=$(gh --version | head -n1)
        echo -e "${GREEN}✅ GitHub CLI gefunden: $gh_version${NC}"
    fi
    
    # 2. Authentication prüfen
    if ! gh auth status &>/dev/null; then
        echo -e "${YELLOW}⚠️  GitHub CLI nicht authentifiziert${NC}"
        echo -e "${CYAN}🔐 Automatisches Authentication-Setup wird geecho "URL:"et...${NC}"
        echo ""
        
        if setup_github_auth; then
            echo -e "${GREEN}✅ GitHub Authentication erfolgreich eingerichtet${NC}"
        else
            echo -e "${RED}❌ GitHub Authentication fehlgeschlagen${NC}"
            return 1
        fi
    else
        local username=$(gh api user --jq '.login' 2>/dev/null || echo "unknown")
        echo -e "${GREEN}✅ GitHub Authentication OK - Angemeldet als: $username${NC}"
    fi
    
    # 3. Repository-Kontext prüfen
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local repo_url=$(git remote get-url origin 2>/dev/null || echo "no-remote")
        if [[ "$repo_url" == *"github.com"* ]]; then
            echo -e "${GREEN}✅ GitHub Repository erkannt${NC}"
        else
            echo -e "${YELLOW}⚠️  Kein GitHub Repository - lokale Entwicklung${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Kein Git Repository - initialisiere falls nötig${NC}"
    fi
    
    echo -e "${GREEN}🚀 GitHub CLI vollständig eingerichtet und bereit!${NC}"
    return 0
}

# GitHub CLI installieren
install_github_cli() {
    echo -e "${BLUE}=== GITHUB CLI INSTALLATION ===${NC}"
    
    # OS Detection
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Ubuntu/Debian
        if command -v apt &> /dev/null; then
            echo -e "${CYAN}📦 Installiere GitHub CLI für Ubuntu/Debian...${NC}"
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update && sudo apt install gh -y
        # RedHat/CentOS
        elif command -v yum &> /dev/null; then
            echo -e "${CYAN}📦 Installiere GitHub CLI für RedHat/CentOS...${NC}"
            sudo yum install -y dnf
            sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
            sudo dnf install -y gh
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            echo -e "${CYAN}📦 Installiere GitHub CLI für macOS...${NC}"
            brew install gh
        else
            echo -e "${RED}❌ Homebrew nicht gefunden. Installiere Homebrew erst${NC}"
            return 1
        fi
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows
        if command -v winget &> /dev/null; then
            echo -e "${CYAN}📦 Installiere GitHub CLI für Windows...${NC}"
            winget install --id GitHub.cli
        else
            echo -e "${YELLOW}💡 Manuelle Installation erforderlich: https://cli.github.com/manual/installation${NC}"
            return 1
        fi
    fi
    
    # Installation prüfen
    if command -v gh &> /dev/null; then
        echo -e "${GREEN}✅ GitHub CLI erfolgreich installiert${NC}"
        return 0
    else
        echo -e "${RED}❌ GitHub CLI Installation fehlgeschlagen${NC}"
        return 1
    fi
}

# GitHub Authentication einrichten
setup_github_auth() {
    echo -e "${BLUE}=== GITHUB AUTHENTICATION ===${NC}"
    
    # Prüfen ob bereits authentifiziert
    if gh auth status &>/dev/null; then
        echo -e "${GREEN}✅ Bereits bei GitHub angemeldet${NC}"
        local username=$(gh api user --jq '.login')
        echo -e "${CYAN}👤 Angemeldet als: $username${NC}"
        return 0
    fi
    
    echo -e "${CYAN}🔐 GitHub Authentication Setup wird geecho "URL:"et...${NC}"
    echo ""
    echo -e "${YELLOW}📋 Es gibt mehrere Optionen:${NC}"
    echo -e "${CYAN}1. 🌐 Browser-Login (Empfohlen) - Einfach und sicher${NC}"
    echo -e "${CYAN}2. 🔑 Personal Access Token - Für Server/Automation${NC}"
    echo -e "${CYAN}3. 📱 GitHub App - Für Organisationen${NC}"
    echo ""
    
    # Benutzer-Eingabe mit Timeout für Automation
    local timeout_seconds=5
    local auth_choice=""
    
    echo -e "${YELLOW}Wähle eine Option (1-3): ${NC}"
    
    # Timeout für automatisierte Ausführung
    if read -t $timeout_seconds -r auth_choice; then
        # Eingabe erhalten
        case $auth_choice in
            1)
                echo -e "${CYAN}🌐 Browser-Login ausgewählt${NC}"
                setup_browser_auth
                return $?
                ;;
            2)
                echo -e "${CYAN}🔑 Personal Access Token ausgewählt${NC}"
                setup_token_auth
                return $?
                ;;
            3)
                echo -e "${CYAN}📱 GitHub App ausgewählt${NC}"
                setup_app_auth
                return $?
                ;;
            *)
                echo -e "${RED}❌ Ungültige Auswahl. Standard-Option wird verwendet.${NC}"
                echo -e "${CYAN}🔧 Überspringe automatisches Setup - manueller Start erforderlich${NC}"
                echo -e "${YELLOW}💡 Verwende: ./core/src/ai-collab.sh github-setup${NC}"
                return 1
                ;;
        esac
    else
        # Timeout - automatisierte Ausführung
        echo -e "${YELLOW}⏱️  Timeout - automatisierte Ausführung erkannt${NC}"
        echo -e "${CYAN}🔧 Überspringe automatisches Setup - manueller Start erforderlich${NC}"
        echo -e "${YELLOW}💡 Für manuelle Einrichtung: ./core/src/ai-collab.sh github-setup${NC}"
        return 1
    fi
}

# Browser-basierte Authentication
setup_browser_auth() {
    echo -e "${BLUE}=== BROWSER-LOGIN ===${NC}"
    echo -e "${CYAN}🌐 Öffnet automatisch deinen Browser für GitHub-Login${NC}"
    echo -e "${YELLOW}💡 Wähle 'HTTPS' als Git-Protokoll${NC}"
    echo ""
    
    gh auth login --web
    
    if gh auth status &>/dev/null; then
        save_auth_config "browser"
        return 0
    else
        echo -e "${RED}❌ Browser-Login fehlgeschlagen${NC}"
        return 1
    fi
}

# Token-basierte Authentication mit Anleitung
setup_token_auth() {
    echo -e "${BLUE}=== PERSONAL ACCESS TOKEN SETUP ===${NC}"
    echo ""
    echo -e "${YELLOW}📝 So erstellst du einen Personal Access Token:${NC}"
    echo ""
    echo -e "${CYAN}1. Öffne: https://github.com/settings/tokens${NC}"
    echo -e "${CYAN}2. Klicke 'Generate new token' → 'Generate new token (classic)'${NC}"
    echo -e "${CYAN}3. Setze folgende Scopes:${NC}"
    echo -e "   ${GREEN}✅ repo${NC} (Full control of private repositories)"
    echo -e "   ${GREEN}✅ workflow${NC} (Update GitHub Action workflows)"
    echo -e "   ${GREEN}✅ write:packages${NC} (Upload packages to GitHub Package Registry)"
    echo -e "   ${GREEN}✅ delete:packages${NC} (Delete packages from GitHub Package Registry)"
    echo -e "   ${GREEN}✅ admin:org${NC} (Full control of orgs and teams, read/write org projects)"
    echo -e "   ${GREEN}✅ admin:public_key${NC} (Full control of user public keys)"
    echo -e "   ${GREEN}✅ admin:repo_hook${NC} (Full control of repository hooks)"
    echo -e "   ${GREEN}✅ user${NC} (Update ALL user data)"
    echo -e "   ${GREEN}✅ delete_repo${NC} (Delete repositories)"
    echo -e "${CYAN}4. Klicke 'Generate token'${NC}"
    echo -e "${CYAN}5. Kopiere den Token (nur einmal sichtbar!)${NC}"
    echo ""
    
    # Browser öffnen (falls möglich)
    if command -v echo "URL:" &> /dev/null; then
        echo -e "${YELLOW}🌐 Öffne GitHub Token-Seite im Browser...${NC}"
        echo "URL:" "https://github.com/settings/tokens" &>/dev/null
    elif command -v echo "URL:" &> /dev/null; then
        echo -e "${YELLOW}🌐 Öffne GitHub Token-Seite im Browser...${NC}"
        echo "URL:" "https://github.com/settings/tokens" &>/dev/null
    elif command -v echo "URL:" &> /dev/null; then
        echo -e "${YELLOW}🌐 Öffne GitHub Token-Seite im Browser...${NC}"
        echo "URL:" "https://github.com/settings/tokens" &>/dev/null
    fi
    
    echo -e "${YELLOW}Drücke Enter wenn du den Token erstellt hast...${NC}"
    
    # Timeout für automatisierte Ausführung
    if ! read -t 5 -r; then
        echo -e "${YELLOW}⏱️  Timeout - überspringe Token-Setup${NC}"
        echo -e "${CYAN}💡 Für manuelle Token-Einrichtung: ./core/src/ai-collab.sh github-setup${NC}"
        return 1
    fi
    
    # Token eingeben
    local attempts=0
    local max_attempts=3
    
    while [ $attempts -lt $max_attempts ]; do
        echo -e "${CYAN}🔑 Füge deinen Personal Access Token ein:${NC}"
        echo -e "${YELLOW}💡 Der Token wird sicher gespeichert und nicht angezeigt${NC}"
        
        # Timeout für automatisierte Ausführung
        if ! read -s -t 10 -r token; then
            echo -e "${YELLOW}⏱️  Timeout - überspringe Token-Setup${NC}"
            echo -e "${CYAN}💡 Für manuelle Token-Einrichtung: ./core/src/ai-collab.sh github-setup${NC}"
            return 1
        fi
        echo ""
        
        if [ -z "$token" ]; then
            echo -e "${RED}❌ Token darf nicht leer sein${NC}"
            attempts=$((attempts + 1))
            continue
        fi
        
        # Token validieren
        echo -e "${CYAN}🔍 Validiere Token...${NC}"
        if echo "$token" | gh auth login --with-token; then
            save_auth_config "token"
            return 0
        else
            echo -e "${RED}❌ Token ungültig. Bitte erneut versuchen.${NC}"
            echo -e "${YELLOW}💡 Stelle sicher, dass:${NC}"
            echo -e "  - Der Token vollständig kopiert wurde"
            echo -e "  - Alle erforderlichen Scopes gesetzt sind"
            echo -e "  - Der Token nicht abgelaufen ist"
            echo ""
            attempts=$((attempts + 1))
        fi
    done
    
    echo -e "${RED}❌ Maximale Anzahl Versuche erreicht${NC}"
    echo -e "${CYAN}💡 Für manuelle Token-Einrichtung: ./core/src/ai-collab.sh github-setup${NC}"
    return 1
}

# GitHub App Authentication
setup_app_auth() {
    echo -e "${BLUE}=== GITHUB APP AUTHENTICATION ===${NC}"
    echo -e "${CYAN}📱 GitHub App Login für Organisationen${NC}"
    echo -e "${YELLOW}💡 Wähle 'HTTPS' als Git-Protokoll${NC}"
    echo ""
    
    gh auth login --git-protocol https --web
    
    if gh auth status &>/dev/null; then
        save_auth_config "app"
        return 0
    else
        echo -e "${RED}❌ GitHub App Login fehlgeschlagen${NC}"
        return 1
    fi
}

# Authentifizierungs-Konfiguration speichern
save_auth_config() {
    local auth_method="$1"
    
    # Benutzerinformationen abrufen
    local username=$(gh api user --jq '.login')
    local email=$(gh api user --jq '.email // "noreply@github.com"')
    local name=$(gh api user --jq '.name // .login')
    
    # Git-Konfiguration setzen
    git config --global user.name "$name"
    git config --global user.email "$email"
    
    # ai-collab Konfiguration speichern
    mkdir -p "$CONFIG_DIR"
    jq -n \
        --arg username "$username" \
        --arg email "$email" \
        --arg name "$name" \
        --arg method "$auth_method" \
        '{
            username: $username,
            email: $email,
            name: $name,
            auth_method: $method,
            auth_setup: true,
            setup_date: now
        }' > "$GITHUB_CONFIG"
    
    echo -e "${GREEN}✅ GitHub Authentication erfolgreich${NC}"
    echo -e "${CYAN}👤 Angemeldet als: $username ($email)${NC}"
    echo -e "${CYAN}🔧 Git-Konfiguration automatisch gesetzt${NC}"
}

# Automatisches Commit und Push
auto_commit() {
    local commit_message="$1"
    local push_to_remote="${2:-true}"
    
    if [ -z "$commit_message" ]; then
        echo -e "${RED}❌ Commit-Nachricht erforderlich${NC}"
        return 1
    fi
    
    echo -e "${BLUE}=== AUTO-COMMIT ===${NC}"
    
    # Git-Status prüfen
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}❌ Kein Git-Repository gefunden${NC}"
        return 1
    fi
    
    # Untracked files anzeigen
    local untracked=$(git ls-files --others --exclude-standard)
    if [ -n "$untracked" ]; then
        echo -e "${CYAN}📁 Neue Dateien gefunden:${NC}"
        echo "$untracked" | sed 's/^/  /'
    fi
    
    # Changes anzeigen
    local changes=$(git status --porcelain)
    if [ -z "$changes" ]; then
        echo -e "${YELLOW}⚠️  Keine Änderungen zum Committen${NC}"
        return 0
    fi
    
    echo -e "${CYAN}📝 Änderungen:${NC}"
    git status --short
    
    # Staging
    git add .
    
    # Commit erstellen
    local full_message="$commit_message

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
    
    if git commit -m "$full_message"; then
        echo -e "${GREEN}✅ Commit erfolgreich erstellt${NC}"
        
        # Push to remote
        if [ "$push_to_remote" = "true" ]; then
            echo -e "${CYAN}🚀 Push zu GitHub...${NC}"
            if git push; then
                echo -e "${GREEN}✅ Push erfolgreich${NC}"
            else
                echo -e "${YELLOW}⚠️  Push fehlgeschlagen - manueller Push erforderlich${NC}"
            fi
        fi
        
        return 0
    else
        echo -e "${RED}❌ Commit fehlgeschlagen${NC}"
        return 1
    fi
}

# Automatisches Release erstellen
auto_release() {
    local version="$1"
    local title="$2"
    local description="$3"
    local prerelease="${4:-false}"
    
    if [ -z "$version" ] || [ -z "$title" ]; then
        echo -e "${RED}❌ Version und Titel erforderlich${NC}"
        echo "Usage: auto_release <version> <title> [description] [prerelease]"
        return 1
    fi
    
    echo -e "${BLUE}=== AUTO-RELEASE ===${NC}"
    
    # GitHub CLI verfügbar?
    if ! check_github_cli; then
        return 1
    fi
    
    # Git Tag erstellen falls nicht vorhanden
    if ! git tag -l | grep -q "^$version$"; then
        echo -e "${CYAN}🏷️  Erstelle Git-Tag: $version${NC}"
        git tag -a "$version" -m "$title"
        git push origin "$version"
    fi
    
    # Release erstellen
    echo -e "${CYAN}🚀 Erstelle GitHub Release...${NC}"
    
    local release_cmd="gh release create \"$version\" --title \"$title\""
    
    if [ -n "$description" ]; then
        release_cmd="$release_cmd --notes \"$description\""
    else
        release_cmd="$release_cmd --generate-notes"
    fi
    
    if [ "$prerelease" = "true" ]; then
        release_cmd="$release_cmd --prerelease"
    fi
    
    if eval "$release_cmd"; then
        local release_url="https://github.com/$(gh repo view --json owner,name --jq '.owner.login + \"/\" + .name')/releases/tag/$version"
        echo -e "${GREEN}✅ Release erfolgreich erstellt${NC}"
        echo -e "${CYAN}🔗 URL: $release_url${NC}"
        return 0
    else
        echo -e "${RED}❌ Release-Erstellung fehlgeschlagen${NC}"
        return 1
    fi
}

# Issue erstellen
create_issue() {
    local title="$1"
    local body="$2"
    local labels="$3"
    local assignee="$4"
    
    if [ -z "$title" ]; then
        echo -e "${RED}❌ Issue-Titel erforderlich${NC}"
        return 1
    fi
    
    echo -e "${BLUE}=== ISSUE ERSTELLEN ===${NC}"
    
    if ! check_github_cli; then
        return 1
    fi
    
    local issue_cmd="gh issue create --title \"$title\""
    
    if [ -n "$body" ]; then
        issue_cmd="$issue_cmd --body \"$body\""
    fi
    
    if [ -n "$labels" ]; then
        issue_cmd="$issue_cmd --label \"$labels\""
    fi
    
    if [ -n "$assignee" ]; then
        issue_cmd="$issue_cmd --assignee \"$assignee\""
    fi
    
    if eval "$issue_cmd"; then
        echo -e "${GREEN}✅ Issue erfolgreich erstellt${NC}"
        return 0
    else
        echo -e "${RED}❌ Issue-Erstellung fehlgeschlagen${NC}"
        return 1
    fi
}

# Pull Request erstellen
create_pull_request() {
    local title="$1"
    local body="$2"
    local base_branch="${3:-main}"
    local draft="${4:-false}"
    
    if [ -z "$title" ]; then
        echo -e "${RED}❌ PR-Titel erforderlich${NC}"
        return 1
    fi
    
    echo -e "${BLUE}=== PULL REQUEST ERSTELLEN ===${NC}"
    
    if ! check_github_cli; then
        return 1
    fi
    
    # Aktuelle Branch
    local current_branch=$(git branch --show-current)
    if [ "$current_branch" = "$base_branch" ]; then
        echo -e "${RED}❌ Kann PR nicht vom Base-Branch ($base_branch) erstellen${NC}"
        return 1
    fi
    
    # Push current branch
    echo -e "${CYAN}🚀 Push Branch zu GitHub...${NC}"
    git push -u origin "$current_branch"
    
    local pr_cmd="gh pr create --title \"$title\" --base \"$base_branch\""
    
    if [ -n "$body" ]; then
        pr_cmd="$pr_cmd --body \"$body\""
    fi
    
    if [ "$draft" = "true" ]; then
        pr_cmd="$pr_cmd --draft"
    fi
    
    if eval "$pr_cmd"; then
        echo -e "${GREEN}✅ Pull Request erfolgreich erstellt${NC}"
        return 0
    else
        echo -e "${RED}❌ PR-Erstellung fehlgeschlagen${NC}"
        return 1
    fi
}

# GitHub-Repository-Informationen
repo_info() {
    echo -e "${BLUE}=== REPOSITORY-INFORMATIONEN ===${NC}"
    
    if ! check_github_cli; then
        return 1
    fi
    
    local repo_json=$(gh repo view --json name,owner,description,url,stars,forks,issues,pullRequests)
    local name=$(echo "$repo_json" | jq -r '.name')
    local owner=$(echo "$repo_json" | jq -r '.owner.login')
    local description=$(echo "$repo_json" | jq -r '.description // "Keine Beschreibung"')
    local url=$(echo "$repo_json" | jq -r '.url')
    local stars=$(echo "$repo_json" | jq -r '.stargazerCount')
    local forks=$(echo "$repo_json" | jq -r '.forkCount')
    
    echo -e "${CYAN}📁 Repository: $owner/$name${NC}"
    echo -e "${CYAN}📝 Beschreibung: $description${NC}"
    echo -e "${CYAN}🌐 URL: $url${NC}"
    echo -e "${CYAN}⭐ Stars: $stars${NC}"
    echo -e "${CYAN}🍴 Forks: $forks${NC}"
}

# Hauptprogramm
case "${1:-help}" in
    "init")
        check_github_cli
        ;;
    "setup")
        setup_github_auth
        ;;
    "commit")
        auto_commit "$2" "$3"
        ;;
    "release")
        auto_release "$2" "$3" "$4" "$5"
        ;;
    "issue")
        create_issue "$2" "$3" "$4" "$5"
        ;;
    "pr")
        create_pull_request "$2" "$3" "$4" "$5"
        ;;
    "info")
        repo_info
        ;;
    "help")
        echo "GitHub Integration für ai-collab v$VERSION"
        echo ""
        echo "Commands:"
        echo "  init                              - GitHub CLI installieren und einrichten"
        echo "  setup                             - GitHub Authentication einrichten"
        echo "  commit <message> [push]           - Auto-commit mit optionalem Push"
        echo "  release <version> <title> [desc] [pre] - GitHub Release erstellen"
        echo "  issue <title> [body] [labels] [assignee] - Issue erstellen"
        echo "  pr <title> [body] [base] [draft]  - Pull Request erstellen"
        echo "  info                              - Repository-Informationen anzeigen"
        echo "  help                              - Diese Hilfe"
        echo ""
        echo "Beispiele:"
        echo "  $0 init"
        echo "  $0 commit \"Add new feature\" true"
        echo "  $0 release \"v2.1.0\" \"Neue GitHub Integration\""
        echo "  $0 issue \"Bug in session manager\" \"Session wird nicht wiederhergestellt\" \"bug\""
        ;;
    *)
        echo -e "${BLUE}GitHub Integration für ai-collab${NC}"
        echo -e "${YELLOW}Verwende '$0 help' für alle Kommandos${NC}"
        ;;
esac