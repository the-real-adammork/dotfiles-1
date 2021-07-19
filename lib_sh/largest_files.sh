#!/bin/bash

EXTENSION="$1"
sort -n < <(find . -name "*.$EXTENSION" | xargs -n 1 -I {} wc -l {} )
