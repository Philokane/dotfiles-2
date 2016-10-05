# update Bash version
#
# brew install bash;
# echo /usr/local/bin/bash | sudo tee -a /etc/shells
# chsh -s /usr/local/bin/bash
#
# with mac osx remember to add the following to your ~/.bash_profile
#
# if [ -f $HOME/.bashrc ]; then
#   source ~/.bashrc
#   cd .
# fi
#
# if [ -f $(brew --prefix)/etc/bash_completion ]; then
#   source $(brew --prefix)/etc/bash_completion
# fi
#
# also create an .inputrc with the following content
#
# TAB: menu-complete
# "\e[Z": "\e-1\C-i"
#
# this allows you to use <C-n> and <C-p> to tab through the ambigious cd suggestions

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source ~/.git-prompt.sh

# https://github.com/jarun/googler/blob/master/auto-completion/bash/googler-completion.bash
source ~/googler-completion.bash

# tells Readline to perform filename completion in a case-insensitive fashion
bind "set completion-ignore-case on"

# filename matching during completion will treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# will get Readline to display all possible matches for an ambiguous pattern at the first <Tab> press instead of at the second
bind "set show-all-if-ambiguous on"

# no bell sound on error
bind "set bell-style none"

# enable vi like bindings (http://blog.sanctum.geek.nz/vi-mode-in-bash/)
#set -o vi

# enable emacs like bindings (<C-a> and <C-e> for start and end of line shortcuts)
set -o emacs

# append to the history file, don't overwrite it
shopt -s histappend

# save multi-line commands as one command
shopt -s cmdhist

# shopt -p
# will show all available settings

# no need to type cd (works for .. but not -, although alias -- -='cd -' fixes it)
shopt -s autocd 2>/dev/null

# autocorrect minor spelling errors
shopt -s dirspell 2>/dev/null
shopt -s cdspell 2>/dev/null

# check windows size if windows is resized
shopt -s checkwinsize 2>/dev/null

# use extra globing features. See man bash, search extglob.
shopt -s extglob 2>/dev/null

# include .files when globbing.
shopt -s dotglob 2>/dev/null

# specify other paths to look inside of when autocompleting
CDPATH=".:~/Projects"

# custom environment variables
export DROPBOX="$HOME/Dropbox"
export GITHUB_USER="integralist"

# application configuration
export GOOGLER_COLORS=bjdxxy # https://github.com/jarun/googler/
export LSCOLORS="dxfxcxdxbxegedabagacad" # http://geoff.greer.fm/lscolors/
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;32"
export MANPAGER="less -X" # Don't clear the screen after quitting a manual page
export GOPATH=$HOME/code/go
export PATH=$HOME/code/go/bin:$HOME/dotvim/voom:/usr/local/sbin:$PATH
export EDITOR="vim"
export HOMEBREW_NO_ANALYTICS=1
export SSH_PUBLIC_KEY="$HOME/.ssh/github_rsa.pub"
# export PROMPT_DIRTRIM=4 # truncate start of long path

# git specific configurations
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true     # * for unstaged changes (+ staged but uncommitted changes)
export GIT_PS1_SHOWSTASHSTATE=true     # $ for stashed changes
export GIT_PS1_SHOWUNTRACKEDFILES=true # % for untracked files
export GIT_PS1_SHOWUPSTREAM="auto"     # > for local commits on HEAD not pushed to upstream
                                       # < for commits on upstream not merged with HEAD
                                       # = HEAD points to same commit as upstream

# Commented out the below settings since creating my own Mac OS terminal theme
# As these colours seemed a little redundant
#
# # Colored man pages
# export LESS_TERMCAP_mb=$'\E[01;31m'
# export LESS_TERMCAP_md=$'\E[01;31m'
# export LESS_TERMCAP_me=$'\E[0m'
# export LESS_TERMCAP_se=$'\E[0m'
# export LESS_TERMCAP_so=$'\E[01;44;33m'
# export LESS_TERMCAP_ue=$'\E[0m'
# export LESS_TERMCAP_us=$'\E[01;32m'

# terminal configuration
export PROMPT_COMMAND='history -a' # record each line as it gets issued

# history configuration
export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTCONTROL="erasedups:ignoreboth" # avoid duplicate entries
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history" # don't record some commands
export HISTTIMEFORMAT='%F %T ' # useful timestamp format

# force colours
force_color_prompt=yes

# use colour prompt
color_prompt=yes

# \e indicates escape sequence (sometimes you'll see \033)
# the m indicates you've provided a colour sequence
#
# 30: Black
# 31: Red
# 32: Green
# 33: Yellow
# 34: Blue
# 35: Purple
# 36: Cyan
# 37: White
#
# a semicolon allows additional attributes:
#
# 0: Normal text
# 1: Bold or light, depending on terminal
# 4: Underline text
#
# there are also background colours (put before additional attributes with ; separator):
#
# 40: Black background
# 41: Red background
# 42: Green background
# 43: Yellow background
# 44: Blue background
# 45: Purple background
# 46: Cyan background
# 47: White background

# simple left prompt example:
# PS1='\e[01;33m\]\u:\[\e[31m\]\w\[\e[00m\] (\j) (\A)\$ '

