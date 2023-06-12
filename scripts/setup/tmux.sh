#!/usr/bin/env bash

setup_tmux() {
    # Install tmux
    if ! sudo pacman -S tmux -y; then
        echo "Failed to install tmux"
        exit 1
    fi

    # Clone tmux plugin manager
    if ! git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; then
        echo "Failed to clone tmux plugin manager"
        exit 1
    fi

    # Write configuration to .tmux.conf
    cat << _EOF_ > ~/.tmux.conf
# Set default shell
set-option -g default-shell /usr/bin/zsh

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'github_username/plugin_name#branch'
# set -g @plugin 'git@github.com:user/plugin'
# set -g @plugin 'git@bitbucket.com:user/plugin'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
_EOF_

    # Check if .tmux.conf was written successfully
    if [ $? -ne 0 ]; then
        echo "Failed to write to .tmux.conf"
        exit 1
    fi

    echo "tmux setup completed successfully"
}
