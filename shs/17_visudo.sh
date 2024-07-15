#!/bin/bash
command xsel >/dev/null 2>&1; [[ $? != 0 ]] && sudo apt install xsel -y
echo; echo "sudo visudo:";
echo " add:       abrax ALL=(ALL) NOPASSWD: ALL"
echo "abrax ALL=(ALL) NOPASSWD: ALL" | xsel -b
read -p BUTTON me
