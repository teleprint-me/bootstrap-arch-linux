# /usr/share/oh-my-zsh/themes/lambda-o.zsh-theme

# Developer Notes:
#
# docs: http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
#
# precmd is a special function in Zsh that is automatically executed before each command prompt. 
# It's one of several "hook" functions that Zsh provides to allow you to customize the behavior of your shell.
#

function git_prompt_custom {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        return
    fi
    local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [[ "$(git status --porcelain 2>/dev/null)" != "" ]]; then
        # Changes detected, color branch name red
        echo "%{$fg[cyan]%}git:(%{$fg[red]%}$branch | ✗%{$fg[cyan]%})"
    else
        # No changes detected, color branch name green
        echo "%{$fg[cyan]%}git:(%{$fg[green]%}$branch | 🗸%{$fg[cyan]%})"
    fi
}

function precmd {
    # Extract venv name from $VIRTUAL_ENV
    local venv_name=""
    if [[ -n "$VIRTUAL_ENV" ]]; then
        venv_name="(${VIRTUAL_ENV:t})"
    fi

    # Include venv name in PROMPT with color
    PROMPT="%F{cyan}%D{%H:%M:%S}%f | %F{cyan}%~%f
${venv_name} $(git_prompt_custom) %{$reset_color%}%(?:λ :%B%{$fg_bold[red]%}λ%b )%f"
}
