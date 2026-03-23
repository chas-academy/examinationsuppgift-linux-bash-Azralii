#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Loop genom alla användare
for username in "$@"; do

    # Skapa användare + hemkatalog
    useradd -m "$username"

    home_dir="/home/$username"

    # Skapa mappar
    mkdir "$home_dir/Documents"
    mkdir "$home_dir/Downloads"
    mkdir "$home_dir/Work"

    # Ägarskap
    chown -R "$username:$username" "$home_dir"

    # Rättigheter (endast ägare)
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # welcome.txt (EXAKT format viktigt!)
    echo "Välkommen $username" > "$home_dir/welcome.txt"
    awk -F: '{print $1}' /etc/passwd >> "$home_dir/welcome.txt"

    # Rättigheter på fil
    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"

done
