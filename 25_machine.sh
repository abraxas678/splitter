#!/bin/bash
echo
echo machine.sh v0.3
cd $HOME
echo
echo "hostname: $(hostname)"
read -p "new hostname: >> " HOSTNAME
HOSTNAME_OLD=$(hostname)
sudo hostnamectl set-hostname "$HOSTNAME"
sudo echo "$HOSTNAME" >$HOME/hostname
sudo mv $HOME/hostname /etc/hostname
echo; echo "/etc/hostname: "; cat /etc/hostname; echo
sudo sed -i "s/$HOSTNAME_OLD/$HOSTNAME/g" /etc/hosts
echo; echo "/etc/hosts: "; cat /etc/hosts; echo
cd $HOME
sudo apt install -y wget
wget https://raw.githubusercontent.com/abraxas678/public/master/wsl.conf
#cp $HOME/server_setup/wsl.conf $HOME
sed -i "s/CHANGEHOSTNAME/$HOSTNAME/g" $HOME/wsl.conf
sudo mv wsl.conf /etc/
read -p "ENTER TO RESTART" me
sudo reboot -f
