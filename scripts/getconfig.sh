#!/bin/bash
cd ~/dotfiles
git pull
cp -r sway nvim waybar rofi kitty scripts ~/.config
cp .zshrc ~/
sudo cp -r keyd /etc/
cd - >/dev/null
