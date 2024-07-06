#!/bin/bash
#7. App install via apt
cd /home/abrax/tmp/splitter
sudo apt update 

installme() {
 which $1
 [[ $? != 0 ]] && brew install $1 
}

while IFS= read -r line; do
  [[ $line != "#"* ]] && installme $line
done <  brew_apps_all_multi.txt

brew services start pueue
pueue group add keepon
