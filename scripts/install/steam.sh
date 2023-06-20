#!/usr/bin/env bash

source ./scripts/tools/confirm.sh

# Function to install steam
install_steam() {
    confirm_proceed "Steam and Steam Play dependencies" || return

    if ! yay -S steam steam-native-runtime wine winetricks-git protontricks-git proton-ge-custom-bin --noconfirm; then
        echo "Failed to install Steam"
        return 1
    fi
}

# NOTE: `xboxdrv` is used to support xbox, ps, nintendo, and other input device types.
# Other packages and modifications may be required or preferable.
install_xboxdrv() {
    confirm_proceed "Xbox Driver Support" || return

    if ! yay -S xboxdrv --noconfirm; then
        echo "Failed to install Steam"
        return 1
    fi

    if ! sudo systemctl enable xboxdrv; then
        echo "Failed to enable xbox driver support"
        return 1
    fi

    if ! sudo systemctl start xboxdrv; then
        echo "Failed to start xbox driver"
        return 1
    fi
}
