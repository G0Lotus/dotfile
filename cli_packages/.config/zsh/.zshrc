#!/usr/bin/env zsh

# source core file
for file ($(ls ${ZDOTDIR}/core)) {
    source "${ZDOTDIR}/core/${file}"
}

zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "Aloxaf/fzf-tab"

#zsh_apply_theme
which starship &> /dev/null
if [ $? -ne 0 ]; then
	curl -sS https://starship.rs/install.sh | sh
fi
eval "$(starship init zsh)"

if type neofetch &> /dev/null; then
    neofetch
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
