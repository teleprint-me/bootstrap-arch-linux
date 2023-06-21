#!/usr/bin/env bash
# scripts/tools/ssh_agent.sh

# Developer Notes:

# For more information, visit https://docs.github.com/en/authentication/connecting-to-github-with-ssh/about-ssh

set_ssh_agent() {
    eval "$(ssh-agent -s)"
    ssh-add "${HOME}/.ssh/id_ed25519"
    ssh -T "git@github.com"
}
