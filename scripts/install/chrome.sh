#!/usr/bin/env bash

source ./scripts/tools/confirm.sh

# Function to install Python development tools
install_google_chrome() {
    confirm_proceed "Google Chrome Web Browser" || return

    if ! yay -S google-chrome --noconfirm; then
        echo "Failed to install Google Chrome"
        return 1
    fi
}
