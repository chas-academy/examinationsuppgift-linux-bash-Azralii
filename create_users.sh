#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: endast root får köra detta script."
    exit 1
fi

# Skapa användare från argumenten
for username in "$@"; do
    # Spara lista på användare som redan finns
    existing_users=$(cut -d: -f1 /etc/passwd)

    # Skapa användaren med hemkatalog
    useradd -m "$username"

    # Använd standard hemkatalog
    home_dir="/home/$username"

    # Skapa undermappar
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Skapa välkomstfil
    echo "Välkommen $username" > "$home_dir/welcome.txt"
    echo "$existing_users" >> "$home_dir/welcome.txt"

    # Sätt ägare
    chown -R "$username:$username" "$home_dir"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"
    chmod 600 "$home_dir/welcome.txt"
