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
