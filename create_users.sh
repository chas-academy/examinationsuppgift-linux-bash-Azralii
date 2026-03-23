
    #!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Skapa användare från argument
for username in "$@"; do
    useradd -m -U --badname "$username"

    home_dir="/home/$username"

    mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"
    chown -R "$username:$username" "$home_dir"
    chmod 700 "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

    {
        echo "Välkommen $username"
        awk -F: -v user="$username" '$1 != user { print $1 }' /etc/passwd
    } > "$home_dir/welcome.txt"

    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"
done

