#!/usr/bin/env bash

# Function to setup firewall rules
setup_ufw() {
    # Install ufw if it's not already installed
    if ! command -v ufw &> /dev/null; then
        if ! sudo pacman -S ufw -y; then
            echo "Failed to install ufw"
            exit 1
        fi
    fi

    # Enable ufw
    if ! sudo ufw enable; then
        echo "Failed to enable ufw"
        exit 1
    fi

    # Define an array of firewall rules
    local rules=(
        http
        https
        ssh
        sftp
        51413/udp
        27000:27015/udp
        27015:27030/udp
        27014:27050/tcp
        4380/udp
        27015/tcp
        3478/udp
        4379/udp
        9050/tcp
    )

    # Apply each firewall rule
    for rule in "${rules[@]}"; do
        if ! sudo ufw allow "$rule"; then
            echo "Failed to apply firewall rule: $rule"
            exit 1
        fi
    done

    # Reload ufw
    if ! sudo ufw reload; then
        echo "Failed to reload ufw"
        exit 1
    fi

    echo "Firewall setup completed successfully"
}
