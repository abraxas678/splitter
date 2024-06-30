#!/bin/bash

# Change directory
cd /home/abrax/tmp/splitter

[[ ! -f /usr/local/bin/db ]] && cp db /usr/local/bin

# Run Python script
python rename_sequential.py


# Define function to create the sheet
mysheet2() {
    cp mysheet.csv mysheet2.csv
    sed -i 's/, 1/, \[green\]1\[\/green\]/; s/, 0/, \[red\]0\[\/red\]/' mysheet2.csv
    rich mysheet2.csv
    echo
}

mysheet() {
  # Create list of scripts
  ls *.sh | grep -v "create_script.sh" > myfiles
    rm -f mysheet2.csv
    rm -f mysheet.csv
    x=1
    while IFS= read -r line; do
        [[ ${#x} = 1 ]] && xx="0$x" || xx=$x
        echo "$xx, $(db get splitter_state.db $line), $line" >> mysheet.csv
        x=$((x+1))
    done < myfiles
    mysheet2
}

# Call mysheet function
mysheet
y=1
# Loop for interactive menu
while [[ $y = 1 ]]; do
    mysheet2
    read -n 1 -p "[m]ove [r]ename [c]at [n]ano [d]one [#] >> " ANS1
    LET=$(/home/abrax/bin/letter_or_number.sh "$ANS1")
    [[ "$LET" = *"number"* ]] &&  read -n 1  ANS2 && ANS="$ANS1$ANS2" || ANS=$ANS1
    echo
    if [[ $ANS = r ]]; then
        read -n 2 -p "# >> " NUM
        read -p "new name: >> " NEWNAME
        FILE=$(cat mysheet.csv | grep "^$NUM" | awk '{print $3}')
        mv "$FILE" "$NEWNAME"
    elif [[ $ANS = n ]]; then
        echo n
    elif [[ $ANS = m ]]; then
        read -p "MOVE # >> " M1
        read -p "MOVE TO # >> " M2
        [[ ${#M1} = 1 ]] && M1="0$M1"
        [[ ${#M2} = 1 ]] && M2="0$M2"
        LINE1=$(cat mysheet.csv | grep "^$M1" | awk '{print $3}')
        LINE2=$(cat mysheet.csv | grep "^$M2" | awk '{print $3}')

        # Rename files
        original_filename1="$LINE2"
        new_filename1="${original_filename1:3}"
        mv "$original_filename1" "rename-$new_filename1"

        original_filename2="$LINE1"
        new_filename2="${original_filename2:3}"
        mv "$original_filename2" "$M2"_"$new_filename2"

        TARGET="$M1"_"$new_filename1"
        mv "rename-$new_filename1" "$TARGET"

        mysheet
### DONE
    elif [[ $ANS = d ]]; then
      rm execute.sh
      db list splitter_state.db | sort >myitems
      echo; cat myitems; echo
        while IFS= read -r line; do
            [[ $(db get splitter_state.db $line) = 1 ]] && cat $line >>execute.sh
        done < myitems
      rm -f myitems
      echo; rich --pager -p "$(cat execute.sh)" -a rounded -s green
      chmod +x *.sh
     ./execute.sh
      read me
    elif [[ $ANS = c ]]; then
        read -p "# >>" NUM
        batcat "$(cat mysheet.csv | grep "^$NUM" | awk '{print $3}')"
    else
      #  STATE=$(cat mysheet.csv | grep "^$ANS," | awk '{print $2}' | sed "s/,//")
        FILE=$(cat mysheet.csv | grep "^$ANS," | awk '{print $3}' | sed "s/,//")
        STATE=$(db get splitter_state.db $FILE)
        [[ $STATE = 0 ]] && NEWSTATE=1 || NEWSTATE=0
        mysheet
        db put splitter_state.db $FILE $NEWSTATE
#        sed "s/^$ANS, $STATE/$ANS, $NEWSTATE/" -i mysheet.csv
        mysheet
    fi
done

# Cleanup
sleep 1
rm -f myfiles
mysheet
