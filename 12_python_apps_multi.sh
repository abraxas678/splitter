#!/bin/bash
#9. Python3 install + Apps
cd /home/abrax/tmp/splitter
# Install Python packages using pipx

  while IFS= read -r line; do
    [[ $line != "#"* ]] && pipx install $line
  done <  python_apps_all_multi.txt 
