#!/bin/bash

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Scriptet måste köras som root."
  exit 1
fi

USERNAME="studentuser"
HOME_DIR="/home/$USERNAME"

# Skapa användare med hemkatalog
if ! id "$USERNAME" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "$USERNAME"
fi

# Skapa undermappar
mkdir -p "$HOME_DIR/documents"
mkdir -p "$HOME_DIR/scripts"
mkdir -p "$HOME_DIR/logs"

# Sätt ägare
chown -R "$USERNAME:$USERNAME" "$HOME_DIR"

# Endast ägare ska ha rättigheter
chmod 700 "$HOME_DIR"
chmod 700 "$HOME_DIR/documents"
chmod 700 "$HOME_DIR/scripts"
chmod 700 "$HOME_DIR/logs"

# Skapa välkomstfil
cat > "$HOME_DIR/welcome.txt" <<EOF
Välkommen $USERNAME!
Din användare har skapats.
Dina mappar är:
- documents
- scripts
- logs
EOF

# Sätt rätt ägare och rättigheter på filen
chown "$USERNAME:$USERNAME" "$HOME_DIR/welcome.txt"
chmod 600 "$HOME_DIR/welcome.txt"

echo "Klart."
