#!/usr/bin/env bash

source ./scripts/tools/clone.sh
source ./scripts/tools/confirm.sh

SPM_TEMP_PATH="/tmp/sentencepiece"
SPM_LIB_PATH="/usr/local/lib/sentencepiece"
SPM_INC_PATH="/usr/local/include/sentencepiece"

function git_clone_sentencepiece() {
    git clone https://github.com/google/sentencepiece "${SPM_TEMP_PATH}"
}

function setup_sentencepiece() {
    confirm_proceed "SentencePiece" || return

    # Check if sentencepiece is already installed
    if command -v spm_train &> /dev/null; then
        echo "sentencepiece is already installed. Skipping installation."
        return 1
    else  # Download and install sentencepiece
        git_clone_sentencepiece || { 
            echo "Failed to install sentencepiece"; 
            return 1; 
        }
    fi

    # Change to the sentencepiece directory
    # Note that using braces `{ }` is okay here
    if ! cd ${SPM_TEMP_PATH}; then 
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
        rm -rf sentencepiece  # attempt to clean up on the way out
        return 1  # Return to calling function
    fi

    # Attempt to clean up the underlying path
    # Note that it's okay if this fails because we use -f
    # e.g. the path doesn't exist for some reason.
    rm -rf src/CMakeFiles/ \
           src/cmake_install.cmake \
           src/Makefile

    # Create the global path
    if ! sudo mv -v src/ "${SPM_LIB_PATH}"; then
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
        ln -s "${SPM_LIB_PATH}/${binary}" "/usr/local/bin/${binary}"
    done

    # Install headers
    cd .. || { echo "Failed to enter spm repo"; return 1; }
    sudo mkdir "${SPM_INC_PATH}"
    sudo cp -v \
        src/sentencepiece_trainer.h \
        src/sentencepiece_processor.h \
        "${SPM_INC_PATH}"

    # Change back to the previous directory
    cd - || return 1

    # Remove the yay directory
    rm -rf sentencepiece

    echo "SentencePiece setup completed successfully"
}
