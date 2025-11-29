#!/bin/bash

set -e

# keep sudo authenticated for the duration of this script
sudo -v
while true; do sleep 60; sudo -v; done &
trap "kill $!" SIGINT SIGTERM EXIT

clear_pacman_cache() {
    sudo paccache -rk2 --min-atime "4 weeks ago" \
        && sudo paccache -ruk0 --min-atime "4 weeks ago"
}

if command -v paru; then
    paru -Syu --combinedupgrade --removemake
    clear_pacman_cache
elif command -v pacman; then
    sudo pacman -Syu --noconfirm
    # TODO remove results of pacman -Qte
    clear_pacman_cache
fi

if command -v apt; then
    sudo apt update
    sudo apt upgrade
    sudo apt autoremove
fi

if command -v rustup; then
    rustup update
fi

