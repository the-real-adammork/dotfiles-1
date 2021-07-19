#!/bin/bash

rating=$(cat $HOME/.dotfiles/tmux_scripts/president_trump_job_approval-6179.csv | grep "RCP" | awk -F "\"*,\"*" '{print $4}')
threshold=45.0

if (( $(echo "$rating > $threshold" |bc -l) )); then
  echo "👍 $rating %"
else
  echo "🤞 $rating %"
fi
