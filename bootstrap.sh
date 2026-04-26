#!/bin/bash
set -e

echo "🚀 Starting Fedora Bootstrap..."

# 1. Install system dependencies
echo "📦 Installing git, gh, and ansible..."
sudo dnf install -y git gh ansible

# 2. Authenticate with GitHub
if ! gh auth status &>/dev/null; then
    echo "🔑 Authenticating with GitHub CLI..."
    echo "Follow the prompts to log in via your browser."
    gh auth login --hostname github.com --git-protocol https --web
fi

# 3. Clone the private provisioning repository
REPO_NAME="provisioning"
DEST="$HOME/$REPO_NAME"

if [ ! -d "$DEST" ]; then
    echo "📂 Cloning private repository: $REPO_NAME..."
    gh repo clone "nobler1050/$REPO_NAME" "$DEST"
else
    echo "🔄 Updating existing repository in $DEST..."
    cd "$DEST"
    git pull
fi

# 4. Select and Execute Playbook
cd "$DEST"
echo ""
echo "📜 Available playbooks in $REPO_NAME:"
PLAYBOOKS=(*.yml)
for i in "${!PLAYBOOKS[@]}"; do
    echo "  $((i+1))) ${PLAYBOOKS[$i]}"
done

read -p "Select a playbook to run [default: 1]: " CHOICE
CHOICE=${CHOICE:-1}

SELECTED_PLAYBOOK="${PLAYBOOKS[$((CHOICE-1))]}"

if [[ -f "$SELECTED_PLAYBOOK" ]]; then
    echo "🛠️ Running Ansible playbook: $SELECTED_PLAYBOOK..."
    ansible-playbook "$SELECTED_PLAYBOOK" -i "localhost," --connection=local --ask-vault-pass
else
    echo "❌ Invalid selection. Exiting."
    exit 1
fi

echo "✅ Setup complete!"
