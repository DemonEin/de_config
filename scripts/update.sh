#!/bin/bash

set -e

# keep sudo authenticated for the duration of this script
sudo -v
while true; do sleep 60; sudo -v; done &
trap "kill $!" SIGINT SIGTERM EXIT

PACCACHE_COMMAND='sudo paccache -rk0 --min-atime "4 weeks ago"'
if command -v paru; then
    paru -Syu --combinedupgrade --removemake
    eval "$PACCACHE_COMMAND"
elif command -v pacman; then
    sudo pacman -Syu --noconfirm
    # TODO remove results of pacman -Qte
    eval "$PACCACHE_COMMAND"
fi

if command -v apt; then
    sudo apt update
    sudo apt upgrade
    sudo apt autoremove
fi

if command -v rustup; then
    rustup update
fi

