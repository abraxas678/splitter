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
#8. Tailscale Setup

# Install Tailscale
which tailscale > /dev/null
if [[ $? != 0 ]]; then
  echo "install tailscale"
  sleep 1
  curl -L https://tailscale.com/install.sh | sh
  sudo tailscale up
fi
sudo tailscale up --ssh --accept-routes
tailscale status
countdown 2

tailscale status
if [[ $? != "0" ]]; then
  sudo tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 &
  countdown 2
  sudo tailscale up --ssh --accept-routes
fi
echo

# HISHTORY
#curl https://hishtory.dev/install.py | python3 -
#hishtory init $YOUR_HISHTORY_SECRET


#!/bin/bash
#04. akeyless setup
curl -o akeyless https://akeyless-cli.s3.us-east-2.amazonaws.com/cli/latest/production/cli-linux-amd64
chmod +x akeyless
mv akeyless /home/abrax/bin/
akeyless configure --access-id p-mcidcla45c0cam --access-type oidc --profile 'github-oidc'
#!/bin/bash
#11 rclone install

# Install rclone beta
echo "rclone beta"
countdown 1
sudo -v
curl https://rclone.org/install.sh | sudo bash -s beta
#!/bin/bash
#6. github and gh setup





sudo apt install - y git
sudo apt install - y gh

git config --global user.email "abraxas678@gmail.com"
git config --global user.name "abraxas678"

# GitHub authentication and cloning repositories
gh repo list > /dev/null
if [[ $? == 0 ]]; then
  echo "gh logged in"
  sleep 1
else
  gh status
  gh auth refresh -h github.com -s admin:public_key
  gh ssh-key add ./id_ed25519.pub
fi
echo
sleep 2

# Clone repositories if not already cloned
cd
if [[ ! -d $MYHOME/bin ]]; then
gh repo clone abraxas678/bin
sleep 1
cd /home/abrax
gh repo clone abraxas678/.config temp-directory
cp -r temp-directory/* .config/
rm -rf temp-directory
sleep 1
fi

# Set permissions for bin scripts
chmod +x ~/bin/*

cp /home/abrax/bin/sync.* /home/abrax/tmp/splitter/
#!/bin/bash
#7. App install via apt
cd /home/abrax/tmp/splitter
sudo apt update 

installme() {
 which $1
 [[ $? != 0 ]] && sudo apt install -y $1 
}

while IFS= read -r line; do
  [[ $line != "#"* ]] && installme $line
done <  apt_apps_all_multi.txt

sudo restic self-update
#!/bin/bash
#9. Python3 install + Apps
cd /home/abrax/tmp/splitter
# Install Python packages using pipx

  while IFS= read -r line; do
    [[ $line != "#"* ]] && pipx install $line
  done <  python_apps_all_multi.txt 
#!	
if command -v curl >/dev/null 2>&1; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
  sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi
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
#!/bin/bash
clear
command -v age >/dev/null 2>&1 || { echo >&2 "age is not installed. Installing..."; sleep 2; sudo apt-get update && sudo apt-get install -y age; }
export RCLONE_PASSWORD_COMMAND='akeyless get-secret-value --name RCLONE_CONFIG_PASS'

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
ORANGE='\033[0;33m'
GREY='\033[0;37m'
LIGHT_BLUE='\033[1;34m'
RESET='\033[0m'
RC='\033[0m'

cd $HOME/tmp
ts=$(date +%s)
clear
source /home/abrax/bin/header.sh
REMOTE=sb2
top_header "SYNC.SH  ---  REMOTE: $REMOTE"
echo
echo "REMOTE: $REMOTE" 
echo
x=1
while [[ $x = "1" ]]; do
  echo -e "[R]estore or [C]reate? >> "; read -n 1 TASK; echo
  [[ $TASK = "r" ]] && x=0
  [[ $TASK = "c" ]] && x=0
done

x=1
while [[ $x = "1" ]]; do
  echo -e "Force? (y/n) >> "; read -n 1 FORCE; echo
  [[ $FORCE = y ]] && TYPE="" && x=0
  [[ $FORCE = n ]] && TYPE="--update" && x=0
done

echo TASK $TASK
### RESTORE
if [[ "$TASK" = "r" ]]; then
  header1 restore
  rclone copy $TYPE $REMOTE:sync.sh $HOME -P --progress-terminal-title --stats-one-line --filter-from $HOME/bin/sync.txt

### CREATE
elif [[ "$TASK" = "c" ]]; then
  header1 create
  header2 'tar ~/.ssh into ~/bin/dotfiles/ssh.age'; sleep 1
  tar cvz ~/.ssh | age -r age1slmkewad8snmwgv4tvsatekt5dp25ka5w6mvx0fw0qkuh67a74hslqmlnw >~/bin/dotfiles/ssh.age
  header2 "move $REMOTE:sync.sh to $REMOTE:sync.sh_backup/$ts"; sleep 1
  printf "==> "; rclone move $REMOTE:sync.sh $REMOTE:sync.sh_backup/$ts -P --progress-terminal-title --stats-one-line
  header2 "copy $HOME ~/bin/dotfiles"; sleep 1
  printf "==> "; rclone copy $HOME ~/bin/dotfiles -P --progress-terminal-title --stats-one-line --filter-from $HOME/bin/sync.txt

  header2 "git backup ~/bin"; sleep 1
  cd ~/bin
  git add . && git commit -m "auto commit dotfiles" && git push
  header2 "rclone sync $TYPE $HOME $HOME/bin/dotfiles "; sleep 1
  printf "==> "; rclone sync $TYPE $HOME $HOME/bin/dotfiles -P --progress-terminal-title --stats-one-line --filter-from $HOME/bin/sync.txt
  cd ~/bin
  git add . && git commit -m "auto commit dotfiles" && git push
  header2 "rclone copy $TYPE $HOME $REMOTE:sync.sh"; sleep 1
  printf "==> "; rclone copy $TYPE $HOME $REMOTE:sync.sh -P --progress-terminal-title --stats-one-line --filter-from $HOME/bin/sync.txt
fi

header1 done

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
#!/bin/bash

# HISHTORY
curl https://hishtory.dev/install.py | python3 -
hishtory init $YOUR_HISHTORY_SECRET

#!/bin/bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull llama3
