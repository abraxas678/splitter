#!/bin/bash
wget https://download-cdn.resilio.com/stable/debian/amd64/0/resilio-sync_2.8.1.1390-1_amd64.deb
sudo apt install -y ./resilio-sync_2.8.1.1390-1_amd64.deb
[[ $? = 0 ]] && rm resilio-sync_2.8.1.1390-1_amd64.deb

# If you want to run Sync under your current user - 
# edit file /usr/lib/systemd/user/resilio-sync.service and 
# change "WantedBy=multi-user.target" to "WantedBy=default.target". 
# Save this file and then enable the service with --user parameter:
sudo sed -i 's/WantedBy=multi-user.target/WantedBy=default.target/' /usr/lib/systemd/user/resilio-sync.service
sudo systemctl --machine=abrax@.host --user enable resilio-sync
