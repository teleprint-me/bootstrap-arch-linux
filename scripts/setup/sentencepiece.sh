#!/usr/bin/env bash

source ./scripts/tools/confirm.sh

setup_sentencepiece() {
    confirm_proceed "SentencePiece" || return

    # Check if yay is already installed
    if command -v spm_train &> /dev/null; then
        echo "sentencepiece is already installed"
        return 0
    fi

    # Clone the yay repository
    if ! git clone https://github.com/google/sentencepiece; then
        echo "Failed to clone sentencepiece repository"
        return 1
    fi

    # Change to the yay directory
    cd sentencepiece || return 1
    mkdir build && cd build || return 1
    cmake .. || return 1

    # Build and install yay
    if ! make -j "$(nproc)"; then
        echo "Failed to build sentencepiece"
        return 1
    fi

    # Clean up the underlying path
    rm -rf cpp/sentencepiece/CMakeFiles cpp/sentencepiece/cmake_install.cmake cpp/sentencepiece/Makefile
    # Move the binaries and shared objects to global environment
    sudo cp -r src /usr/local/bin  # NOTE: This isn't right and needs to be fixed

    # Change back to the previous directory
    cd - || return 1

    # Remove the yay directory
    rm -rf sentencepiece

    echo "SentencePiece setup completed successfully"
}
