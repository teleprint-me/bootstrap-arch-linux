#!/usr/bin/env bash

# Function to install Python development tools
install_python() {
    if ! sudo pacman -S python python-pip python-venv python-virtualenv python-black flake8 mypy -noconfirm; then
        echo "Failed to install python development packages"
        exit 1
    fi
    pip install --user --upgrade pipx
    pipx install poetry
}
