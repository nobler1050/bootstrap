FROM fedora:latest

# Install only the bare essentials to allow bootstrap.sh to do its job
# We need sudo so the script can install its own packages
RUN dnf install -y sudo systemd && dnf clean all

# Setup a test user that matches your environment
RUN useradd -m -G wheel rnoble && \
    echo "rnoble ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# systemd setup - simpler for modern Fedora
ENV container=docker
STOPSIGNAL SIGRTMIN+3

WORKDIR /home/rnoble

# Default to running systemd
CMD ["/usr/sbin/init"]
