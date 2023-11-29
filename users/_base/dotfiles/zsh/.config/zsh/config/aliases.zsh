### Modernized Core Commands
if ! [ -z "$(command -v zoxide)" ]; then
    alias cd='z'
fi

if ! [ -z "$(command -v lsd)" ]; then
    alias ls='lsd --group-directories-first'
    alias tree='lsd --tree --group-directories-first'
else
    alias ls='ls -F'
fi
alias la='ls -AF'
alias ll='ls -AFl'

alias grep='grep --color=auto'

### Git
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gf="git fetch"
alias gco="git checkout"
alias gs="git status"
alias gl="git log"
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias g$s="git stash show -p"
alias cdr='cd "$(git rev-parse --show-toplevel)"'

### Misc
function oops() {
    sudo $(fc -nl -1)
}
