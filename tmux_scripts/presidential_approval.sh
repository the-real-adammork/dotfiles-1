#!/bin/bash

rating=$(cat /Users/adammork/.dotfiles/tmux_scripts/rcp_average.csv | grep "RCP" | awk -F "\"*,\"*" '{print $4}')

if [ ${#rating} -gt 45 ]; then
  echo "👍 $rating %"
else
  echo "🤞 $rating %"
fi
