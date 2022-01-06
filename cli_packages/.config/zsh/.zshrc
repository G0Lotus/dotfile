#!/usr/bin/env zsh

# source core file
for file ($(ls ${ZDOTDIR}/core)) {
    source "${ZDOTDIR}/core/${file}"
}

zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

#zsh_apply_theme
eval "$(starship init zsh)"

if type neofetch &> /dev/null; then
    neofetch
fi


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/hkkk/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/hkkk/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/hkkk/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/hkkk/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

