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

# Loopa igenom alla användarnamn som skickats in
for username in "$@"; do
    # Skapa användaren med hemkatalog om den inte redan finns
    if ! id "$username" >/dev/null 2>&1; then
        useradd -m "$username"
    fi

    home_dir="/home/$username"

    # Skapa katalogstruktur
    mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Sätt ägarskap
    chown -R "$username:$username" "$home_dir"

    # Sätt rättigheter så endast ägaren har åtkomst
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Skapa welcome.txt
    {
        echo "Välkommen $username"
        echo
        echo "Andra användare i systemet:"
        cut -d: -f1 /etc/passwd | grep -v "^$username$"
    } > "$home_dir/welcome.txt"

    # Sätt rätt ägare på filen
    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 644 "$home_dir/welcome.txt"
done
