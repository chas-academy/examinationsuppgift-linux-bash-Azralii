
#!/bin/bash
# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Skapa användare från argument
for username in "$@"; do
    useradd -m "$username"

    mkdir -p "/home/$username/Documents"
    mkdir -p "/home/$username/Downloads"
    mkdir -p "/home/$username/Work"

    chown -R "$username:$username" "/home/$username"

    chmod 700 "/home/$username/Documents"
    chmod 700 "/home/$username/Downloads"
    chmod 700 "/home/$username/Work"

    echo "Välkommen $username" > "/home/$username/welcome.txt"
    awk -F: '{print $1}' /etc/passwd >> "/home/$username/welcome.txt"

    chown "$username:$username" "/home/$username/welcome.txt"
    chmod 600 "/home/$username/welcome.txt"
done

