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

# Loopa igenom alla användarnamn
for username in "$@"; do
    # Spara lista på befintliga användare innan ny användare skapas
    existing_users=$(cut -d: -f1 /etc/passwd)

    # Skapa användaren med hemkatalog om den inte finns
    if ! id "$username" >/dev/null 2>&1; then
        useradd -m "$username"
    fi

    # Hämta användarens riktiga hemkatalog från systemet
    home_dir=$(getent passwd "$username" | cut -d: -f6)

    # Skapa katalogerna
    mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Sätt ägarskap
    chown -R "$username:$username" "$home_dir"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Skapa welcome.txt
    {
        echo "Välkommen $username"
        echo "$existing_users"
    } > "$home_dir/welcome.txt"

    # Sätt ägare och rättigheter på welcome.txt
    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"
done
