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
    local branch_prefix=""
    
    if [[ "$(git status --porcelain 2>/dev/null)" != "" ]]; then
        # Changes detected, color branch name red
        branch_prefix="%{$fg[red]%}Δ%{$reset_color%}"
    elif git status | grep 'renamed:' &>/dev/null; then
        # The branch is being renamed
        branch_prefix="%{$fg[yellow]%}ρ%{$reset_color%}"
    else
        # No changes detected, color branch name green
        branch_prefix="%{$fg[green]%}θ%{$reset_color%}"
    fi

    echo "%{$fg[cyan]%}git:(%{$fg[blue]%}$branch | $branch_prefix%{$fg[cyan]%})"
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
