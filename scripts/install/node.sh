#!/usr/bin/env bash

install_nodejs() {
    if ! sudo pacman -S nodejs -noconfirm; then
        echo "Failed to install NodeJS"
        exit 1
    fi
}
