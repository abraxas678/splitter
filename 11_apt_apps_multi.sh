#!/bin/bash
#7. App install via apt
sudo apt update 

installme() {
 which $1
 [[ $? != 0 ]] && sudo apt install -y $1 
}

while IFS= read -r line; do
  [[ $line != "#"* ]] && installme $line
done <  apt_apps_all_multi.txt
