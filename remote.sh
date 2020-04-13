#!/usr/bin/env bash

# Install/update my dotfiles
cd ~
TARGET=dotfiles
[ ! -d $TARGET ] && git clone https://github.com/ozh/dotfiles ~/$TARGET || cd $TARGET && git push && cd ..

# Run local install
chmod +x $TARGET/local.sh
$TARGET/local.sh
