#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Loop genom alla användare
for username in "$@"; do

    # Skapa användare
    useradd -m "$username" 2>/dev/null

    home_dir="/home/$username"

    # Skapa mappar
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Rätt ägare
    chown -R "$username:$username" "$home_dir"

    # Rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # welcome.txt
    echo "Välkommen $username" > "$home_dir/welcome.txt"
    awk -F: '{print $1}' /etc/passwd >> "$home_dir/welcome.txt"

    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"

done
