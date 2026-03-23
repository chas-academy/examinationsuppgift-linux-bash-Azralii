#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: endast root får köra scriptet."
    exit 1
fi

# Kontrollera att minst ett användarnamn skickats in
if [ "$#" -eq 0 ]; then
    echo "Användning: $0 användare1 användare2 ..."
    exit 1
fi

# Loopa igenom alla användarnamn
for username in "$@"; do
    # Hämta lista på befintliga användare innan ny användare skapas
    existing_users=$(cut -d: -f1 /etc/passwd)

    # Skapa användaren med hemkatalog och egen grupp
    useradd -m -U "$username"

    # Hämta hemkatalog från systemet
    home_dir=$(getent passwd "$username" | cut -d: -f6)

    # Skapa undermappar
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Skapa welcome.txt
    echo "Välkommen $username" > "$home_dir/welcome.txt"
    echo "$existing_users" >> "$home_dir/welcome.txt"

    # Sätt ägare
    chown -R "$username:$username" "$home_dir"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"
    chmod 600 "$home_dir/welcome.txt"
done
