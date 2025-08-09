#!/bin/bash

result=$(pgrep -x gammastep)

if [ -n "$result" ]; then
  kill $result
else
  gammastep -O 4433
fi
