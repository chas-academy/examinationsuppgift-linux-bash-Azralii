#!/bin/bash

set -euo pipefail

# Root-kontroll
if [ "$EUID" -ne 0 ]; then
  echo "Detta script måste köras som root."
  exit 1
fi

USERNAME="${1:-studentuser}"

# Skapa användare om den inte inte redan finns
if ! id "$USERNAME" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "$USERNAME"
fi

HOME_DIR="/home/$USERNAME"

# Skapa undermappar
mkdir -p "$HOME_DIR/documents" "$HOME_DIR/scripts" "$HOME_DIR/logs"

# Sätt ägare
chown -R "$USERNAME:$USERNAME" "$HOME_DIR"

# Rättigheter: endast ägare
chmod 700 "$HOME_DIR"
chmod 700 "$HOME_DIR/documents"
chmod 700 "$HOME_DIR/scripts"
chmod 700 "$HOME_DIR/logs"

# Skapa välkomstfil
WELCOME_FILE="$HOME_DIR/welcome.txt"
cat > "$WELCOME_FILE" <<EOF
Välkommen $USERNAME!

Din användare har skapats korrekt.
Mappar som skapats:
- documents
- scripts
- logs
EOF

# Sätt ägare och rättigheter på välkomstfil
chown "$USERNAME:$USERNAME" "$WELCOME_FILE"
chmod 600 "$WELCOME_FILE"

echo "Klart: användaren $USERNAME är skapad med mappar och välkomstfil."
