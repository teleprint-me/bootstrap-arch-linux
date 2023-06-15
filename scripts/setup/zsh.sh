#!/usr/bin/env bash

source ./scripts/tools/confirm.sh

setup_zsh() {
    confirm_proceed "Zsh" || return

    local zpath=/usr/share/zsh/plugins
    local ohmyz=/usr/share/oh-my-zsh/custom/plugins
    local ztheme=/usr/share/oh-my-zsh/themes

    # Install zsh and plugins
    if ! yay -S zsh antigen-git oh-my-zsh-git zsh-autosuggestions-git zsh-syntax-highlighting-git zsh-completions-git; then
        echo "Failed to install zsh and plugins"
        return 1
    fi

    # Clone zsh-completions repository
    if ! sudo git clone "https://github.com/zsh-users/zsh-completions.git" "${zpath}/zsh-completions"; then
        echo "Failed to clone zsh-completions repository"
        return 1
    fi

    # Create destination directory if it doesn't exist
    if [ ! -d "${ohmyz}" ]; then
        if ! sudo mkdir -p "${ohmyz}"; then
            echo "Failed to create directory: ${ohmyz}"
            return 1
        fi
    fi

    # Create symbolic links for oh-my-zsh recognition
    if ! sudo ln -sv "${zpath}/zsh-autosuggestions" "${ohmyz}/zsh-autosuggestions"; then
        echo "Failed to create symbolic link for zsh-autosuggestions"
        return 1
    fi
    if ! sudo ln -sv "${zpath}/zsh-syntax-highlighting" "${ohmyz}/zsh-syntax-highlighting"; then
        echo "Failed to create symbolic link for zsh-syntax-highlighting"
        return 1
    fi
    if ! sudo ln -sv "${zpath}/zsh-completions" "${ohmyz}/zsh-completions"; then
        echo "Failed to create symbolic link for zsh-completions"
        return 1
    fi

    if ! sudo cp -vi dotfiles/usr/share/oh-my-zsh/themes/lambda-o.zsh-theme "${ztheme}/lambda-o.zsh-theme"; then
        echo "Failed to copy lambda-o.zsh-theme to ${ztheme}"
        return 1
    fi

    if ! cp -vi dotfiles/zshrc "${HOME}/.zshrc"; then
        echo "Failed to copy .zshrc to ${HOME}"
        return 1
    fi

    # Change the default shell
    if ! chsh -s "$(command -v zsh)"; then
        echo "Failed to change the default shell to zsh"
        return 1
    fi

    echo "zsh installation completed successfully"
}
