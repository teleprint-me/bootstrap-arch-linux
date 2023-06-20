#!/usr/bin/env bash

source ./scripts/tools/confirm.sh

setup_yay() {
    confirm_proceed "Yay" || return

    # Check if yay is already installed
    if command -v yay &> /dev/null; then
        echo "yay is already installed"
        return 0
    fi

    # Clone the yay repository
    if ! git clone https://aur.archlinux.org/yay.git; then
        echo "Failed to clone yay repository"
        return 1
    fi

    # Change to the yay directory
    cd yay || return 1

    # Build and install yay
    if ! makepkg -si; then
        echo "Failed to install yay"
        return 1
    fi

    # Change back to the previous directory
    cd - || return 1

    # Remove the yay directory
    rm -rf yay

    echo "Yay setup completed successfully"
}
