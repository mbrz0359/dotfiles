#!/usr/bin/env bash

username=$(whoami)

init_brew() {
    brew --version
    if [ $? -ne 0 ]; then
      echo "Homebrew not found, installing"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
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
init_zsh
echo "Init Done"
