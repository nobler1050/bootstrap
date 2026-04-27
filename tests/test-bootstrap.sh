#!/bin/bash
# test-bootstrap.sh - Test the actual one-liner from the README

set -e

# Change to the project root
cd "$(dirname "$0")/../.."

# 1. Build the test image
echo "🔨 Building Fedora test image with Podman..."
podman build -t fedora-bootstrap-test bootstrap/tests/

# 2. Run the container
echo "🚀 Starting Fedora test container with Podman..."
podman rm -f fedora-test &>/dev/null || true

podman run -d \
    --name fedora-test \
    -e GITHUB_TOKEN="$GITHUB_TOKEN" \
    fedora-bootstrap-test /usr/sbin/init

# Give systemd a moment to start
echo "⏳ Waiting for systemd to initialize..."
sleep 3

# 3. Run the EXACT one-liner from README
echo "🏃 Running the one-liner..."
# This clones the repo into ~/git/provisioning
podman exec -u rnoble -e GITHUB_TOKEN="$GITHUB_TOKEN" fedora-test \
    bash -c "curl -sSL https://raw.githubusercontent.com/nobler1050/bootstrap/main/bootstrap.sh | bash"

# 4. Copy password files if they exist locally
PROV_DIR="provisioning"
if [ -d "$PROV_DIR" ]; then
    echo "🔐 Copying secret files to the cloned repository..."
    for f in .vault_pass .become_pass; do
        if [ -f "$PROV_DIR/$f" ]; then
            echo "  📂 Copying $f..."
            podman cp "$PROV_DIR/$f" "fedora-test:/home/rnoble/git/provisioning/$f"
            podman exec --user root fedora-test chown rnoble:rnoble "/home/rnoble/git/provisioning/$f"
        fi
    done
fi

echo "✅ Bootstrap complete. Container is still running for inspection."
echo "💡 Use: podman exec -it fedora-test /bin/bash"
