# Shell
alias la="ls -a"
alias ll="ls -l"
alias sop="source ~/.bash_profile"

# Ruby
alias be="bundle exec"
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
alias gpl="git pull"
alias gpu="git push"
alias gst="git status"
alias grc="git rebase --continue"

# Mongo
alias start_mongo="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist"
alias stop_mongo="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist"

# Postgres
alias start_postgres="postgres -D /usr/local/var/postgres"
alias start_postgres_log="pg_ctl -D /usr/local/var/postgres -l logfile start"
alias stop_postgres="pg_ctl -D /usr/local/var/postgres stop -s -m fast"
