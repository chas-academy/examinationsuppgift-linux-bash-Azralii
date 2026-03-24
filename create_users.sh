#!/bin/bash

# Skapar användare, hemkatalog, mappar och welcome.txt
# Endast root får köra scriptet

if [ "$EUID" -ne 0 ]; then
    echo "Fel: endast root får köra detta script."
    exit 1
fi

for username in "$@"; do
    existing_users=$(cut -d: -f1 /etc/passwd)

    useradd -m "$username"

    home_dir="/home/$username"

    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    echo "Välkommen $username" > "$home_dir/welcome.txt"
    echo "$existing_users" >> "$home_dir/welcome.txt"

    chown -R "$username:$username" "$home_dir"

    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"
    chmod 600 "$home_dir/welcome.txt"
done
