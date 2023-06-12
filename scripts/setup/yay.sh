#!/usr/bin/env bash

setup_yay() {
    # Check if yay is already installed
    if command -v yay &> /dev/null; then
        echo "yay is already installed"
        return
    fi

    # Clone the yay repository
    if ! git clone https://aur.archlinux.org/yay.git; then
        echo "Failed to clone yay repository"
        exit 1
    fi

    # Change to the yay directory
    cd yay || exit

    # Build and install yay
    if ! makepkg -si; then
        echo "Failed to install yay"
        exit 1
    fi

    # Change back to the previous directory
    cd - || exit

    # Remove the yay directory
    rm -rf yay
}
