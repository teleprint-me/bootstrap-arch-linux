#!/usr/bin/env bash

# This script installs the Gnome Desktop Environment, several Gnome shell extensions, and the Gnome Terminal with transparency feature from the AUR.
# It asks for user confirmation before installing each component and before removing the Gnome Console.
# If any operation fails, the script informs the user and exits with an error status.
# On successful completion, the script sets Gnome Terminal as the default terminal emulator and removes Gnome Console.

source ./scripts/tools/confirm.sh

install_gnome_desktop() {
    confirm_proceed "Gnome Desktop Environment" || return

    if ! sudo pacman -S gnome-desktop --noconfirm; then
        echo "Failed to install Gnome desktop environment"
        return 1
    fi
}

install_gnome_extensions() {
    confirm_proceed "Gnome Shell Extensions" || return

    if ! yay -S gnome-shell-extensions gnome-browser-connector gnome-shell-extension-arc-menu gnome-shell-extension-appindicator gnome-shell-extension-material-shell gnome-tweaks --noconfirm; then
        echo "Failed to install Gnome shell extensions"
        return 1
    fi
}

install_gnome_terminal() {
    confirm_proceed "Gnome Terminal Transparency (AUR)" || return

    if ! yay -S gnome-terminal-transparency --noconfirm; then
        echo "Failed to install gnome-terminal-transparency"
        return 1
    fi

    # This replaces `kgx` with `gnome-terminal` as the default
    if ! gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/gnome-terminal; then
        echo "Failed to set gnome-terminal as the default"
        return 1
    fi

}

remove_gnome_console() {
    confirm_proceed "Gnome Console" "remove" || return

    # This removes `kgx` from the gnome environment
    if ! sudo pacman -R gnome-console --noconfirm; then
        echo "Failed to remove gnome-console"
        return 1
    fi
}

install_gnome() {
    install_gnome_desktop
    install_gnome_extensions
    install_gnome_terminal
    remove_gnome_console
}
