#!/bin/bash
#12. User setup
# Task: Check if user is '$CHECKUSER'
# TASK "CHECK: USER = $CHECKUSER?"
CHECKUSER="$CHECKUSER"
echo
echo "CHECKUSER $CHECKUSER" | /home/abrax/bin/green.sh
echo
CHAN=0
read -n 1 -t 7 -p "press [c] to change the target user. 7 seconds countdown." CHAN
echo
[[ $CHAN = c ]] && read -p "username: >> " CHECKUSER
if [[ $USER != *"$CHECKUSER"* ]]; then
sudo apt install -y sudo
if [[ $USER == *"root"* ]]; then
su $CHECKUSER
adduser $CHECKUSER
usermod -aG sudo $CHECKUSER
su $CHECKUSER
exit
else
su $CHECKUSER
sudo adduser $CHECKUSER
sudo usermod -aG sudo $CHECKUSER
su $CHECKUSER
exit
fi
fi

