#!/usr/bin/env bash

# NEVER RUN THIS SCRIPT AS ROOT!!!
if [ $UID -eq 0 ]; then
    echo "This script should not be run as root. Please run it as a normal user."
    exit 1
fi

# Function to check if a file exists and is readable
check_file() {
    if [ ! -f "$1" ] || [ ! -r "$1" ]; then
        echo "File $1 does not exist or is not readable. Exiting."
        exit 1
    fi
}

main() {
    local source_tools="./scripts/tools"
    local source_install="./scripts/install"
    local source_setup="./scripts/setup"
    
    local scripts=(
        "${source_tools}/update.sh"
        "${source_install}/base.sh"
        "${source_install}/code.sh"
        "${source_install}/gnome.sh"
        "${source_install}/gpu.sh"
        "${source_install}/python_mlai.sh"
        "${source_install}/chrome.sh"
        "${source_install}/steam.sh"
        "${source_setup}/neovim.sh"
        "${source_setup}/nvm.sh"
        "${source_setup}/tmux.sh"
        "${source_setup}/yay.sh"
        "${source_setup}/zsh.sh"
    )

    # Source install scripts
    for script in "${scripts[@]}"; do
        check_file "$script"
        source "${script}"
    done

    echo "Please select an option:"

    local options=(
        "update: Update the base system"
        "base: Install C, C++, Rust, Lua, Node, Python, base tools, and fonts"
        "yay: Install and setup AUR package manager"
        "zsh: Install and setup Zsh installation"
        "tmux: Install and setup Tmux installation"
        "neovim: Install and setup NeoVim text editor"
        "nvm: Install and setup Node Version Manager"
        "intel: Install Intel GPU drivers, OpenCL, and Vulkan"
        "nvidia: Install Nvidia GPU drivers, OpenCL, Vulkan, and CUDA"
        "amd: Install AMD GPU drivers, OpenCL, Vulkan, and ROCm"
        "gnome: Install Gnome desktop environment and shell extensions"
        "code: Install Visual Studio Code text editor"
        "chrome: Install Google Chrome web browser"
        "spotify: Install Spotify music streaming client"
        "steam: Install Steam gaming platform"
        "quit: Exit the script"
    )

    select option in "${options[@]}"; do
        case $option in
            "update: Update the base system")
                pacman_system_update
                ;;
            "base: Install C, C++, Rust, Lua, Node, Python, base tools, and fonts")
                install_base
                ;;
            "yay: Install and setup AUR package manager")
                setup_yay
                ;;
            "zsh: Install and setup Zsh installation")
                setup_zsh
                ;;
            "tmux: Install and setup Tmux installation")
                setup_tmux
                ;;
            "neovim: Install and setup NeoVim text editor")
                setup_neovim
                ;;
            "nvm: Install and setup Node Version Manager")
                setup_nvm
                ;;
            "intel: Install Intel GPU drivers, OpenCL, and Vulkan")
                install_intel
                ;;
            "nvidia: Install Nvidia GPU drivers, OpenCL, Vulkan, and CUDA")
                install_nvidia
                ;;
            "amd: Install AMD GPU drivers, OpenCL, Vulkan, and ROCm")
                install_amd
                ;;
            "gnome: Install Gnome desktop environment and shell extensions")
                install_gnome
                ;;
            "code: Install Visual Studio Code text editor")
                install_vscode
                ;;
            "chrome: Install Google Chrome web browser")
                install_google_chrome
                ;;
            "spotify: Install Spotify music streaming client")
                install_spotify
                ;;
            "steam: Install Steam gaming platform")
                install_steam
                ;;
            "quit: Exit the script")
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
