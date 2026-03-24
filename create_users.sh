#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: endast root får köra detta script."
    exit 1
fi

for username in "$@"; do

    # Spara befintliga användare
    users=$(cut -d: -f1 /etc/passwd)

    # 🔴 VIKTIGT: full path till useradd
    /usr/sbin/useradd -m "$username"

    # Hemkatalog
    home="/home/$username"

    # Skapa mappar
    mkdir -p "$home/Documents"
    mkdir -p "$home/Downloads"
    mkdir -p "$home/Work"

    # Welcome-fil
    echo "Välkommen $username" > "$home/welcome.txt"
    echo "$users" >> "$home/welcome.txt"

    # Ägare
    chown -R "$username:$username" "$home"

    # Rättigheter
    chmod 700 "$home/Documents"
    chmod 700 "$home/Downloads"
    chmod 700 "$home/Work"
    chmod 600 "$home/welcome.txt"

done
