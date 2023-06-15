#!/usr/bin/env bash

source ./scripts/tools/confirm.sh

# Function to install C, C++, Rust, Lua, and Base development tools
install_base_dev() {
    confirm_proceed "base-dev: Install C, C++, Rust, Lua, Node, and base development tools" || return

    if ! sudo pacman -S base-devel llvm clang rust gdb make cmake ninja lua nodejs aspell hunspell shellcheck mlocate tree htop nmap curl wget openssl openssh gnupg imagemagick ffmpegthumbs ffmpegthumbnailer xclip wl-clipboard --noconfirm; then
        echo "Failed to install core system packages"
        exit 1
    fi
}

# Function to install Python development tools
install_base_dev_python() {
    confirm_proceed "base-dev-python: Install core python development packages" || return

    if ! sudo pacman -S python-pip python-pytest python-pipx python-virtualenv python-isort python-black flake8 ruff mypy --noconfirm; then
        echo "Failed to install python development packages"
        exit 1
    fi
}

# Function to install fonts
install_base_dev_fonts() {
    confirm_proceed "base-dev-fonts: Install Adobe, Nerd, and Noto fonts" || return

    if ! sudo pacman -S adobe-source-code-pro-fonts ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols-mono noto-fonts noto-fonts-extra noto-fonts-emoji ttf-noto-nerd --noconfirm; then
        echo "Failed to install core system fonts"
        exit 1
    fi

    if ! sudo cp -vi "dotfiles/etc/fonts/conf.d/50-noto-color-emoji.conf" "/etc/fonts/conf.d"; then
        echo "Failed to install 50-noto-color-emoji.conf to /etc/fonts/conf.d"
        exit 1
    fi
}

# Function to setup firewall rules
install_base_dev_firewall() {
    confirm_proceed "base-dev-firewall: Install and setup UFW" || return

    # Install ufw if it's not already installed
    if ! command -v ufw &> /dev/null; then
        if ! sudo pacman -S ufw ufw-extras --noconfirm; then
            echo "Failed to install ufw"
            exit 1
        fi
    fi

    if ! sudo systemctl enable ufw; then
        echo "Failed to enable ufw using systemd"
    fi

    # Enable ufw
    if ! sudo ufw enable; then
        echo "Failed to enable ufw"
        exit 1
    fi

    # Define an array of firewall rules
    local rules=(
        http            # HTTP traffic (Steam login and content download)
        https           # HTTPS traffic (Steam login and content download)
        ssh             # SSH traffic
        sftp            # SFTP traffic
        # 51413/udp       # UDP traffic on port 51413 (BitTorrent clients)
        # 9050/tcp        # TCP traffic on port 9050 (Tor SOCKS proxy)
        # 27000:27015/udp # UDP traffic on ports 27000 to 27015 (Steam game servers)
        # 27015:27030/udp # UDP traffic on ports 27015 to 27030 (Steam game servers)
        # 27014:27050/tcp # TCP traffic on ports 27014 to 27050 (Steam game servers)
        # 4380/udp        # UDP traffic on port 4380 (In-Home Streaming and Voice Chat)
        # 27015/tcp       # TCP traffic on port 27015 (Remote Play and SRCDS Rcon port)
        # 3478/udp        # UDP traffic on port 3478 (Steamworks P2P Networking and Voice Chat)
        # 4379/udp        # UDP traffic on port 4379 (Steamworks P2P Networking and Voice Chat)
    )

    # Apply each firewall rule
    for rule in "${rules[@]}"; do
        if ! sudo ufw allow "$rule"; then
            echo "Failed to apply firewall rule: $rule"
            return 1
        fi
    done

    if ! sudo systemctl start ufw; then
        echo "Failed to start ufw using systemd"
    fi

    # Reload ufw
    if ! sudo ufw reload; then
        echo "Failed to reload ufw"
        return 1
    fi

    echo "Firewall setup completed successfully"
}

install_base() {
    install_base_dev
    install_base_dev_python
    install_base_dev_fonts
    install_base_dev_firewall
}
