#!/bin/bash

# Root-kontroll
if [ "$EUID" -ne 0 ]; then
    echo "Fel: Scriptet måste köras som root."
    exit 1
fi

# Minst en användare
if [ "$#" -lt 1 ]; then
    echo "Användning: $0 användare1 användare2 ..."
    exit 1
fi

# Spara befintliga användare innan nya skapas
existing_users=$(cut -d: -f1 /etc/passwd)

for username in "$@"; do
    # Skapa användare om den inte finns
    if ! id "$username" >/dev/null 2>&1; then
        useradd -m "$username"
    fi

    # Hemkatalog
    home_dir="/home/$username"

    # Skapa undermappar
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Skapa welcome.txt
    echo "Välkommen $username" > "$home_dir/welcome.txt"
    echo "$existing_users" >> "$home_dir/welcome.txt"

    # Sätt rättigheter på welcome.txt
    chmod 600 "$home_dir/welcome.txt"

    # Sätt ägarskap
    chown -R "$username" "$home_dir"
done
