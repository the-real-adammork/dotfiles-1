fpath=($fpath $HOME/.zsh/func)
typeset -U fpath
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

#export BAT_CONFIG_PATH="/.dotfiles/homedir/.batconfig"
export BAT_THEME="Monokai Extended Light"
