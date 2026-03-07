#!/bin/bash
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
  [[ -d "$1" ]] || return
  PATHSUB=":${PATH}:"
  PATHSUB=${PATHSUB//:$1:/:}
  PATHSUB=${PATHSUB#:}
  PATHSUB=${PATHSUB%:}
  export PATH="${PATHSUB}"
}

# Add to the start of PATH if it exists
add_to_path_start() {
  [[ -d "$1" ]] || return
  remove_from_path "$1"
  export PATH="$1:${PATH}"
}

# Add to the end of PATH if it exists
add_to_path_end() {
  [[ -d "$1" ]] || return
  remove_from_path "$1"
  export PATH="${PATH}:$1"
}

# Add to PATH even if it doesn't exist
force_add_to_path_start() {
  remove_from_path "$1"
  export PATH="$1:${PATH}"
}

quiet_which() {
  command -v "$1" >/dev/null
}

if [[ -n "${MACOS}" ]]; then
  add_to_path_start "/opt/homebrew/bin"
elif [[ -n "${LINUX}" ]]; then
  add_to_path_start "/home/linuxbrew/.linuxbrew/bin"
fi

add_to_path_start "/usr/local/bin"
add_to_path_start "/usr/local/sbin"
add_to_path_end "$HOME/.cargo/bin"
add_to_path_end "$HOME/.local/bin"
add_to_path_end "${HOME}/.dotfiles/bin"

# Aliases
alias mkdir="mkdir -vp"
alias df="df -H"
alias rm="rm -iv"
alias mv="mv -iv"
alias cp="cp -irv"
alias du="du -sh"
alias less="less --ignore-case --raw-control-chars"
alias rsync="rsync --partial --progress --human-readable --compress"
alias rg="rg --colors 'match:style:nobold' --colors 'path:style:nobold'"
alias be="bundle exec"
alias sha256="shasum -a 256"
alias sedperl="perl -p -e"

# Shell
alias ll="eza -l"
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
alias grbm="git recentb main"
alias gfpo="git push -f origin $(git branch --show-current)"

# Command-specific stuff
if quiet_which brew; then
  export HOMEBREW_DEVELOPER=1
  export HOMEBREW_BUNDLE_BREW_SKIP=""
  export HOMEBREW_BUNDLE_CASK_SKIP=""
  export HOMEBREW_BUNDLE_INSTALL_CLEANUP=1
  export HOMEBREW_BUNDLE_DUMP_DESCRIBE=1
  export HOMEBREW_BUNDLE_CHECK=1
  export HOMEBREW_CLEANUP_MAX_AGE_DAYS=30
  export HOMEBREW_USE_INTERNAL_API=1
  export HOMEBREW_REALLY_USE_INTERNAL_API=1

  add_to_path_end "${HOMEBREW_PREFIX}/Library/Homebrew/shims/gems"

  alias bbe="brew bundle exec --check --install --"

  alias hbc='cd $HOMEBREW_REPOSITORY/Library/Taps/homebrew/homebrew-core'
fi

if quiet_which delta; then
  export GIT_PAGER='delta'
else
  # shellcheck disable=SC2016
  export GIT_PAGER='less -+$LESS -RX'
fi

if quiet_which eza; then
  alias ls="eza --classify --group --git"
elif [[ -n "${MACOS}" ]]; then
  alias ls="ls -F"
else
  alias ls="ls -F --color=auto"
fi

if quiet_which bat; then
  export BAT_THEME="ansi"
  alias cat="bat"
  export HOMEBREW_BAT=1
fi

if quiet_which dust; then
  alias du="dust"
fi

if quiet_which duf; then
  alias df="duf"
fi

if quiet_which htop; then
  alias top="sudo htop"
fi

# Configure environment
export CLICOLOR=1
# export RESQUE_REDIS_URL="redis://localhost:6379"
export AWS_CLI_AUTO_PROMPT=on-partial

export MODULAR_HOME="$HOME/.modular"

# OS-specific configuration
if [[ -n "${MACOS}" ]]; then
  export GREP_OPTIONS="--color=auto"
  export VAGRANT_DEFAULT_PROVIDER="vmware_fusion"

  add_to_path_end "/Applications/Fork.app/Contents/Resources"
  add_to_path_end "$HOME/.modular/pkg/packages.modular.com_mojo/bin"
  add_to_path_start "$HOME/Homebrew/bin"
  add_to_path_start "$HOME/Homebrew/sbin"

  alias fork="/Applications/Fork.app/Contents/Resources/fork_cli"

  alias locate="mdfind -name"
  alias finder-hide="setfile -a V"

  # output what's listening on the supplied port
  on-port() {
    sudo lsof -nP -i4TCP:"$1"
  }

  # make no-argument find Just Work.
  find() {
    local arg
    local path_arg
    local dot_arg

    for arg; do
      [[ ${arg} =~ "^-" ]] && break
      path_arg="${arg}"
    done

    [[ -z "${path_arg}" ]] && dot_arg="."

    command find ${dot_arg} "$@"
  }

  # Only run this if it's not already running
  pgrep -fq touchid-enable-pam-sudo || touchid-enable-pam-sudo --quiet
elif [[ -n "${LINUX}" ]]; then
  quiet_which keychain && eval "$(keychain -q --eval --agents ssh id_rsa)"

  # Run dircolors if it exists
  quiet_which dircolors && eval "$(dircolors -b)"

  add_to_path_start "/workspaces/github/bin"

  alias su="/bin/su -"
  alias open="xdg-open"
elif [[ -n "${WINDOWS}" ]]; then
  open() {
    # shellcheck disable=SC2145
    cmd /C"$@"
  }
fi

# Load GITHUB_TOKEN from gh
if quiet_which gh; then
  export GITHUB_TOKEN="$(gh auth token)"
  export GH_TOKEN="${GITHUB_TOKEN}"
  export HOMEBREW_GITHUB_API_TOKEN="${GITHUB_TOKEN}"
  export JEKYLL_GITHUB_TOKEN="${GITHUB_TOKEN}"
fi

# Set up editor
if quiet_which cursor; then
  export EDITOR="cursor"
  alias code="cursor"
elif quiet_which code; then
  export EDITOR="code"
fi

if quiet_which code; then
  # Edit Rails credentials in VSCode
  rails-credentials-edit-production() {
    EDITOR="${EDITOR} -w" bundle exec rails credentials:edit --environment production
  }
  rails-credentials-edit-development() {
    EDITOR="${EDITOR} -w" bundle exec rails credentials:edit --environment development
  }
else
  export EDITOR="vim"
fi

# Set up version control editors specifically
if quiet_which nvim; then
  export GIT_EDITOR="nvim"
  export SVN_EDITOR=$GIT_EDITOR
else
  export GIT_EDITOR="vim"
  export SVN_EDITOR=$GIT_EDITOR
fi

# GPG
export GPG_TTY=$(tty)

# Save directory changes
cd() {
  builtin cd "$@" || return
  [[ -n "${TERMINALAPP}" ]] && command -v set_terminal_app_pwd >/dev/null &&
    set_terminal_app_pwd
  pwd >"${HOME}/.lastpwd"
  ls
}

# Use ruby-prof to generate a call stack
ruby-call-stack() {
  ruby-prof --printer=call_stack --file=call_stack.html -- "$@"
}

# Pretty-print JSON files
json() {
  [[ -n "$1" ]] || return
  cat "$1" | jq .
}

# Pretty-print Homebrew install receipts
receipt() {
  [[ -n "$1" ]] || return
  json "${HOMEBREW_PREFIX}/opt/$1/INSTALL_RECEIPT.json"
}

# Move files to the Trash folder
trash() {
  mv "$@" "${HOME}/.Trash/"
}

# GitHub API shortcut
github-api-curl() {
  curl -H "Authorization: token ${GITHUB_TOKEN}" "https://api.github.com/$1" | jq .
}

# GitHub Packages shortcut
github-packages-curl() {
  curl -H "Authorization: Bearer QQ==" -H "Accept: application/vnd.oci.image.index.v1+json" "$@" | jq .
}

# Clear entire screen buffer
clearer() {
  tput reset
}

add_to_path_start "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"

# Transcribe files
whisper_transcribe() {
  whisper-cli \
    --model ~/.local/share/whisper-cpp/models/ggml-large-v3-turbo.bin \
    --language en "$@"
}

# Look in ./bin but do it last to avoid weird `which` results.
# force_add_to_path_start "bin"
