#!/usr/bin/env bash

# NEVER RUN THIS SCRIPT AS ROOT!!!
if [ $UID -eq 0 ]; then
    echo "This script should not be run as root. Please run it as a normal user."
    exit 1
fi

# Check if a file exists and is readable
check_file() {
    if [ ! -f "$1" ] || [ ! -r "$1" ]; then
        echo "File $1 does not exist or is not readable. Exiting."
        exit 1
    fi
}

main() {
    local scripts=(
        "./scripts/tools/update.sh"
        "./scripts/install/base.sh"
        "./scripts/install/code.sh"
        "./scripts/install/fonts.sh"
        "./scripts/install/gnome.sh"
        "./scripts/install/gpu.sh"
        "./scripts/install/node.sh"
        "./scripts/install/python.sh"
        "./scripts/setup/neovim.sh"
        "./scripts/setup/nvm.sh"
        "./scripts/setup/steam.sh"
        "./scripts/setup/tmux.sh"
        "./scripts/setup/ufw.sh"
        "./scripts/setup/yay.sh"
        "./scripts/setup/zsh.sh"
    )

    # Source install scripts
    for script in "${scripts[@]}"; do
        check_file "$script"
        source "${script}"
    done

    echo "Please select an option:"

    local options=(
        "update"
        "base"
        "fonts"
        "python"
        "ufw"
        "yay"
        "node"
        "nvm"
        "zsh"
        "tmux"
        "neovim"
        "intel"
        "nvidia"
        "amd"
        "gnome"
        "code"
        "steam"
    )
    
    select option in "${options[@]}"; do
        case $option in
            "update")
                update_system
                ;;
            "base")
                install_base
                ;;
            "fonts")
                install_fonts
                ;;
            "python")
                install_python
                ;;
            "ufw")
                setup_ufw
                ;;
            "yay")
                setup_yay
                ;;
            "nvm")
                setup_nvm
                ;;
            "node")
                install_nodejs
                ;;
            "zsh")
                setup_zsh
                ;;
            "tmux")
                setup_tmux
                ;;
            "neovim")
                install_neovim
                ;;
            "intel")
                install_intel
                ;;
            "nvidia")
                install_nvidia
                ;;
            "amd")
                install_amd
                ;;
            "gnome")
                install_gnome
                ;;
            "code")
                install_vscode
                ;;
            "steam")
                install_steam
                ;;
            "quit")
                break
                ;;
            *)
                echo "Invalid option $REPLY"
                ;;
        esac
    done

    echo "Done."
}

main
