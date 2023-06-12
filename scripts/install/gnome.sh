#!/usr/bin/env bash

function setup_gnome() {
    if ! yay -S gnome-desktop gnome-shell-extensions gnome-browser-connector gnome-shell-extension-arc-menu gnome-shell-extension-appindicator gnome-shell-extension-material-shell gnome-tweaks gnome-terminal-transparency --noconfirm; then
        echo "Failed to install Gnome desktop environment"
        exit 1
    fi
}
