#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: endast root får köra detta script."
    exit 1
fi

for username in "$@"; do

    # Spara lista på befintliga användare
    existing_users=$(cut -d: -f1 /etc/passwd)

    # 🔥 VIKTIGT: använd full path
    /usr/sbin/useradd -m "$username"

    # Hämta hemkatalog från systemet (INTE hårdkoda)
    home_dir=$(getent passwd "$username" | cut -d: -f6)

    # Skapa mappar
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # welcome.txt
    echo "Välkommen $username" > "$home_dir/welcome.txt"
    echo "$existing_users" >> "$home_dir/welcome.txt"

    # Sätt ägare
    chown -R "$username:$username" "$home_dir"

    # Rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"
    chmod 600 "$home_dir/welcome.txt"

done
