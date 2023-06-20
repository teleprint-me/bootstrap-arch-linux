#!/usr/bin/env bash

# Function to confirm before proceeding with installation or removal
confirm_proceed() {
    local operation="install"
    if [[ $2 == "remove" ]]; then
        operation="remove"
    fi

    read -p "This will ${operation} $1 and may take some time. Are you sure? (y/n) " -n 1 -r
    echo    # move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo "${operation^}ation of $1 cancelled."
        return 1
    fi
}
