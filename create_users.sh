#!/bin/bash

# ==========================================
# Script: create_users.sh
# Beskrivning:
# Skapar användare utifrån argument som skickas in,
# skapar kataloger i hemkatalogen och en personlig
# welcome.txt med information om andra användare.
# Endast root får köra scriptet.
# ==========================================

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: Endast root får köra detta script."
    exit 1
fi

# Kontrollera att minst ett användarnamn har skickats in
if [ "$#" -eq 0 ]; then
    echo "Användning: $0 användare1 användare2 användare3"
    exit 1
fi

# Loopa igenom alla användarnamn som skickats in
for username in "$@"; do

    # Kontrollera om användaren redan finns
    if id "$username" >/dev/null 2>&1; then
        echo "Användaren $username finns redan. Hoppar över."
        continue
    fi

    # Hämta lista på befintliga användare innan ny användare skapas
    existing_users=$(cut -d: -f1 /etc/passwd)

    # Skapa användaren med hemkatalog
    useradd -m "$username"

    # Kontrollera att användaren skapades korrekt
    if [ $? -ne 0 ]; then
        echo "Fel: Kunde inte skapa användaren $username."
        continue
    fi

    # Sätt hemkatalog-variabel
    home_dir="/home/$username"

    # Skapa undermappar
    mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Skapa welcome.txt
    {
        echo "Välkommen $username"
        echo "Andra användare som redan finns i systemet:"
        for user in $existing_users; do
            echo "$user"
        done
    } > "$home_dir/welcome.txt"

    # Sätt ägare på filer och mappar
    chown -R "$username:$username" "$home_dir"

    # Sätt rättigheter:
    # Endast ägaren får läsa, skriva och gå in i mapparna
    chmod 700 "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # welcome.txt: endast ägaren får läsa och skriva
    chmod 600 "$home_dir/welcome.txt"

    echo "Användaren $username skapades korrekt."

done
