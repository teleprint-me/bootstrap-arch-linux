#!/usr/bin/env bash

source ./scripts/tools/confirm.sh

install_python_poetry() {
    confirm_proceed "Poetry" || return

    if ! pipx install poetry; then
        echo "Failed to install poetry"
        exit 1
    fi

    if ! poetry config virtualenvs.in-project true; then
        echo "Failed to scope virtualenv to project directory"
        exit 1
    fi
}
