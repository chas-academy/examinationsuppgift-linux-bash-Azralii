#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: Scriptet måste köras som root."
    exit 1
fi

# Kontrollera att minst en användare skickats in
if [ "$#" -lt 1 ]; then
    echo "Användning: $0 användare1 användare2 ..."
    exit 1
fi

# Spara användare som fanns innan scriptet startade
existing_users=$(getent passwd | cut -d: -f1)

# Loopa igenom alla användare
for username in "$@"; do
    # Skapa användaren om den inte redan finns
    if ! id "$username" >/dev/null 2>&1; then
        useradd -m -U -s /bin/bash "$username" || {
            echo "Fel: Kunde inte skapa användaren $username"
            continue
       #!/bin/bash

# Root-kontroll
if [ "$EUID" -ne 0 ]; then
    echo "Fel: Scriptet måste köras som root."
    exit 1
fi

# Minst en användare
if [ "$#" -lt 1 ]; then
    echo "Användning: $0 användare1 användare2 ..."
    exit 1
fi

# Spara befintliga användare (innan nya skapas)
existing_users=$(cut -d: -f1 /etc/passwd)

for username in "$@"; do

    # Skapa användare om den inte finns
    if ! id "$username" >/dev/null 2>&1; then
        useradd -m "$username"
    fi

    # Hemkatalog
    home_dir="/home/$username"

    # Skapa undermappar (EXAKTA namn!)
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # welcome.txt (EXAKT format viktigt)
    echo "Välkommen $username" > "$home_dir/welcome.txt"
    echo "$existing_users" >> "$home_dir/welcome.txt"

    # Rättigheter på fil
    chmod 600 "$home_dir/welcome.txt"

    # Ägarskap (kritisk fix!)
    chown -R "$username" "$home_dir"

done
