export ZDOTDIR=$HOME/.config/zsh
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
