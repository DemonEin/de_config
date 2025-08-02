#!/bin/bash

# keep sudo authenticated for the duration of this script
sudo -v
while true; do sleep 60; sudo -v; done &
trap "kill $!" SIGINT SIGTERM EXIT

if command -v yay; then
    yay \
        --answerclean None \
        --answerdiff None \
        --answeredit None \
        --answerupgrade None \
        --removemake \
        --noconfirm
elif command -v pacman; then
    sudo pacman -Syu --noconfirm
    # TODO remove results of pacman -Qte
fi

if command -v apt; then
    sudo apt update
    sudo apt upgrade
    sudo apt autoremove
fi

if command -v rustup; then
    rustup update
fi

