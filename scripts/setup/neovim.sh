#!/usr/bin/env bash

install_neovim() {
    local cwd="${PWD}"
    local config_nvim="${HOME}/.config/nvim"

    # Remove old neovim cache and backup directories
    if ! rm -rfv "${HOME}/.cache/nvim" "${HOME}/.local/share/nvim" "${HOME}/.config/nvim.backup"; then
        echo "Failed to remove old neovim directories"
        exit 1
    fi

    # Backup existing neovim configuration
    if [ -d "${HOME}/.config/nvim" ]; then
        if ! mv -fv "${HOME}/.config/nvim" "${HOME}/.config/nvim.backup"; then
            echo "Failed to backup existing neovim configuration"
            exit 1
        fi
    fi

    # Install neovim and plugins
    if ! yay -S neovim pyright python-pynvim neovim-plug; then
        echo "Failed to install neovim and plugins"
        exit 1
    fi

    # Clone NvChad configuration
    if ! git clone https://github.com/NvChad/NvChad.git "${config_nvim}" --depth 1; then
        echo "Failed to clone NvChad configuration"
        exit 1
    fi

    # Change to the neovim configuration directory
    cd "${config_nvim}" || exit

    # Initialize neovim with the new configuration
    if ! nvim init.lua; then
        echo "Failed to initialize neovim with the new configuration"
        exit 1
    fi

    # Change back to the previous directory
    cd "${cwd}" || exit 2

    echo "neovim installation completed successfully"
}
