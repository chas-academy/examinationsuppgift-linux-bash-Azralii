​
#!/bin/bash

# =========================
# 1. Root-kontroll
# =========================
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# =========================
# 2. Kontroll: minst 1 argument
# =========================
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 username1 username2 ..."
    exit 1
fi

# =========================
# 3. Loop genom användare
# =========================
for username in "$@"; do

    # =========================
    # Skapa användare (om ej finns)
    # =========================
    if id "$username" &>/dev/null; then
        echo "User $username already exists"
    else
        useradd -m "$username"
        echo "Created user: $username"
    fi

    home_dir="/home/$username"

    # =========================
    # 4. Skapa kataloger (EXAKT lowercase)
    # =========================
    mkdir -p "$home_dir/documents" \
             "$home_dir/downloads" \
             "$home_dir/work"

    # =========================
    # 5. Sätt ägare
    # =========================
    chown -R "$username:$username" "$home_dir"

    # =========================
    # 6. Rättigheter (viktigt!)
    # =========================
    chmod 700 "$home_dir"
    chmod 700 "$home_dir/documents" \
              "$home_dir/downloads" \
              "$home_dir/work"

    # =========================
    # 7. Skapa welcome.txt
    # =========================
    {
        echo "Välkommen $username"
        awk -F: -v current="$username" '$1 != current { print $1 }' /etc/passwd
    } > "$home_dir/welcome.txt"

    # =========================
    # 8. Rättigheter på fil
    # =========================
    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"

done

