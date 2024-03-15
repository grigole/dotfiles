HISTFILE=$ZDOTDIR/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -v

zstyle :compinstall filename '$ZDOTDIR/.zshrc'

# Use cache for slow bits
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZDOTDIR/.zshcache

autoload -Uz compinit && compinit

setopt ignoreeof
setopt prompt_subst
setopt beep extendedglob nomatch
setopt hist_verify
setopt sharehistory

unsetopt autocd notify

# You need this to get a menu.
zstyle ':completion:*' menu select=2

# Necessary for colours in prompts
autoload -Uz colors && colors

# Make sure all non-printing escape codes are inside %{%} pairs. If
# you don't, zsh loses track of the visible prompt length and doing
# completopns shifts the ZLE line to the right, which is f**ing
# annoying!
PS1="%{${fg_bold[green]}%}%n@%m %{${fg_bold[blue]}%}%3~ %(!.#.$) %{$reset_color%}"

alias gemacs='/usr/bin/emacs'
alias emacs='emacs -nw'

alias emacsima='gemacs -f imaxima'

alias df='df -h'
alias du='du -sh'

alias h='history 0'

alias ls='ls --color=auto -F'
alias ll='ls -l'
alias la='ls -A'

alias more='less'

alias vi='nvim'

source $ZDOTDIR/.zshrc_nav
source $ZDOTDIR/.zshrc_tmux

if ! [[ $PATH =~ "/home/grigole/bin" ]]; then PATH="/home/grigole/bin:$PATH"; fi
if ! [[ $PATH =~ "/opt/vbcc/bin" ]]; then PATH="/opt/vbcc/bin:$PATH"; fi
if ! [[ $PATH =~ "/home/grigole/.cargo/bin" ]]; then PATH="/home/grigole/.cargo/bin:$PATH"; fi

# For VBCC Amgia cross-compiler
# - Feb 19 2020 - Greg Rigole
export VBCC=/opt/vbcc

export EDITOR=/usr/bin/nvim

export CC65_HOME="/usr/local/share/cc65"

if ! [[ $PATH =~ "/home/grigole/perl5/bin" ]]; then PATH="/home/grigole/perl5/bin:$PATH"; fi

export PATH

PERL5LIB="/home/grigole/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/grigole/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/grigole/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/grigole/perl5"; export PERL_MM_OPT;

# For netbeans
export netbeans_jdkhome=$JDK_HOME

# For running xdg-ninja
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
source ~/.cargo/env

source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh

eval "$(zoxide init zsh --cmd cd)"
