#!/usr/bin/env bash

source ./scripts/tools/clone.sh
source ./scripts/tools/confirm.sh

git_clone_nvchad() {
    git_clone_repo "https://github.com/NvChad/NvChad.git" "${HOME}/.config/nvim"
}

git_clone_neovim_python() {
    git_clone_repo "https://github.com/dreamsofcode-io/neovim-python.git" "${HOME}/.config/nvim/lua/custom"
}

setup_neovim() {
    confirm_proceed "NeoVim, NvChad, and NeoVim-Python" || return

    local cwd="${PWD}"
    local config_nvim="${HOME}/.config/nvim"
    local config_custom="${HOME}/.config/nvim/lua/custom"

    # Remove old neovim cache and backup directories
    if ! rm -rfv "${HOME}/.cache/nvim" "${HOME}/.local/share/nvim" "${HOME}/.config/nvim.backup"; then
        echo "Failed to remove old neovim directories"
        return 1
    fi

    # Backup existing neovim configuration
    if [ -d "${HOME}/.config/nvim" ]; then
        if ! mv -fv "${HOME}/.config/nvim" "${HOME}/.config/nvim.backup"; then
            echo "Failed to backup existing neovim configuration"
            return 1
        fi
    fi

    # Install neovim and plugins
    if ! yay -S neovim neovim-plug pyright python-pynvim; then
        echo "Failed to install neovim and plugins"
        return 1
    fi

    # Clone NvChad configuration
    git_clone_nvchad || return 1

    # Change to the neovim configuration directory
    cd "${config_nvim}" || { echo "Failed to change directory to ${config_nvim}"; return 1; }

    # Initialize neovim with the new configuration
    if ! nvim init.lua; then
        echo "Failed to initialize neovim with the new configuration"
        return 1
    fi

    # Change back to the previous directory
    cd "${cwd}" || { echo "Failed to change directory to ${cwd}"; return 1; }

    # Backup nvchad custom template
    # Prevents "fatal: destination path" from occurring with neovim-python install
    if ! mv -fv "${config_custom}" "${config_custom}.backup"; then
        echo "Failed to backup neovims custom lua path"
        return 1
    fi

    # Configure and setup neovim to handle python out of the box
    git_clone_neovim_python || return 1

    echo "Neovim setup completed successfully"
}
