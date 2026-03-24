#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: endast root får köra detta script."
    exit 1
fi

for username in "$@"; do

    # Lista befintliga användare
    users=$(cut -d: -f1 /etc/passwd)

    # 🔥 VIKTIGT
    sudo useradd -m "$username"

    home="/home/$username"

    # Skapa mappar
    mkdir "$home/Documents"
    mkdir "$home/Downloads"
    mkdir "$home/Work"

    # Skapa welcome.txt
    echo "Välkommen $username" > "$home/welcome.txt"
    echo "$users" >> "$home/welcome.txt"

    # Sätt ägare
    chown -R "$username:$username" "$home"

    # Rättigheter
    chmod 700 "$home/Documents"
    chmod 700 "$home/Downloads"
    chmod 700 "$home/Work"
    chmod 600 "$home/welcome.txt"

done
