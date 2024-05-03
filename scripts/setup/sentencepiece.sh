#!/usr/bin/env bash

source ./scripts/tools/clone.sh
source ./scripts/tools/confirm.sh

declare -r SPM_NAME="sentencepiece"
declare -A SPM=( ["tmp"]="/tmp/${SPM_NAME}"
                 ["lib"]="/usr/local/lib/${SPM_NAME}"
                 ["inc"]="/usr/local/include/${SPM_NAME}"
                 ["url"]="https://github.com/${SPM_NAME}.git" )

function git_clone_sentencepiece() {
    git_clone_repo "${SPM['url']}" "${SPM['tmp']}"
}

function setup_sentencepiece() {
    confirm_proceed "SentencePiece" || return

    # Track current working directory
    local CWD="$PWD"  # Escape hatch! We'll need this later.

    # Check if sentencepiece is already installed
    if command -v spm_train &> /dev/null; then
        echo "${SPM_NAME} is already installed. Skipping installation."
        return 1
    else
        git_clone_sentencepiece || {
            echo "Failed to install ${SPM_NAME}"; 
            return 1; 
        }
    fi

    # Change to the sentencepiece directory
    # Note that using braces `{ }` is okay here
    if ! cd "${SPM['tmp']}"; then 
        return 1 
    fi

    # Note that A && B || C is not if-then-else. C may run when A is true.
    ## shellcheck [SC2015](https://www.shellcheck.net/wiki/SC2015)
    if ! mkdir build && cd build; then  # Make the build directory
        return 1
    fi

    # We need to build the Makefile
    if ! cmake ..; then 
        return 1
    fi

    # Build using make and use max cores to speed up compiliation
    if ! make -j "$(nproc)"; then
        echo "Error: Failed to build sentencepiece."
        # Attempt to return to current working directory and exit
        # Note that use of 'cd ... || exit' or 'cd ... || return' in case cd fails.
        ## shellcheck [SC2164](https://www.shellcheck.net/wiki/SC2164)
        cd - || return 2  # retreat to current working directory
        rm -rf "${SPM['tmp']}"  # attempt to clean up on the way out
        return 1  # Return to calling function
    fi

    # Attempt to clean up the underlying path
    # Note that it's okay if this fails because we use -f
    # e.g. the path doesn't exist for some reason.
    rm -rf src/CMakeFiles/ \
           src/cmake_install.cmake \
           src/Makefile

    # Create the global path
    if ! sudo mv -v src/ "${SPM['lib']}"; then
        return 1
    fi

    declare -a binaries=(
        "spm_decode"
        "spm_encode"
        "spm_export_vocab"
        "spm_normalize"
        "spm_train"
    )

    # Add the symbolic links to the binaries
    for binary in "${binaries[@]}"; do
        ln -s "${SPM['lib']}/${binary}" "/usr/local/bin/${binary}"
    done

    # Install headers
    cd .. || { echo "Failed to enter spm repo"; return 1; }
    sudo mkdir "${SPM['inc']}"
    sudo cp -v \
        src/sentencepiece_trainer.h \
        src/sentencepiece_processor.h \
        "${SPM['inc']}"

    # Change back to the working directory
    cd "${CWD}" || return 1

    # Clean up temporary files
    rm -rf "${SPM['tmp']}"

    echo "SentencePiece setup completed successfully"
}
