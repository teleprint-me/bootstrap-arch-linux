#!/usr/bin/env bash

source ./scripts/tools/clone.sh
source ./scripts/tools/confirm.sh

git_clone_nvm() {
    git_clone_repo "https://github.com/nvm-sh/nvm.git" "${HOME}/.nvm"
}

setup_nvm() {
    confirm_proceed "Node Version Manager" || return

    # Check if nvm is already installed
    if command -v nvm &> /dev/null; then
        echo "nvm is already installed"
    else  # Download and install nvm
        git_clone_nvm || { echo "Failed to install nvm to ${HOME}/.nvm"; return 1; }
    fi

    # Source nvm script
    source "${HOME}/.nvm/nvm.sh"

    # Install Node.js LTS version
    if ! nvm install --lts; then
        echo "Failed to install Node.js"
        return 1
    fi

    # Use installed Node.js version
    local node_version
    node_version="$(nvm ls --no-colors | grep '->' | grep -o 'v[0-9]*\.[0-9]*\.[0-9]*')"
    
    if [ -z "$node_version" ]; then
        echo "Failed to find installed Node.js using ${node_version}"
        return 1
    fi

    nvm use "$node_version"

    echo "Nvm setup completed successfully"
}
