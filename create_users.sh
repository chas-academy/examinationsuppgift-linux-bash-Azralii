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

# Spara vilka användare som fanns innan scriptet började
existing_users=$(cut -d: -f1 /etc/passwd)

# Loopa igenom alla användare
for username in "$@"; do
    # Skapa användaren om den inte redan finns
    if ! id "$username" >/dev/null 2>&1; then
        useradd -m "$username" || {
            echo "Fel: Kunde inte skapa användaren $username"
            continue
        }
    fi

    # Hämta faktisk hemkatalog från systemet
    home_dir=$(getent passwd "$username" | cut -d: -f6)

    if [ -z "$home_dir" ]; then
        echo "Fel: Kunde inte hitta hemkatalog för $username"
        continue
    fi

    # Skapa mappar
    mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Skapa welcome.txt
    {
        echo "Välkommen $username"
        echo "$existing_users"
    } > "$home_dir/welcome.txt"

    # Sätt ägarskap och filrättigheter
    chown -R "$username:$(id -gn "$username")" "$home_dir"
    chmod 600 "$home_dir/welcome.txt"
done
