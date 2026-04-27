FROM fedora:latest

# Install essentials
RUN dnf install -y sudo systemd curl && dnf clean all

# Setup a test user
RUN useradd -m -G wheel rnoble && \
    echo "rnoble ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# systemd setup
ENV container=docker
STOPSIGNAL SIGRTMIN+3

WORKDIR /home/rnoble

# Default to running systemd
CMD ["/usr/sbin/init"]
