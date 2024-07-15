#!/bin/bash
#01. Initialization and Environment Setup
mkdir -p ~/tmp
cd ~/tmp

MYHOME=$HOME
echo "MYHOME=$MYHOME"
cd $HOME

# Print version
echo "version: NEWv14"
sleep 1

countdown() {
    if [ -z "$1" ]; then
#        echo "No argument provided. Please provide a number to count down from."
#        exit 1
         echo ""
    fi

    tput civis
    for ((i=$1; i>0; i--)); do
        if (( i > $1*66/100 )); then
            echo -ne "\033[0;32m$i\033[0m\r"
        elif (( i > $1*33/100 )); then
            echo -ne "\033[0;33m$i\033[0m\r"
        else
            echo -ne "\033[0;31m$i\033[0m\r"
        fi
        sleep 1
        echo -ne "\033[0K"
    done
    echo -e "\033[0m"
    tput cnorm
}

# Color definitions

