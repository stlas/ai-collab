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
    if ! command -v gh &> /dev/null; then
        echo -e "${YELLOW}⚠️  GitHub CLI nicht gefunden. Installiere...${NC}"
        install_github_cli
        return $?
    fi
    
    # Authentication prüfen
    if ! gh auth status &>/dev/null; then
        echo -e "${YELLOW}⚠️  GitHub CLI nicht authentifiziert${NC}"
        setup_github_auth
        return $?
    fi
    
    echo -e "${GREEN}✅ GitHub CLI bereit${NC}"
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
    
    echo -e "${CYAN}🔐 GitHub CLI Authentication wird gestartet...${NC}"
    echo -e "${YELLOW}💡 Wähle 'HTTPS' und 'Login with a browser' für die einfachste Einrichtung${NC}"
    
    gh auth login
    
    if gh auth status &>/dev/null; then
        echo -e "${GREEN}✅ GitHub Authentication erfolgreich${NC}"
        
        # GitHub-Konfiguration speichern
        local username=$(gh api user --jq '.login')
        local email=$(gh api user --jq '.email // "noreply@github.com"')
        
        jq -n \
            --arg username "$username" \
            --arg email "$email" \
            '{
                username: $username,
                email: $email,
                auth_setup: true,
                setup_date: now
            }' > "$GITHUB_CONFIG"
            
        echo -e "${CYAN}👤 Angemeldet als: $username${NC}"
        return 0
    else
        echo -e "${RED}❌ GitHub Authentication fehlgeschlagen${NC}"
        return 1
    fi
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