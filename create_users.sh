#!/bin/bash

# Avbryt vid fel
set -e

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Detta script måste köras som root."
    exit 1
fi

# Kontrollera att ett användarnamn skickats in
if [ -z "$1" ]; then
    echo "Användning: $0 <användarnamn>"
    exit 1
fi

USERNAME="$1"
HOME_DIR="/home/$USERNAME"
WELCOME_FILE="$HOME_DIR/valkommen.txt"

# Skapa användaren om den inte redan finns
if id "$USERNAME" >/dev/null 2>&1; then
    echo "Användaren $USERNAME finns redan."
else
    useradd -m "$USERNAME"
    echo "Användaren $USERNAME skapades."
fi

# Skapa undermappar
mkdir -p "$HOME_DIR/dokument"
mkdir -p "$HOME_DIR/bilder"
mkdir -p "$HOME_DIR/ovningar"

# Sätt ägarskap
chown -R "$USERNAME:$USERNAME" "$HOME_DIR"

# Sätt rättigheter: endast ägaren ska ha tillgång
chmod 700 "$HOME_DIR/dokument"
chmod 700 "$HOME_DIR/bilder"
chmod 700 "$HOME_DIR/ovningar"

# Skapa välkomstfil med innehåll
cat > "$WELCOME_FILE" <<EOF
Välkommen $USERNAME!

Dina mappar har skapats:
- dokument
- bilder
- ovningar

Lycka till!
EOF

# Sätt rättigheter och ägare på filen
chown "$USERNAME:$USERNAME" "$WELCOME_FILE"
chmod 600 "$WELCOME_FILE"

echo "Klart! Konto, mappar, rättigheter och välkomstfil är skapade."
