#!/bin/bash

REGEX_PATTERN="^((?!$1).)*$"
rg --pcre2 "$REGEX_PATTERN"
