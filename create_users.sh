#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Skapa alla användare som skickas in som argument
for username in "$@"; do
    useradd -m "$username"

    home_dir="/home/$username"

    # Skapa kataloger
    mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Sätt ägare
    chown -R "$username:$username" "$home_dir"

    # Sätt rättigheter så bara ägaren kommer åt mapparna
    chmod 700 "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Skapa welcome.txt
    {
        echo "Välkommen $username"
        awk -F: -v current="$username" '$1 != current { print $1 }' /etc/passwd
    } > "$home_dir/welcome.txt"

    # Sätt rätt ägare och rättigheter på filen
    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"
done
