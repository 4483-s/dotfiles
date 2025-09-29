#!/bin/bash
result=$(pgrep gammastep)
if [ -n "$result" ]; then
  killall gammastep
else
  gammastep -O 4433
fi
exit
