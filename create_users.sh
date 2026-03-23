#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
    echo "Endast root!"
    exit 1
fi

# Loop genom användare
for username in "$@"; do

    # Skapa användare
    useradd -m -U "$username"

    # Hämta hemkatalog
    home_dir=$(getent passwd "$username" | cut -d: -f6)

    # Skapa mappar
    mkdir "$home_dir/Documents"
    mkdir "$home_dir/Downloads"
    mkdir "$home_dir/Work"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Lista andra användare
    other_users=$(cut -d: -f1 /etc/passwd | grep -v "^$username$")

    # Skapa welcome.txt
    echo "Välkommen $username" > "$home_dir/welcome.txt"
    echo "$other_users" >> "$home_dir/welcome.txt"

    # Sätt ägare
    chown -R "$username:$username" "$home_dir"

    # Rättigheter på fil
    chmod 600 "$home_dir/welcome.txt"

done
