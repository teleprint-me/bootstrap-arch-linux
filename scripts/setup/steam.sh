#!/usr/bin/env bash

# Function to install steam
setup_steam() {
    if ! sudo yay -S steam steam-native-runtime wine winetricks protontricks-git proton-ge-custom-bin xboxdrv --noconfirm; then
        echo "Failed to install Steam"
        exit 1
    fi
    
    if ! sudo systemctl enable xboxdrv; then
        echo "Failed to enable xbox driver support"
        exit 1
    fi
}
