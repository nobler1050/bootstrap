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
