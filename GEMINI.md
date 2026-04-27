# GEMINI.md - Bootstrap Project Context

This is the public entry-point for the `provisioning` project. Its primary goal is to bridge the gap between a fresh OS install and a fully provisioned environment.

## Project Overview
*   **Purpose:** Bootstrapping and authentication.
*   **Key File:** `bootstrap.sh` (Interactive Bash script).
*   **Dependencies:** GitHub CLI (`gh`), Git, Ansible.

## Relationship to Provisioning Repo
*   This repo is **public**.
*   The `provisioning` repo is **private**.
*   This script uses the `gh` CLI's interactive web flow to gain access to the private repo without requiring pre-configured SSH keys or tokens.

## Development Notes
*   **Interactivity:** The script is intentionally interactive to handle browser-based OAuth and playbook selection.
*   **Simplicity:** Keep this repository minimal. High-level logic belongs in the Ansible playbooks within the `provisioning` repository.
*   **Portability:** The script dynamically fetches the authenticated GitHub username to clone the `provisioning` repository.

## Testing
A Podman-based testing suite is available in `tests/`. This allows for end-to-end validation of the bootstrap process on a clean Fedora instance.
*   **Dockerfile:** Minimal Fedora image with `systemd` and `sudo`.
*   **test-bootstrap.sh:** Runs the README one-liner and verifies the clone/secret handling.
To run tests:
```bash
export GITHUB_TOKEN=$(gh auth token)
./tests/test-bootstrap.sh
```
