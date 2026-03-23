#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Skapa användare från argument
for username in "$@"; do
    useradd -m "$username"

    home_dir="/home/$username"

    # Skapa kataloger
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Sätt ägarskap
    chown "$username:$username" "$home_dir/Documents"
    chown "$username:$username" "$home_dir/Downloads"
    chown "$username:$username" "$home_dir/Work"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Skapa welcome.txt
    echo "Välkommen $username" > "$home_dir/welcome.txt"
    awk -F: -v user="$username" '$1 != user {print $1}' /etc/passwd >> "$home_dir/welcome.txt"

    # Sätt ägare och rättigheter på welcome.txt
    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"
done
