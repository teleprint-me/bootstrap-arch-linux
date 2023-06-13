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
        "${source_tools}/confirm.sh"
        "${source_install}/base.sh"
        "${source_install}/code.sh"
        "${source_install}/fonts.sh"
        "${source_install}/gnome.sh"
        "${source_install}/gpu.sh"
        "${source_install}/node.sh"
        "${source_install}/python.sh"
        "${source_setup}/neovim.sh"
        "${source_setup}/nvm.sh"
        "${source_setup}/steam.sh"
        "${source_setup}/tmux.sh"
        "${source_setup}/ufw.sh"
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
        "base: Install C, C++, Rust, Lua, and base development tools"
        "fonts: Install Adobe, Nerd, and Noto fonts"
        "python: Install core python development packages"
        "ufw: Install and setup Uncomplicated Firewall"
        "yay: Install and setup AUR package manager"
        "node: Install Node.js"
        "nvm: Install and setup Node Version Manager"
        "zsh: Install and setup Zsh installation"
        "tmux: Install and setup Tmux installation"
        "neovim: Install and setup NeoVim text editor"
        "intel: Install Intel GPU drivers, OpenCL, and Vulkan"
        "nvidia: Install Nvidia GPU drivers, OpenCL, Vulkan, and CUDA"
        "amd: Install AMD GPU drivers, OpenCL, Vulkan, and ROCm"
        "gnome: Install Gnome desktop environment and shell extensions"
        "code: Install Visual Studio Code text editor"
        "steam: Install Steam gaming platform"
        "quit: Exit the script"
    )
    
    select option in "${options[@]}"; do
        case $option in
            "update: Update the base system")
                confirm_proceed "base system update" && pacman_system_update
                ;;
            "base: Install C, C++, Rust, Lua, and base development tools")
                confirm_proceed "base system" && install_base
                ;;
            "fonts: Install Adobe, Nerd, and Noto fonts")
                confirm_proceed "fonts" && install_fonts
                ;;
            "python: Install core python development packages")
                confirm_proceed "Python" && install_python
                ;;
            "ufw: Install and setup Uncomplicated Firewall")
                confirm_proceed "UFW" && setup_ufw
                ;;
            "yay: Install and setup AUR package manager")
                confirm_proceed "Yay" && setup_yay
                ;;
            "node: Install Node.js")
                confirm_proceed "Node.js" && install_nodejs
                ;;
            "nvm: Install and setup Node Version Manager")
                confirm_proceed "Node Version Manager" && setup_nvm
                ;;
            "zsh: Install and setup Zsh installation")
                confirm_proceed "Zsh" && setup_zsh
                ;;
            "tmux: Install and setup Tmux installation")
                confirm_proceed "Tmux" && setup_tmux
                ;;
            "neovim: Install and setup NeoVim text editor")
                setup_neovim
                ;;
            "intel: Install Intel GPU drivers, OpenCL, and Vulkan")
                confirm_proceed "Intel drivers" && install_intel
                ;;
            "nvidia: Install Nvidia GPU drivers, OpenCL, Vulkan, and CUDA")
                confirm_proceed "Nvidia drivers" && install_nvidia
                ;;
            "amd: Install AMD GPU drivers, OpenCL, Vulkan, and ROCm")
                confirm_proceed "AMD drivers" && install_amd
                ;;
            "gnome: Install Gnome desktop environment and shell extensions")
                confirm_proceed "Gnome desktop and shell extensions" && install_gnome
                ;;
            "code: Install Visual Studio Code text editor")
                confirm_proceed "Visual Studio Code" && install_vscode
                ;;
            "steam: Install Steam gaming platform")
                confirm_proceed "Steam" && install_steam
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
