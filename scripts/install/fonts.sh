#!/usr/bin/env bash

# Function to install fonts
install_fonts() {
    if ! sudo pacman -S adobe-source-code-pro-fonts ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols-mono noto-fonts noto-fonts-extra noto-fonts-emoji ttf-noto-nerd --noconfirm; then
        echo "Failed to install core system fonts"
        exit 1
    fi
}
