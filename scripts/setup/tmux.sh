#!/usr/bin/env bash

source ./scripts/tools/confirm.sh

setup_tmux() {
    confirm_proceed "Tmux" || return

    # Install tmux
    if ! sudo pacman -S tmux --noconfirm; then
        echo "Failed to install tmux"
        return 1
    fi

    # Clone tmux plugin manager
    if ! git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"; then
        echo "Failed to clone tmux plugin manager"
        return 1
    fi

    # Copy skeleton configuration to HOME
    cp -v ./dotfiles/tmux.conf "${HOME}/.tmux.conf"

    # Check if .tmux.conf was written successfully
    if [ $? -ne 0 ]; then
        echo "Failed to write to .tmux.conf"
        return 1
    fi

    echo "tmux setup completed successfully"
}
