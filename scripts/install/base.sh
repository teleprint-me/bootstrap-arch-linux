#!/usr/bin/env bash

# function to install Base, C, and C++ development tools
install_base() {
    if ! sudo pacman -S base-devel llvm clang gdb make cmake ninja lua aspell hunspell shellcheck mlocate nmap curl wget openssl openssh gnupg imagemagick ffmpegthumbs ffmpegthumbnailer flatpak -y; then
        echo "Failed to install core system packages"
        exit 1
    fi
}
