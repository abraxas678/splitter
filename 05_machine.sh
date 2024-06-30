#!/bin/bash
#5. Check Machine Name

# Change machine name
#header2 "change machine name"
curl -sL machine.yyps.de > mymachine.sh
chmod +x mymachine.sh
./mymachine.sh
