#!/usr/bin/env bash

# Function to confirm before proceeding with installation
confirm_proceed() {
    read -p "This will install $1 and may take some time. Are you sure? (y/n) " -n 1 -r
    echo    # move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installation of $1 cancelled."
        return 1
    fi
}
