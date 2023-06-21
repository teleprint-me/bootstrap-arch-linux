#!/usr/bin/env bash
# scripts/tools/command.sh

# Function to check if command exists
check_command() {
    if ! command -v "${1}" &> /dev/null; then
        echo "${1} could not be found. Aborting."
        return 1
    fi
}
