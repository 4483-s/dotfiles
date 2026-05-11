#!/bin/bash

prefix="/usr"
exec_prefix="${prefix}"
xrdb="xrdb"
xinitdir="/etc/X11/xinit"
xmodmap="xmodmap"

userresources="$HOME/.Xresources"
usermodmap="$HOME/.Xmodmap"
sysresources="$xinitdir/.Xresources"
sysmodmap="$xinitdir/.Xmodmap"

# merge in defaults and keymaps

if [ -f "$sysresources" ]; then
  if [ -x /usr/bin/cpp ]; then
    "$xrdb" -merge "$sysresources"
  else
    "$xrdb" -nocpp -merge "$sysresources"
  fi
fi

if [ -f "$sysmodmap" ]; then
  "$xmodmap" "$sysmodmap"
fi

if [ -f "$userresources" ]; then
  if [ -x /usr/bin/cpp ]; then
    "$xrdb" -merge "$userresources"
  else
    "$xrdb" -nocpp -merge "$userresources"
  fi
fi

if [ -f "$usermodmap" ]; then
  "$xmodmap" "$usermodmap"
fi

# start some nice programs

if [ -d "$xinitdir"/xinitrc.d ]; then
  for f in "$xinitdir/xinitrc.d"/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

########
mytwm="$(cat ~/.mytwm)"
randombg() {
  feh --randomize --bg-fill ~/Pictures/2wallpapers/*
}
if [[ "$(cat /etc/machine-id)" == 6f481e10d8a04e14aeae1d77bfd38de2 ]]; then
  xrandr --output HDMI-2 --primary
  xrandr --output HDMI-2 --primary --pos 0x0 --left-of HDMI-1
fi

spawnpolybar() {
  if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      MONITOR=$m polybar --reload base &
    done
  else
    polybar --reload base &
  fi
}
if ! [[ "${mytwm##*/}" == dwm ]]; then
  spawnpolybar
fi

# feh --bg-fill /home/h/.config/sway/img/gnufsf.jpg &
nm-applet &
picom --daemon &
redshift -O 4480

# mytwm='spectrwm'
# mytwm='qtile start'

randombg
[[ -z $mytwm ]] && exec i3
if [[ "$mytwm" == 'xmonad' ]]; then
  if [ -e $HOME/.cache/xmonad/xmonad-x86_64-linux ]; then
    exec $HOME/.cache/xmonad/xmonad-x86_64-linux
  fi
fi
exec "$mytwm"
