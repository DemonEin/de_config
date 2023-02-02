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

# copied from a question on Reddit, could be improved?
git config --global diff.tool vimdiff3
git config --global difftool.vimdiff3.path nvim
git config --global merge.tool vimdiff3
git config --global mergetool.vimdiff3.path nvim
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
cp -R $SCRIPT_DIR/nvim ~/.config/

nvim +PackerSync
