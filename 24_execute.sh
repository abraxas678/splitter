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

# Color definitions

#!/bin/bash
#3. APT update -- check last update time

ts=$(date +%s)

if [[ -f ~/last_apt_update.txt ]]; then
  DIFF=$(($ts - $(cat ~/last_apt_update.txt)))
  if [[ $DIFF -gt 6000 ]]; then
    sudo apt update && sudo apt upgrade -y
  fi
else
  sudo apt update && sudo apt upgrade -y
fi

echo $ts > ~/last_apt_update.txt

sudo apt install -y unzip curl wget nano

[[ ! -f Terminus.zip ]] && [[ ! -d Terminus ]] && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Terminus.zip && unzip Terminus.zip && sudo mv *.ttf /usr/share/fonts/truetype && sudo fc-cache -fv
#!/bin/bash
#12. User setup
# Task: Check if user is 'abrax'
# TASK "CHECK: USER = abrax?"
if [[ $USER != *"abrax"* ]]; then
sudo apt install -y sudo
if [[ $USER == *"root"* ]]; then
su abrax
adduser abrax
usermod -aG sudo abrax
su abrax
exit
else
su abrax
sudo adduser abrax
sudo usermod -aG sudo abrax
su abrax
exit
fi
fi

#!/bin/bash
#5. Check Machine Name

# Change machine name
#header2 "change machine name"
cd $HOME
curl -sL machine.yyps.de > machine.sh
chmod +x machine.sh
./machine.sh
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
curl https://hishtory.dev/install.py | python3 -
hishtory init $YOUR_HISHTORY_SECRET


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
#10. Homebrew Setup and Hombrew app install

# Install Homebrew and its dependencies
brew_install() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  sudo apt-get install -y build-essential
  brew install gcc
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $MYHOME/.zshrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  exec zsh
  export ANS=n
}

# Install Homebrew if not already installed
which brew > /dev/null
if [[ $? != 0 ]]; then
  echo -e "${YELLOW}INSTALL: Homebrew${RESET}"
  countdown 1
  brew_install
fi

# Install utilities using Homebrew

while IFS= read -r line; do
  [[ $line != "#"* ]] && brew install $line
done < 	brew_all_multi.txt

#!/bin/bash
#6. github and gh setup

installme git
installme gh

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
gh repo clone abraxas678/.config
sleep 1
fi

# Set permissions for bin scripts
chmod +x ~/bin/*
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
#!/bin/bash
#9. Python3 install + Apps

# Install Python packages using pipx

  while IFS= read -r line; do
    [[ $line != "#"* ]] && pipx install $line
  done <  python_apps_all_multi.txt 
