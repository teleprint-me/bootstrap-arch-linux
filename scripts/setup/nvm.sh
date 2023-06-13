#!/usr/bin/env bash

setup_nvm() {
    # Check if nvm is already installed
    if command -v nvm &> /dev/null; then
        echo "nvm is already installed"
    else
        # Download and install nvm
        if ! git clone https://github.com/nvm-sh/nvm.git ~/.nvm; then
            echo "Failed to install nvm to ${HOME}/.nvm"
            exit 1
        fi

        # Source nvm script
        source ~/.nvm/nvm.sh
    fi

    # Install Node.js LTS version
    if ! nvm install --lts; then
        echo "Failed to install Node.js"
        exit 1
    fi

    # Use installed Node.js version
    local node_version
    node_version="$(nvm ls --no-colors | grep '->' | grep -o 'v[0-9]*\.[0-9]*\.[0-9]*')"
    
    if [ -z "$node_version" ]; then
        echo "Failed to find installed Node.js using ${node_version}"
        exit 1
    fi

    nvm use "$node_version"
}
