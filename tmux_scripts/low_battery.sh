#!/bin/bash

doubleDigit=$(pmset -g batt | grep [0-9][0-9]% | awk 'NR==1{print $3}' | cut -c 1-3)
if [ ${#doubleDigit} -gt 1 ]; then
  if [ "$doubleDigit" -lt 20 ]; then
	  echo " ♥ $doubleDigit"
	else
	  echo ""
	fi
else
	doubleDigit=$(pmset -g batt | grep [0-9]% | awk 'NR==1{print $3}' | cut -c 1-2)
  if [ "$doubleDigit" -lt 20 ]; then
	  echo " ♥ $doubleDigit"
	else
	  echo ""
	fi
fi

