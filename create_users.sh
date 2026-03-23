#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: Scriptet måste köras som root."
    exit 1
fi

# Kontrollera att minst en användare skickats in
if [ "$#" -lt 1 ]; then
    echo "Användning: $0 användare1 användare2 ..."
    exit 1
fi

# Loopa igenom alla användare
for username in "$@"; do
    # Spara vilka användare som redan finns innan ny användare skapas
    existing_users=$(cut -d: -f1 /etc/passwd)

    # Skapa användaren om den inte inte redan finns
    if ! id "$username" >/dev/null 2>&1; then
        useradd -m "$username"
    fi

    # Hämta faktisk hemkatalog från systemet
    home_dir=$(getent passwd "$username" | cut -d: -f6)

    # Skapa mappar
    mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Skapa welcome.txt
    {
        echo "Välkommen $username"
        echo "$existing_users"
    } > "$home_dir/welcome.txt"

    # Sätt ägarskap och filrättigheter
    chown -R "$username:$username" "$home_dir"
    chmod 600 "$home_dir/welcome.txt"
done
