#!/usr/bin/env bash

source ./scripts/tools/confirm.sh

# Function to install Python development tools
install_vscode() {
    confirm_proceed "code: Install Visual Studio Code" || return

    if ! yay -S visual-studio-code-bin --noconfirm; then
        echo "Failed to install Visual Studio Code"
        return 1
    fi
}
