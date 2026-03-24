#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: endast root får köra detta script."
    exit 1
fi

for username in "$@"; do

    # Lista användare innan skapande
    users=$(cut -d: -f1 /etc/passwd)

    # SKAPA ANVÄNDARE (VIKTIG RAD)
    useradd -m -s /bin/bash "$username"

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
