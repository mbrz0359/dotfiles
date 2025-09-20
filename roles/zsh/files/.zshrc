# Oh My Zsh
export ZSH="$HOME/.local/share/oh-my-zsh"
export HISTFILE="$HOME/.local/share/zsh/zsh_history"
export ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$HOST"

ZSH_THEME="robbyrussell"
ZVM_INIT_MODE=sourcing # fzf has to be loaded after zsh-vi-mode for it to work
FZF_ALT_C_COMMAND="" # conflicts with vi-mode

plugins=(
    colored-man-pages
    copyfile
    git
    gh
    helm
    kind
    kube-ps1
    minikube
    mise
    zoxide
    zsh-autosuggestions
    zsh-kubecolor
    zsh-syntax-highlighting
    zsh-vi-mode
    fzf
    zsh-interactive-cd
)
source $ZSH/oh-my-zsh.sh

# ZSH
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Init
eval "$(just --completions zsh)"

# Prompt
PROMPT='$(kube_ps1)'$PROMPT # or RPROMPT='$(kube_ps1)'
KUBE_PS1_NS_ENABLE=false

# Aliases
alias vim=nvim
alias vi=nvim
alias k8s=k9s

alias ls=lsd
alias la='ls -a'
alias ll='ls -ltrh'
alias lt='ls --tree'

unalias gh # Alias created by git plugin interferes with github-cli

# Env variables
EDITOR=nvim

# All custom functions
for file in $HOME/.config/zsh/*.zsh; do
  source "$file"
done