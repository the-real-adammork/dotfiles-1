# Performance Logging
#zmodload zsh/zprof
#zmodload zsh/datetime
#setopt PROMPT_SUBST
#PS4='+$EPOCHREALTIME %N:%i> '
#logfile=$(mktemp ~/zsh_profile.XXXXXXXX)
#echo "Logging to $logfile"
#exec 3>&2 2>$logfile
#setopt XTRACE

# change

# Path to your oh-my-zsh configuration.
export TERM="xterm-256color"
export ZSH=$HOME/.dotfiles/oh-my-zsh
# if you want to use this, change your non-ascii font to Droid Sans Mono for Awesome
# POWERLEVEL9K_MODE='awesome-patched'
export ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_COLOR_SCHEME='light'
# export ZSH_THEME="agnoster"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
# https://github.com/bhilburn/powerlevel9k#customizing-prompt-segments
# https://github.com/bhilburn/powerlevel9k/wiki/Stylizing-Your-Prompt

vimode(){
    echo $(vi_mode_prompt_info)
}

POWERLEVEL9K_CUSTOM_VIMODE="vimode"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vcs custom_vimode newline dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time)
# colorcode test
#
textcolortest() { for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"}

POWERLEVEL9K_NVM_FOREGROUND='000'
POWERLEVEL9K_NVM_BACKGROUND='072'
POWERLEVEL9K_SHOW_CHANGESET=true
#export ZSH_THEME="random"

# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"

# disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT=true

# disable colors in ls
export DISABLE_LS_COLORS="true"

# disable autosetting terminal title.
export DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.dotfiles/oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
#

export ZSH_DISABLE_COMPFIX="true"

plugins=(z colorize compleat dirpersist autojump gulp history cp zsh-autosuggestions history-substring-search  zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Default the shell to global history, local history can be accessed with keyboard toggle
#_per-directory-history-set-global-history

# Customize to your needs...
unsetopt correct

# run fortune on new terminal :)
# fortune

# Erase when we get vim.obsession installed, also need to install tmux-resurrect
#vim () {
#    if [ -f 'Session.vim' ] && [ $# -eq 0 ]; then
#        command $vim -S Session.vim
#    else
#        command $vim "$@"
#    fi
#}

function fgr {
   fgrep -r -n $@ .
}

export NVM_DIR="$HOME/.nvm"

# NVM autoload stuff below, nvmi function should do this if not make this below into a function. doing it on every load
# is too slow
#
nvmload() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  autoload -U add-zsh-hook
  load-nvmrc() {
    if [[ -f .nvmrc && -r .nvmrc ]]; then
      nvm use &> /dev/null
    elif [[ $(nvm version) != $(nvm version default)  ]]; then
      nvm use default &> /dev/null
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
}
#nvmload

HISTFILESIZE=10000000

# fhr - Add a history repeat search using fzf, runs the command
#fhr() {
  #eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
#}

## fh - repeat history edit, drops the command into command line !
#writecmd (){ perl -e 'ioctl STDOUT, 0x5412, $_ for split //, do{ chomp($_ = <>); $_ }' ; }

#fh() {
  #([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -re 's/^\s*[0-9]+\s*//' | writecmd
#}

# Add aliases and convenience calls for - fasd
#eval "$(fasd --init auto)"
#alias v='f -e vim'  quick opening files with vim

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init -)"

# SCM Breeze
[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"


export RBENV_ROOT=/usr/local/var/rbenv
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(rbenv init -)"

[ -s "/Users/adam/.scm_breeze/scm_breeze.sh" ] && source "/Users/adam/.scm_breeze/scm_breeze.sh"

#
#
#
#
#
#       VIM Editing Mode
#
#
#
#
#

bindkey -v

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1


# `v` is already mapped to visual mode, so we need to use a different key to
# open Vim
bindkey -M vicmd "^V" edit-command-line

export EDITOR='vim'

# Updates editor information when the keymap changes.
#function zle-keymap-select() {
  #zle reset-prompt
  #zle -R
#}

#zle -N zle-keymap-select


function zle-keymap-select zle-line-init
{
    # change cursor shape in iTerm2
    case $KEYMAP in
        vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
        viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
    esac

    zle reset-prompt
    zle -R
}

function zle-line-finish
{
    print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

bindkey -v '^?' backward-delete-char

# Hardcode the fzf-history-widget binding to work in -v (vi insert) and -a (vi normal) modes.
bindkey -v '^r' fzf-history-widget
bindkey -a '^r' fzf-history-widget

# Hardcode the fzf-cd-widget binding to work in -v (vi insert) and -a (vi normal) modes.
# bindkey -v '^t' fzf-cd-widget
# bindkey -a '^t' fzf-cd-widget

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/% NORMAL }/(main|viins)/% INSERT %}"
}

# define right prompt, regardless of whether the theme defined it
#RPS1='$(vi_mode_prompt_info)'
#RPS2=$RPS1

# Bat config
#
export BAT_CONFIG_PATH="/Users/adam/.dotfiles/homedir"


#
#
#
#
#
#       Performance
#
#
#

# dir env, move later
eval "$(direnv hook zsh)"

# chnode, move later
eval "$(rbenv init -)"


export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

source /usr/local/opt/chnode/share/chnode/chnode.sh

# Performance Logging
#unsetopt XTRAC#E
#exec 2>&3 3>&-
#zprof
