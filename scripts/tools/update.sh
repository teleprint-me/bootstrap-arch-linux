#!/usr/bin/env bash

source ./scripts/tools/confirm.sh

# Function to update the system
pacman_system_update() {
    confirm_proceed "Update system using pacman" || return

    if ! sudo pacman -Syu --noconfirm; then
        echo "Failed to update the system"
        exit 1
    fi
}
