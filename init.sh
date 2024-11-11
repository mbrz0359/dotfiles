#!/usr/bin/env bash

brew_apps=(
    helm
    htop
    k9s
    kind
    kubernetes-cli
    tree
    zsh
    kube-ps1
    zsh-syntax-highlighting
    zsh-autosuggestions
    kubecolor
    git
    yq
)

flatpak_apps=(
    app.devsuite.Ptyxis
    org.gnome.TextEditor
    com.plexamp.Plexamp
    net.nokyan.Resources
)

username=$(whoami)

init_brew() {
    brew --version
    if [ $? -ne 0 ]; then
      echo "Homebrew not found, installing"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    installed=$(brew list)

    for brew_app in ${brew_apps[@]}; do
      if [ "$(echo "$installed" | grep $brew_app)" = "" ]; then
          brew install $brew_app
      fi
    done
}

init_flatpak() {
    output=$(flatpak remotes | grep flathub | grep system)
    if [ "$output" = "" ]; then
      echo "Flathub not found, adding remote"
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    fi

    installed=$(flatpak list --app)

    for flatpak_app in ${flatpak_apps[@]}; do
      if [ "$(echo "$installed" | grep $flatpak_app)" = "" ]; then
          flatpak install flathub $flatpak_app
      fi
    done
}


init_zsh() {
    if [ ! -d ~/.oh-my-zsh ]; then
      echo "Installing oh-my-zsh"
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    zshrc_file=/home/"$username"/.zshrc
    cp .zshrc "$zshrc_file"

    echo -e "\n" >> "$zshrc_file"
    cat .zshrc-custom-additions >> "$zshrc_file"
}

init_brew
init_flatpak
init_zsh
echo "Init Done"
