#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Skapa användare från argument
for username in "$@"; do
    # Skapa användaren med hemkatalog och egen grupp
    useradd -m -U --badname "$username"

    home_dir="/home/$username"

    # Skapa kataloger
    mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Sätt ägarskap
    chown -R "$username:$username" "$home_dir"

    # Sätt rättigheter så bara ägaren kommer åt mapparna
    chmod 700 "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Skapa welcome.txt
    {
        echo "Välkommen $username"
        awk -F: -v user="$username" '$1 != user { print $1 }' /etc/passwd
    } > "$home_dir/welcome.txt"

    # Sätt ägare och rättigheter på welcome.txt
    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"
done

