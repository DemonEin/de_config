#!/bin/bash

# assumes git and nvim are on $PATH

# add source .de_bashrc to .bashrc
# following line copied from https://stackoverflow.com/questions/59895
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SOURCE_DE_BASH="source $SCRIPT_DIR/.de_bashrc"

contains_config=$(grep "$SOURCE_DE_BASH" $HOME/.bashrc)
if [ -z "${contains_config}" ]; then
    # does not source .de_bashrc
   echo $SOURCE_DE_BASH >> $HOME/.bashrc 
   $SOURCE_DE_BASH
else
    echo ".bashrc already sources .de_bashrc - skipping"
fi

source ~/.bashrc

git config --global diff.tool nvimdiff
git config --global merge.tool nvimdiff
git config --global difftool.prompt false
git config --global core.editor nvim
git config --global submodule.recurse true

# install packer.nvim if needed
DIRECTORY="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" 
if [ -d "$DIRECTORY" ]; then
    echo "packer already installed, skipping"
else
    git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim 
fi

rm -r ~/.config/nvim
ln -s $SCRIPT_DIR/nvim ~/.config/nvim
rm -r ~/.config/i3
ln -s $SCRIPT_DIR/i3 ~/.config/i3

nvim +PackerSync
