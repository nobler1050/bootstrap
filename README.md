# Bootstrap

This is a public repository containing the entry-point script for my private provisioning setup. It handles system dependencies, GitHub authentication, and clones the private `provisioning` repo.

## Quick Start

Run this one-liner on a fresh Fedora installation:

```bash
curl -sSL https://raw.githubusercontent.com/nobler1050/bootstrap/main/bootstrap.sh | bash
```

## What it does
1.  Installs `git`, `gh` (GitHub CLI), and `ansible`.
2.  Guides you through `gh auth login` to access private repositories.
3.  Clones the private `provisioning` repository to `~/provisioning`.
4.  Prompts you to select an Ansible playbook (e.g., `wsl.yml`, `laptop.yml`) to run.
