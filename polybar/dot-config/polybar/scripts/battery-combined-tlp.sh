#!/bin/sh
if [ ! "$(type tlp-stat 2>/dev/null)" ]; then
  exit
fi
battery=$(sudo tlp-stat -b | tac | grep -m 1 "Charge" | tr -d -c "[:digit:],.")

echo "BAT $battery %"
