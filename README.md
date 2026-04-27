# Bootstrap

This is a public repository containing the entry-point script for my private provisioning setup. It bridges the gap between a fresh Fedora install and a fully provisioned environment.

## 🚀 Quick Start

Run this one-liner on a fresh Fedora installation:

```bash
curl -sSL https://raw.githubusercontent.com/nobler1050/bootstrap/main/bootstrap.sh | bash
```

## What it does
1.  **System Prep:** Installs `git`, `gh` (GitHub CLI), and `ansible`.
2.  **Authentication:** Guides you through `gh auth login` to gain access to private repositories.
3.  **Clone:** Clones the private `provisioning` repository to `~/git/provisioning`.
4.  **Handoff:** Prompts you to select an initial playbook to run and provides instructions for future updates.

## Next Steps
Once bootstrapped, all future updates and configuration changes are managed within the [Provisioning](https://github.com/nobler1050/provisioning) repository.
