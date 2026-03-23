#!/bin/bash
# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Skapa användare från argument
for username in "$@"; do
    # Skapa grupp om den inte finns
    if ! getent group "$username" > /dev/null 2>&1; then
        groupadd "$username"
    fi

    # Skapa användare om den inte finns
    if ! id "$username" > /dev/null 2>&1; then
        useradd -m -g "$username" "$username"
    fi

    home_dir="/home/$username"

    # Skapa kataloger
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Sätt ägarskap och rättigheter
    chown -R "$username:$username" "$home_dir"
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Skapa welcome.txt
    {
        echo "Välkommen $username"
        awk -F: -v user="$username" '$1 != user { print $1 }' /etc/passwd
    } > "$home_dir/welcome.txt"

    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"
done

