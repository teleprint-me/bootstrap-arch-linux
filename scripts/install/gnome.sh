#!/usr/bin/env bash

source ./scripts/tools/confirm.sh

function install_gnome_desktop() {
    confirm_proceed "Gnome Desktop Environment" || return

    if ! sudo pacman -S gnome-desktop --noconfirm; then
        echo "Failed to install Gnome desktop environment"
        exit 1
    fi
}

function install_gnome_extensions() {
    confirm_proceed "Gnome Shell Extensions" || return

    if ! yay -S gnome-shell-extensions gnome-browser-connector gnome-shell-extension-arc-menu gnome-shell-extension-appindicator gnome-shell-extension-material-shell gnome-tweaks gnome-terminal-transparency --noconfirm; then
        echo "Failed to install Gnome shell extensions"
        exit 1
    fi
}

function install_gnome() {
    install_gnome_desktop
    install_gnome_extensions
}
