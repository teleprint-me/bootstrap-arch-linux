#!/usr/bin/env bash

# Function to install C, C++, Rust, Lua, and Base development tools
install_base() {
    if ! sudo pacman -S base-devel llvm clang rust gdb make cmake ninja lua aspell hunspell shellcheck mlocate nmap curl wget openssl openssh gnupg imagemagick ffmpegthumbs ffmpegthumbnailer tree -y; then
        echo "Failed to install core system packages"
        exit 1
    fi
}
