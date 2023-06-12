#!/usr/bin/env bash

# Function to clone a git repository
git_clone_repo() {
    repo_url=$1
    target_dir=$2

    # Check if the target directory exists
    if [ -d "${target_dir}" ]; then
        echo "Target directory ${target_dir} already exists. Skipping clone."
    else
        # Clone the repository
        if ! git clone "${repo_url}" "${target_dir}"; then
            echo "Failed to clone ${repo_url}"
            exit 1
        fi
        echo "Successfully cloned ${repo_url}"
    fi
}
