#!/usr/bin/env bash

setup_vim() {
    if ! yay pacman -S vim vim-plug --noconfirm; then
        echo Failed
        return 1
    fi

    if ! cp -v dotfiles/vimrc ~/.vimrc; then
        echo Failed
        return 1
    fi
}
