#!/usr/bin/env bash

cd ~

# Install precompiled nano 4.9.2 and highlight files
[ ! -f ~/bin/nano ] && wget -q -O ~/bin/nano https://ozh.org/nano/nano
[ ! -d ~/.nano/ ]   && curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

# Install my binaries
mkdir -p ~/bin
for FILE in $(ls ~/dotfiles/bin);
do
    cp ~/dotfiles/bin/$FILE ~/bin
done

# Create .dotfiles from dotfiles/files (backup old ones and move newer ones)
mkdir -p ~/dotfiles_old
for FILE in $(ls ~/dotfiles/dotfiles);
do
    [ -f ~/.$FILE ] && mv ~/.$FILE ~/dotfiles_old/
    cp ~/dotfiles/dotfiles/$FILE ~/.$FILE
done

source ~/.bash_profile
