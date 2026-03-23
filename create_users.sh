#!/bin/bash
# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Kontrollera att minst en användare skickats in
if [ $# -eq 0 ]; then
    exit 1
fi

# Skapa användare från argument
for username in "$@"; do
    useradd -m -U "$username" 2>/dev/null

    home_dir="/home/$username"

    # Skapa kataloger
    mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Sätt ägarskap
    chown -R "$username:$username" "$home_dir"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    # Skapa welcome.txt
    echo "Välkommen $username" > "$home_dir/welcome.txt"
    awk -F: -v current="$username" '$1 != current { print $1 }' /etc/passwd >> "$home_dir/welcome.txt"

    # Sätt ägare och rättigheter på welcome.txt
    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"
done

