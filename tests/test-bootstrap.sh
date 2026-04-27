#!/bin/bash
# test-bootstrap.sh - Test the bootstrap process in a fresh Fedora container

set -e

# Change to the project root
cd "$(dirname "$0")/../.."

# 1. Build the test image
echo "🔨 Building Fedora test image with Podman..."
podman build -t fedora-bootstrap-test bootstrap/tests/

# 2. Run the container
echo "🚀 Starting Fedora test container with Podman..."
# Remove old container if it exists
podman rm -f fedora-test &>/dev/null || true

# Podman handles systemd automatically when /usr/sbin/init is the entrypoint
podman run -d \
    --name fedora-test \
    -e GITHUB_TOKEN="$GITHUB_TOKEN" \
    fedora-bootstrap-test /usr/sbin/init

# Give systemd a moment to start
echo "⏳ Waiting for systemd to initialize..."
sleep 3

# 3. Copy bootstrap.sh into the container
echo "📂 Copying bootstrap.sh to container..."
podman cp bootstrap/bootstrap.sh fedora-test:/home/rnoble/bootstrap.sh
podman exec --user root fedora-test chown rnoble:rnoble /home/rnoble/bootstrap.sh
podman exec --user root fedora-test chmod +x /home/rnoble/bootstrap.sh

# 4. Run the bootstrap script
echo "🏃 Running bootstrap.sh inside container as rnoble..."
# Run as rnoble to ensure proper home directory and permissions
podman exec -u rnoble -e GITHUB_TOKEN="$GITHUB_TOKEN" fedora-test /home/rnoble/bootstrap.sh

echo "✅ Container is still running for inspection."
echo "💡 Use: podman exec -it fedora-test /bin/bash"
