#!/bin/bash
cd ~/dotfiles
git pull
cp -r sway waybar rofi kitty scripts ~/.config
cp .zshrc ~/
cp -r keyd /etc/
cd -
