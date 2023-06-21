#!/usr/bin/env bash
# scripts/install/code.sh

source ./scripts/tools/confirm.sh
source ./scripts/tools/command.sh

# Developer Notes: 

# VSCode does not respect the user's environmental MIME types and modifies them.

# This can lead to undesirable and adverse side effects.

# Functions are included here to mitigate these issues.

# TODO: Identify an improved approach to manage variable desktop environments and MIME types for different scenarios.
# The current method of handling defaults is adequate at present, but it may pose challenges in the future.

# NOTE: Modify these environment variables to suit your needs or clear them to enable prompting.
# Example: DEFAULT_FILE_MANAGER="org.kde.dolphin.desktop" for Dolphin on KDE
DEFAULT_FILE_MANAGER="org.gnome.Nautilus.desktop"
# Example: DEFAULT_TEXT_EDITOR="kate.desktop" for Kate on KDE
# Example: DEFAULT_TEXT_EDITOR="code.desktop" for Visual Studio Code
DEFAULT_TEXT_EDITOR="nvim.desktop"

reset_inode_mime_types() {
    local default_mime_type

    if [ -z "$DEFAULT_FILE_MANAGER" ]; then
        echo "Please enter the name of your preferred file manager:"
        read -r DEFAULT_FILE_MANAGER
    fi

    default_mime_type="$(xdg-mime query filetype ~)"

    if ! xdg-mime default "${DEFAULT_FILE_MANAGER}" "${default_mime_type}"; then
        echo "Failed to reset default MIME type for directories"
        return 1
    fi

    echo "XDG Inode MIME types successfully restored"
}

reset_text_mime_types() {
    local default_mime_type

    if [ -z "$DEFAULT_TEXT_EDITOR" ]; then
        echo "Please enter the name of your preferred text editor:"
        read -r DEFAULT_TEXT_EDITOR
    fi

    default_mime_type="$(xdg-mime query filetype ~/.bashrc)"

    if ! xdg-mime default "${DEFAULT_TEXT_EDITOR}" "${default_mime_type}"; then
        echo "Failed to set ${DEFAULT_TEXT_EDITOR} as the default text editor"
        return 1
    fi

    echo "XDG Text MIME types successfully restored"
}

reset_vscode_mime_types() {
    # Check if xdg-mime exists
    check_command "xdg-mime" || return 1

    reset_inode_mime_types
    reset_text_mime_types
}

install_vscode() {
    confirm_proceed "Visual Studio Code" || return

    if ! yay -S visual-studio-code-bin --noconfirm; then
        echo "Failed to install Visual Studio Code"
        return 1
    fi

    reset_vscode_mime_types || return 1

    echo "Visual Studio Code installed successfully"
}
