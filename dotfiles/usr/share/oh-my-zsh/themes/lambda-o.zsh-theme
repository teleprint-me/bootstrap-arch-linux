# /usr/share/oh-my-zsh/themes/lambda-o.zsh-theme

# Developer Notes:

# precmd is a special function in Zsh that is automatically executed before each command prompt. It's one of several "hook" functions that Zsh provides to allow you to customize the behavior of your shell. 

# The :t modifier in ${VIRTUAL_ENV:t} is a zsh parameter expansion that returns the tail of the string, i.e., the part after the last slash, which is the name of the venv.

function precmd {
  # Extract venv name from $VIRTUAL_ENV
  local venv_name=""
  if [[ -n "$VIRTUAL_ENV" ]]; then
    venv_name="(${VIRTUAL_ENV:t})"
  fi

  # Include venv name in PROMPT
  PROMPT='%D{%H:%M:%S} | %~
'$venv_name' $(git_prompt_info)%{$reset_color%}λ '
}

PROMPT='%D{%H:%M:%S} | %~
$(git_prompt_info)%{$reset_color%}λ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
