fpath=($fpath $HOME/.zsh/func)
typeset -U fpath
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

. "$HOME/.cargo/env"
