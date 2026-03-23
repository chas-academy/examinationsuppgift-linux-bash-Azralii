
#!/bin/bash

# Skapar användare, hemkatalog, undermappar och welcome.txt
# Endast root får köra scriptet.

if [ "$EUID" -ne 0 ]; then
    echo "Fel: endast root får köra detta script."
    exit 1
fi

if [ "$#" -eq 0 ]; then
    echo "Användning: $0 användare1 användare2 ..."
    exit 1
fi

for username in "$@"; do
    # Lista användare som redan finns innan ny användare skapas
    existing_users=$(cut -d: -f1 /etc/passwd)

    # Skapa användare med hemkatalog och egen grupp
    useradd -m -U "$username" || continue

    # Hämta användarens hemkatalog från systemet
    home_dir=$(getent passwd "$username" | cut -d: -f6)

    # Skapa undermappar
    mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

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
