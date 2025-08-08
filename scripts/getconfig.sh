#!/bin/bash
cd ~/.config/
cp -r sway waybar rofi kitty /etc/keyd ~/.zshrc ~/dotfiles
cd ~/dotfiles
git add .
git commit -m 'sync'
git push
cd -
alias plldt="cd ~/dotfiles;git pull;cp -r sway waybar rofi kitty ~/.config;cp .zshrc ~/;cd -"