# Much more complex left AND right solution (http://superuser.com/a/517110)
# Which also dynamically displays the number of background jobs \j in the current terminal
# As well as dynamically displays git branch if available

num_jobs=$(jobs | wc -l)

if [ $num_jobs -eq 0 ]; then
  num_jobs=""
else
  num_jobs=" (\j)"
fi

function prompt_right() {
  # need the correct number of spaces after \A to allow for 00:00 time display
  # echo -e "\e[0;36m\A   \e[0m"
  echo -e ""
}
function prompt_left() {
  # __git_ps1 function sourced from ~/.git-prompt.sh
  echo -e "\e[33m\]\u. \[\e[37m\]\w\[\e[00m\]$num_jobs\e[31m\]$(__git_ps1)\e[00m\] \e[0;37m(\A)\e[0m"
}
function prompt() {
    compensate=11
    PS1=$(printf "%*s\r%s\n\$ " "$(($(tput cols)+${compensate}))" "$(prompt_right)" "$(prompt_left)")
}

# override builtin cd so it resets command prompt when changing directories
function cd {
  builtin cd "$@"
  RET=$?

  PROMPT_COMMAND=prompt

  # Disabled following because it seems to be pointless now?
  # That or I just don't know what it was really doing originally?
  #
  # # After each command, append to the history file and reread it...
  # export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

  return $RET
}

function rubo() {
  docker run \
    --cpu-shares 1024 \
    --rm=true \
    --volume $(pwd):/app \
    bbcnews/rubocop-config --format simple --fail-level F | grep '^F:\|=='
}

function toggle_hidden() {
  setting=$(defaults read com.apple.finder AppleShowAllFiles)

  if [ $setting == "NO" ]; then
    echo "Enabling hidden files"
    defaults write com.apple.finder AppleShowAllFiles YES
  else
    echo "Disabling hidden files"
    defaults write com.apple.finder AppleShowAllFiles NO
  fi

  killall Finder
}

function gms() {
  git merge --squash $1
}

function gr {
  local path=$(basename $(pwd))
  cd "../$path" # fixes issue when `git checkout -b <branch>` doesn't update the shell's prompt
}

function pt {
  local app=$1
  local env=${2:-stage}

  if [ -z "$1" ]; then
    printf "\n\tUse: pt <service:site_router> [env=stage]\n"
  else
    papertrail -f "docker/$env/$app"
  fi
}

function pt_search {
  local app=$1
  local search=$2
  local env=${3:-stage}

  if [ -z "$1" ]; then
    printf "\n\tUse: pt_search <service:site_router> <search:smoke_tests> [env=stage]\n"
  else
    pt $app $env | grep $search | awk '{print $0,"\n"}'
  fi
}

read -r -d '' git_icons <<- EOF
* unstaged changes
+ staged but uncommitted changes
$ stashed changes
% untracked files
> local commits on HEAD not pushed to upstream
< commits on upstream not merged with HEAD
= HEAD points to same commit as upstream
EOF

# use `type <alias>` to see what is assigned to an alias/fn/builtin/keyword
alias dotfiles="ls -a | grep '^\.' | grep --invert-match '\.DS_Store\|\.$'"
alias getcommit="git log -1 | cut -d ' ' -f 2 | head -n 1 | pbcopy"
alias sshkey="ssh-keygen -t rsa -b 4096 -C 'mark.mcdx@gmail.com'"
alias irc="irssi"
alias ls="ls -GpF"
alias ll="ls -laGpFHh"
alias r="source ~/.bashrc"
alias cm="git checkout master"
alias c-="git checkout -"
alias gcp="git cherry-pick -"
alias gpr="git pull --rebase origin master"
alias mutt="cd ~/Downloads/mutt && mutt"
alias wut='echo "$git_icons"'
alias gitupstream="echo git branch -u origin/\<branch\>"
alias sshconfig='nvim -c "norm 12ggVjjjgc" -c "wq" ~/.ssh/config && cat ~/.ssh/config | awk "/switch/ {for(i=0; i<=3; i++) {getline; print}}"'
alias copy="tr -d '\n' | pbcopy" # e.g. echo $DEV_CERT_PATH | copy
alias be="bundle exec"
alias v="$HOME/code/buzzfeed/mono/scripts/rig_vm"
alias sshvm="ssh rig.dev"
alias drm="docker rm $(docker ps -a -q)"
alias drmi="docker rmi $(docker images -q)"
alias dns="scutil --dns | grep 'nameserver\[[0-9]*\]'"
alias muttb="mutt -F ~/.muttrc-buzzfeed"
alias pipall="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"

eval "$(rbenv init -)"
eval "$(pyenv init -)"

function resize {
  # brew install imagemagick
  printf 'Usage:\n\toriginal, newname (default: original), quality (default: 70)\n\n'
  local original=$1
  local newname=${2:-$original}
  local quality=${3:-70}
  convert -resize "790>" -quality $quality "$original.png" "$newname.jpg"
}

# lazyload nvm
# all props goes to http://broken-by.me/lazy-load-nvm/
# grabbed from reddit @ https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/

lazynvm() {
  unset -f nvm node npm
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
}

nvm() {
  lazynvm
  nvm $@
}

node() {
  lazynvm
  node $@
}

npm() {
  lazynvm
  npm $@
}
