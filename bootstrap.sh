#!/bin/bash
set -e

# Prevent GUI prompt errors when running in terminal
unset GIT_ASKPASS SSH_ASKPASS

echo "🚀 Starting Fedora Bootstrap..."

# 1. Install system dependencies
echo "📦 Installing git, gh, and ansible..."
sudo dnf install -y git gh ansible

# 2. Authenticate with GitHub
if ! gh auth status &>/dev/null; then
    if [ -n "$GITHUB_TOKEN" ]; then
        echo "🔑 Authenticating with GitHub CLI using provided token..."
        echo "$GITHUB_TOKEN" | gh auth login --with-token
    else
        echo "🔑 Authenticating with GitHub CLI..."
        echo "Follow the prompts to log in via your browser."
        gh auth login --hostname github.com --git-protocol https --web
    fi
fi

# Configure Git to use GitHub CLI for authentication
gh auth setup-git -h github.com

# 3. Clone the private provisioning repository
echo "🔍 Fetching GitHub username..."
GH_USER=$(gh api user --jq .login)
REPO_NAME="provisioning"
DEST="$HOME/git/$REPO_NAME" # Standardizing to ~/git/

mkdir -p "$(dirname "$DEST")"

if [ ! -d "$DEST" ]; then
    echo "📂 Cloning private repository: $GH_USER/$REPO_NAME..."
    gh repo clone "$GH_USER/$REPO_NAME" "$DEST"
else
    echo "🔄 Updating existing repository in $DEST..."
    cd "$DEST"
    git pull
fi

# 4. Select Playbook and Show Command
cd "$DEST"
echo ""
echo "📜 Available playbooks in $REPO_NAME:"
PLAYBOOKS=(*.yml)
for i in "${!PLAYBOOKS[@]}"; do
    echo "  $((i+1))) ${PLAYBOOKS[$i]}"
done

# Only prompt if we are in an interactive terminal
if [ -t 0 ]; then
    read -p "Select a playbook to run [default: 1]: " CHOICE
else
    echo "🤖 Non-interactive session detected, using default selection."
    CHOICE=1
fi
CHOICE=${CHOICE:-1}

SELECTED_PLAYBOOK="${PLAYBOOKS[$((CHOICE-1))]}"

if [[ -f "$SELECTED_PLAYBOOK" ]]; then
    echo "💡 To run this playbook, use the following command:"
    echo "   ansible-playbook \"$DEST/$SELECTED_PLAYBOOK\" -i \"localhost,\" --connection=local --ask-vault-pass"
else
    echo "❌ Invalid selection. Exiting."
    exit 1
fi

echo "✅ Setup complete!"
