#!/usr/bin/env bash

source ./scripts/tools/confirm.sh

# Function to install Python development tools
install_spotify() {
    confirm_proceed "Spotify" || return

    if ! yay -S spotify-launcher --noconfirm; then
        echo "Failed to install Spotify"
        return 1
    fi
}
