#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Loopa igenom alla användare som skickas in som argument
for username in "$@"; do
    useradd -m "$username"

    home_dir="/home/$username"

    # Skapa mappar
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Sätt ägare
    chown -R "$username:$username" "$home_dir"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Skapa welcome.txt
    echo "Välkommen $username" > "$home_dir/welcome.txt"

    # Lägg till alla användare i filen
    for other_user in "$@"; do
        echo "$other_user" >> "$home_dir/welcome.txt"
    done

    # Sätt ägare och rättigheter på filen
    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"
done
