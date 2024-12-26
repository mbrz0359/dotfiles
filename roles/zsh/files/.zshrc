# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
    git
    kube-ps1
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# ZSH
bindkey -v
bindkey '^R' history-incremental-search-backward
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Prompt
PROMPT='$(kube_ps1)'$PROMPT # or RPROMPT='$(kube_ps1)'
KUBE_PS1_NS_ENABLE=false

# mise
eval "$(~/.local/bin/mise activate zsh)"

# fzf
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"

# Aliases
alias vim=nvim
alias vi=nvim
alias k=kubecolor
alias kubectl=kubecolor
alias k8s=k9s

alias ls=lsd
alias la='ls -a'
alias ll='ls -ltrh'
alias lt='ls --tree'

compdef k=kubectl
compdef kubecolor=kubectl

# Env variables
EDITOR=nvim

# All custom functions
for file in $HOME/.config/zsh/*.zsh; do
  source "$file"
done