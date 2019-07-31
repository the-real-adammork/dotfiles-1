#!/bin/bash

rating=$(cat /Users/adammork/.dotfiles/tmux_scripts/rcp_average.csv | grep "RCP" | awk -F "\"*,\"*" '{print $4}')
threshold=45.0

if (( $(echo "$rating > $threshold" |bc -l) )); then
  echo "👍 $rating %"
else
  echo "🤞 $rating %"
fi
