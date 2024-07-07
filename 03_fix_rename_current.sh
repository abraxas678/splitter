#!/bin/bash

# Get the list of .sh files in the current directory
for file in *.sh; do
  # Check if the file already has a sequential number
  if [[ $file =~ ^[0-9][0-9]_ ]]; then
    # If it does, skip this file and move on to the next one
    continue
  fi

  # Get the filename without extension
  name=$(basename --suffix=.sh "$file")

  # Check if a new sequential number can be assigned
  i=1
  while true; do
    new_name="$(printf "%02d_" $i)$name.sh"
    test ! -f "$new_name" && break
    ((i++))
  done

  # Rename the file
  mv "$file" "$new_name"
done
