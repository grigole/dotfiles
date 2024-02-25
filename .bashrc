shopt -s -o ignoreeof

alias gemacs='/usr/bin/emacs'
alias emacs='emacs -nw'

alias emacsima='gemacs -f imaxima'

alias df='df -h'
alias du='du -sh'

alias h='history'

alias ls='ls --color=auto -F'
alias ll='ls -l'
alias la='ls -A'

alias more='less'

alias vi='nvim'

# Navigation
. ~/.bashrc_nav

# Tmux stuff
. ~/.bashrc_tmux

if ! [[ $PATH =~ "~/bin" ]]; then PATH="~/bin:$PATH"; fi
if ! [[ $PATH =~ "/opt/vbcc/bin" ]]; then PATH="$PATH:/opt/vbcc/bin"; fi
if ! [[ $PATH =~ "/home/grigole/.cargo/bin" ]]; then PATH="/home/grigole/.cargo/bin:$PATH"; fi

# For VBCC Amgia cross-compiler
# - Feb 19 2020 - Greg Rigole
export VBCC=/opt/vbcc

export IGNOREEOF

export PROMPT_DIRTRIM=2

export EDITOR=/usr/bin/nvim

# Enable completition
source /etc/bash/bashrc.d/bash_completion.sh

export CC65_HOME="/usr/local/share/cc65"

PATH="/home/grigole/perl5/bin${PATH:+:${PATH}}"; export PATH;
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
. "$HOME/.cargo/env"

eval "$(zoxide init bash --cmd cd)"
