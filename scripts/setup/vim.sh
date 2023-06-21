#!/usr/bin/env bash

setup_vim() {
    if ! sudo pacman -S vim --noconfirm; then
        echo Failed
        return 1
    fi

    if ! cp -v dotfiles/.vimrc ~/.vimrc; then
        echo Failed
        return 1
    fi
}
