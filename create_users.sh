#!/bin/bash

# ==========================================
# Script: create_users.sh
# Beskrivning:
# Skapar användare från argument på kommandoraden,
# skapar katalogerna Documents, Downloads och Work
# i varje användares hemkatalog samt en personlig
# welcome.txt.
# Endast root får köra scriptet.
# ==========================================

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: Endast root får köra detta script."
    exit 1
fi

# Kontrollera att minst en användare skickats in
if [ "$#" -eq 0 ]; then
    echo "Användning: $0 användare1 användare2 ..."
    exit 1
fi

# Loopa igenom alla användarnamn
for username in "$@"; do
    # Skapa användaren bara om den inte redan finns
    if ! id "$username" >/dev/null 2>&1; then
        useradd -m "$username"
        if [ $? -ne 0 ]; then
            echo "Fel: Kunde inte skapa användaren $username"
            continue
        fi
    fi

    # Hämta hemkatalogen från systemet istället för att hårdkoda /home/användare
    home_dir=$(getent passwd "$username" | cut -d: -f6)

    # Om hemkatalogen inte kunde hämtas, hoppa över användaren
    if [ -z "$home_dir" ]; then
        echo "Fel: Kunde inte hitta hemkatalog för $username"
        continue
    fi

    # Skapa undermappar
    mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Sätt rätt ägare på mapparna
    chown "$username:$username" "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Endast ägaren får läsa/skriva/öppna mapparna
    chmod 700 "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Skapa welcome.txt
    {
        echo "Välkommen $username"
        grep -v "^$username:" /etc/passwd | cut -d: -f1
    } > "$home_dir/welcome.txt"

    # Sätt rätt ägare och rättigheter på welcome.txt
    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"
done
