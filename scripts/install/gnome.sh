#!/usr/bin/env bash

# This script installs the Gnome Desktop Environment, several Gnome shell extensions, and the Gnome Terminal with transparency feature from the AUR.
# It asks for user confirmation before installing each component and before removing the Gnome Console.
# If any operation fails, the script informs the user and exits with an error status.
# On successful completion, the script sets Gnome Terminal as the default terminal emulator and removes Gnome Console.

source ./scripts/tools/confirm.sh

install_gnome_desktop() {
    confirm_proceed "Gnome Desktop Environment" || return

    if ! sudo pacman -S gnome-desktop gdm --noconfirm; then
        echo "Failed to install Gnome desktop environment"
        return 1
    fi
}

install_gnome_applications() {
    confirm_proceed "Gnome Applications" || return

    if ! sudo pacman -S gnome-control-center gnome-keyring gnome-calendar gnome-calculator gnome-disk-utility gnome-logs gnome-power-manager gnome-screenshot gnome-weather gnome-theme-extra nautilus gthumb evince baobab --noconfirm; then
        echo "Failed to install Gnome applications"
        return 1
    fi
}

install_gnome_extensions() {
    confirm_proceed "Gnome Shell Extensions" || return

    if ! yay -S xdg-desktop-portal-gtk xdg-desktop-portal-gnome gnome-shell-extensions gnome-browser-connector gnome-shell-extension-arc-menu gnome-shell-extension-appindicator gnome-shell-extension-material-shell gnome-tweaks --noconfirm; then
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

    if ! gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/gnome-terminal; then
        echo "Failed to set gnome-terminal as the default"
        return 1
    fi
}

remove_gnome_console() {
    # NOTE: `gnome-console` app is `/usr/bin/kgx` and is specific to EndeavourOS.
    confirm_proceed "Remove Gnome Console (EndeavourOS)" || return

    if pacman -Qq gnome-console &>/dev/null; then
        confirm_proceed "Gnome Console" "remove" || return

        if ! sudo pacman -R gnome-console --noconfirm; then
            echo "Failed to remove gnome-console"
            return 1
        fi
    else
        echo "Gnome Console is not installed, skipping removal."
    fi
}

enable_gnome_display_manager() {
    confirm_proceed "Enable GDM (Gnome Display Manager)" || return

    if ! sudo systemctl enable gdm.service; then
        echo "Failed to enable GDM"
        return 1
    fi
}

install_gnome() {
    install_gnome_desktop
    install_gnome_applications
    install_gnome_extensions
    install_gnome_terminal
    remove_gnome_console
    # NOTE: Enabling GDM should always be last!
    # It will launch the display manager after execution!
    enable_gnome_display_manager
}
