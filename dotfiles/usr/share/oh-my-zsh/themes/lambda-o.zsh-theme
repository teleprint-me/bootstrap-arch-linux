# /usr/share/oh-my-zsh/themes/lambda-o.zsh-theme

# Developer Notes:
#
# docs: http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
#
# precmd is a special function in Zsh that is automatically executed before each command prompt. 
# It's one of several "hook" functions that Zsh provides to allow you to customize the behavior of your shell.
#

function precmd {
    # Extract venv name from $VIRTUAL_ENV
    local venv_name=""

    if [[ -n "$VIRTUAL_ENV" ]]; then
        # The :t modifier in ${VIRTUAL_ENV:t} is a zsh parameter expansion that returns the tail of the string.
        # i.e., the part after the last slash, which is the name of the venv.
        venv_name="(${VIRTUAL_ENV:t})"
    fi

    # Include venv name in PROMPT with color
    #   %B and %b turn bold text on and off.
    #   %F{color} and %f set the foreground color and reset it.
    PROMPT='%B%D{%H:%M:%S}%b | %F{cyan}%~%f
'$venv_name' $(git_prompt_info)%{$reset_color%}λ '
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
