PMANAGER=dnf
#!/bin/bash
clear
command -v age >/dev/null 2>&1 || { echo >&2 "age is not installed. Installing..."; sleep 2; sudo $PMANAGER-get update && sudo $PMANAGER-get install -y age; }
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

