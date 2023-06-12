#!/usr/bin/env bash

# Function to install Python development tools
install_vscode() {
    if ! sudo yay -S visual-studio-code-bin -noconfirm; then
        echo "Failed to install Visual Studio Code"
        exit 1
    fi
}
