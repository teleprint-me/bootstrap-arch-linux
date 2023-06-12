#!/usr/bin/env bash

# Function to update the system
pacman_system_update() {
    if ! sudo pacman -Syu --noconfirm; then
        echo "Failed to update the system"
        exit 1
    fi
}
