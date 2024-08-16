#!/bin/bash

if command -v yay; then
    yay --answerclean None --removemake --answerdiff None
elif command -v pacman; then
    sudo pacman -Syu
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

