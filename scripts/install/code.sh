#!/usr/bin/env bash
# scripts/install/code.sh

source ./scripts/tools/confirm.sh
source ./scripts/tools/command.sh

# Developer Notes: 

# VSCode does NOT respect the users environmental mime-types and modifies them.

# This has undesirable and adverse side-effects as a result.

# Functions are included here to mitigate these issues.

# TODO: Come up with a better way of handling variable environments along with mime types for differing environments.
# Handling the defaults like this is fine for now, but will become an annoyance in the future.

# NOTE: Modify these env variables to suite your environment or clear them to enable prompting.
# DEFAULT_FILE_MANAGER="org.kde.dolphin.desktop" for dolphin on KDE
DEFAULT_FILE_MANAGER="org.gnome.Nautilus.desktop"
# NOTE: A lighter weight text editor is preferred in most cases which is why vscode is overridden.
# DEFAULT_TEXT_EDITOR="kate.desktop" for KDE
# DEFAULT_TEXT_EDITOR="code.desktop" for VSCode
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
