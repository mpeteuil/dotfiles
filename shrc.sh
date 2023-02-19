#!/bin/sh
# shellcheck disable=SC2155

# Colourful manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Set to avoid `env` output from changing console colour
export LESS_TERMEND=$'\E[0m'

# Print field by number
field() {
  ruby -ane "puts \$F[$1]"
}

# Setup PATH

# Remove from anywhere in PATH
remove_from_path() {
  [ -d "$1" ] || return
  PATHSUB=":$PATH:"
  PATHSUB=${PATHSUB//:$1:/:}
  PATHSUB=${PATHSUB#:}
  PATHSUB=${PATHSUB%:}
  export PATH="$PATHSUB"
}

# Add to the start of PATH if it exists
add_to_path_start() {
  [ -d "$1" ] || return
  remove_from_path "$1"
  export PATH="$1:$PATH"
}

# Add to the end of PATH if it exists
add_to_path_end() {
  [ -d "$1" ] || return
  remove_from_path "$1"
  export PATH="$PATH:$1"
}

# Add to PATH even if it doesn't exist
force_add_to_path_start() {
  remove_from_path "$1"
  export PATH="$1:$PATH"
}

quiet_which() {
  command -v "$1" >/dev/null
}

add_to_path_start "/home/linuxbrew/.linuxbrew/bin"
add_to_path_start "/usr/local/bin"
add_to_path_start "/usr/local/sbin"
add_to_path_end "$HOME/.cargo/bin"
add_to_path_end "$HOME/.local/bin"
add_to_path_end "$HOME/.dotfiles/bin"

source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'

# Run asdf if it exists
quiet_which asdf && . /usr/local/opt/asdf/libexec/asdf.sh

# Aliases
alias mkdir="mkdir -vp"
alias df="df -H"
alias rm="rm -iv"
alias mv="mv -iv"
alias zmv="noglob zmv -vW"
alias cp="cp -irv"
alias du="du -sh"
alias make="nice make"
alias less="less --ignore-case --raw-control-chars"
alias rsync="rsync --partial --progress --human-readable --compress"
alias rake="noglob rake"
alias rg="rg --colors 'match:style:nobold' --colors 'path:style:nobold'"
alias be="nocorrect bundle exec"
alias sha256="shasum -a 256"
alias perlsed="perl -p -e"

# Shell
alias ll="exa -l"
alias nv="nvim"

# Ruby
alias bo="bundle open"
alias ngemf="touch Gemfile && echo \"source 'https://rubygems.org'\" >> Gemfile"

# Rails
alias rcs="be rails c --sandbox"
alias rc="be rails c"
alias rs="be rails s"

# Git
alias g="git status"
alias gco="git checkout"
alias gd="git diff"
alias gdc="git diff --cached"
alias glb="git branch -l"
alias glo="git log --oneline"
alias glp="git log --pretty=\"format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %Cblue%an, %Cgreen%ar%Creset\" --graph"
alias gpl="git pull"
alias gpp="git pull --prune"
alias gpu="git push"
alias gst="git status"
alias grc="git rebase --continue"
alias gra="git rebase --abort"
alias gcp="git cherry-pick"
alias gcpa="git cherry-pick --abort"
alias gcpc="git cherry-pick --continue"
alias grlb="git branch --merged | egrep -v '(^\*|master)' | xargs git branch -d"

# Command-specific stuff
if quiet_which brew
then
  eval $(brew shellenv)

  export HOMEBREW_AUTO_UPDATE_SECS=3600
  export HOMEBREW_DEVELOPER=1
  export HOMEBREW_BUNDLE_BREW_SKIP=""
  export HOMEBREW_BUNDLE_CASK_SKIP=""
  # export HOMEBREW_NO_ENV_HINTS=1
  export HOMEBREW_INSTALL_FROM_API=1
  export HOMEBREW_AUTOREMOVE=1

  add_to_path_end "$HOMEBREW_PREFIX/Library/Homebrew/shims/gems"

  alias hbc='cd $HOMEBREW_REPOSITORY/Library/Taps/homebrew/homebrew-core'
fi

if quiet_which git-delta
then
  export GIT_PAGER='delta'
else
  # shellcheck disable=SC2016
  export GIT_PAGER='less -+$LESS -RX'
fi

if quiet_which exa
then
  alias ls="exa --classify --group --git"
elif [ "$MACOS"]
then
  alias ls="ls -F"
else
  alias ls="ls -F --color=auto"
fi

if quiet_which bat
then
  export BAT_THEME="ansi"
  alias cat="bat"
fi

if quiet_which htop
then
  alias top="sudo htop"
fi

if quiet_which dust
then
  alias du="dust"
fi

if quiet_which duf
then
  alias df="duf"
fi

if quiet_which mcfly
then
  export MCFLY_LIGHT=TRUE
  export MCFLY_FUZZY=true
  export MCFLY_RESULTS=64
fi

# Configure environment
export CLICOLOR=1
# export RESQUE_REDIS_URL="redis://localhost:6379"
export GITHUB_PROFILE_BOOTSTRAP=1
export GITHUB_PACKAGES_SUBPROJECT_CACHE_READ=1
export GITHUB_NO_AUTO_BOOTSTRAP=1

# OS-specific configuration
if [ "$MACOS" ]
then
  export GREP_OPTIONS="--color=auto"
  export VAGRANT_DEFAULT_PROVIDER="vmware_fusion"

  add_to_path_end "$HOMEBREW_PREFIX/opt/git/share/git-core/contrib/diff-highlight"
  add_to_path_end "/Applications/Fork.app/Contents/Resources"
  add_to_path_end "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  add_to_path_start "$HOME/Homebrew/bin"
  add_to_path_start "$HOME/Homebrew/sbin"

  alias fork="/Applications/Fork.app/Contents/Resources/fork_cli"

  alias locate="mdfind -name"
  alias finder-hide="setfile -a V"

  # Load GITHUB_TOKEN from macOS keychain
  if [ $MACOS ]
  then
    export GITHUB_TOKEN=$(
      printf "protocol=https\\nhost=github.com\\n" \
      | git credential fill \
      | perl -lne '/password=(gho_.+)/ && print "$1"'
    )
  fi

  # Some post-secret aliases
  export HOMEBREW_GITHUB_API_TOKEN="$GITHUB_TOKEN"
  export JEKYLL_GITHUB_TOKEN="$GITHUB_TOKEN"
  export BUNDLE_RUBYGEMS__PKG__GITHUB__COM="$GITHUB_TOKEN"

  # output what's listening on the supplied port
  on-port() {
    sudo lsof -nP -i4TCP:$1
  }

  # make no-argument find Just Work.
  find() {
    local arg
    local path_arg
    local dot_arg

    for arg
    do
      [[ $arg =~ "^-" ]] && break
      path_arg="$arg"
    done

    [ -z "$path_arg" ] && dot_arg="."

    command find $dot_arg "$@"
  }
elif [ "$LINUX" ]
then
  quiet_which keychain && eval "$(keychain -q --eval --agents ssh id_rsa)"

  add_to_path_start "/workspaces/github/bin"

  alias su="/bin/su -"
  alias open="xdg-open"
elif [ "$WINDOWS" ]
then
  open() {
    # shellcheck disable=SC2145
    cmd /C"$@"
  }
fi

# Set up editor
if quiet_which code
then
  export EDITOR="code"
elif quiet_which vim
then
  export EDITOR="vim"
elif quiet_which vi
then
  export EDITOR="vi"
fi

# Set up version control editors specifically
if quiet_which nvim
then
  export GIT_EDITOR="nvim"
  export SVN_EDITOR=$GIT_EDITOR
elif quiet_which vim
then
  export GIT_EDITOR="vim"
  export SVN_EDITOR=$GIT_EDITOR
elif quiet_which vi
then
  export GIT_EDITOR="vi"
  export SVN_EDITOR=$GIT_EDITOR
fi

# GPG
export GPG_TTY=$(tty)

# Run dircolors if it exists
quiet_which dircolors && eval "$(dircolors -b)"

# Save directory changes
cd() {
  builtin cd "$@" || return
  [ "$TERMINALAPP" ] && command -v set_terminal_app_pwd >/dev/null \
    && set_terminal_app_pwd
  pwd > "$HOME/.lastpwd"
  ls
}

# Use ruby-prof to generate a call stack
ruby-call-stack() {
  ruby-prof --printer=call_stack --file=call_stack.html -- "$@"
}

# Pretty-print JSON files
json() {
  [ -n "$1" ] || return
  cat "$1" | jq .
}

# Pretty-print Homebrew install receipts
receipt() {
  [ -n "$1" ] || return
  json "$HOMEBREW_PREFIX/opt/$1/INSTALL_RECEIPT.json"
}

# Move files to the Trash folder
trash() {
  mv "$@" "$HOME/.Trash/"
}

# GitHub API shortcut
github-api-curl() {
  noglob curl -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/$1"
}

# Spit out Okta keychain password
okta-keychain() {
  security find-generic-password -l device_trust '-w'
}

# Look in ./bin but do it last to avoid weird `which` results.
# force_add_to_path_start "bin"
