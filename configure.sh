#!/bin/bash

# assumes git and nvim are on $PATH

# add source bashrc.sh to .bashrc
# following line copied from https://stackoverflow.com/questions/59895
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SOURCE_DE_BASH="source $SCRIPT_DIR/bashrc.sh"

contains_config=$(grep "$SOURCE_DE_BASH" $HOME/.bashrc)
if [ -z "${contains_config}" ]; then
    # does not source bashrc.sh
   echo $SOURCE_DE_BASH >> $HOME/.bashrc 
   $SOURCE_DE_BASH
else
    echo ".bashrc already sources bashrc.sh - skipping"
fi

source ~/.bashrc

rm -r ~/.config/nvim
ln -T -s $SCRIPT_DIR/nvim ~/.config/nvim
ln -T -s $SCRIPT_DIR/awesome ~/.config/awesome
ln -T -s $SCRIPT_DIR/git ~/.config/git
ln -s $SCRIPT_DIR/alacritty.toml ~/.config/alacritty.toml
sudo ln -T -s $SCRIPT_DIR/X11/xorg.conf.d /etc/X11/xorg.conf.d
