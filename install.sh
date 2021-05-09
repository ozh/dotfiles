#!/bin/bash

cd ~
mkdir -p ~/bin

# Install precompiled nano 4.9.2 and highlight files
[ ! -f ~/bin/nano ] && wget -O ~/bin/nano https://ozh.org/nano/nano && chmod +x ~/bin/nano
[ ! -d ~/.nano/ ]   && curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

# Install precompiled bat 0.18.0 
[ ! -f ~/bin/bat ] && wget -O ~/bin/bat https://ozh.org/bat/bat && chmod +x ~/bin/bat

# if we have a .nanorc, add tabsize
if [ -f ~/.nanorc ] && ! grep -q "set tabsize 4" ~/.nanorc ; then
    echo -e "set tabsize 4\n$(cat ~/.nanorc)" > ~/.nanorc
fi

# Install my binaries
for FILE in $(ls ~/dotfiles/bin);
do
    cp ~/dotfiles/bin/$FILE ~/bin
    chmod +x ~/bin/$FILE
done

# Create .dotfiles from dotfiles/files (backup old ones and move newer ones)
mkdir -p ~/dotfiles_old
for FILE in $(ls ~/dotfiles/dotfiles);
do
    [ -f ~/.$FILE ] && mv ~/.$FILE ~/dotfiles_old/
    cp ~/dotfiles/dotfiles/$FILE ~/.$FILE
done

source ~/.bash_profile
