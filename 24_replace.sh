PMANAGER=dnf
#!/bin/bash

# Define the replacement variable
PMANAGER=dnf

# Loop through all .sh files in the current directory
for file in *.sh; do
    # Check if the file contains "$PMANAGER"
    if grep -q "$PMANAGER" "$file"; then
        # Replace "$PMANAGER" with "$PMANAGER" and save to a temporary file
        sed 's/$PMANAGER/$PMANAGER/g' "$file" > tmpfile

        # Add "PMANAGER=dnf" at the beginning of the temporary file
        echo "PMANAGER=dnf" | cat - tmpfile > "$file"

        # Clean up the temporary file
        rm tmpfile

        echo "Updated $file"
    fi
done
