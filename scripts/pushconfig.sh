#!/bin/bash
cd ~/.config/
cp -r sway waybar rofi kitty scripts /etc/keyd ~/.zshrc ~/dotfiles
cd -
cd ~/dotfiles
git add .
git commit -m 'sync'
git push
cd -
