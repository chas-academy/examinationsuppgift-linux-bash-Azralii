#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
    echo "Endast root!"
    exit 1
fi

# Loop
for username in "$@"; do

    # Spara befintliga användare
    users=$(cut -d: -f1 /etc/passwd)

    # Skapa användare
    useradd -m -U "$username"

    # Hämta hemkatalog
    home=$(getent passwd "$username" | cut -d: -f6)

    # Skapa mappar
    mkdir "$home/Documents"
    mkdir "$home/Downloads"
    mkdir "$home/Work"

    # Sätt rättigheter
    chmod 700 "$home/Documents"
    chmod 700 "$home/Downloads"
    chmod 700 "$home/Work"

    # welcome.txt
    echo "Välkommen $username" > "$home/welcome.txt"
    echo "$users" >> "$home/welcome.txt"

    # ägare
    chown -R "$username:$username" "$home"

    # rättigheter fil
    chmod 600 "$home/welcome.txt"

done
