#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

USERNAME="$1"
HOME_DIR="/home/$USERNAME"

useradd -m "$USERNAME"

mkdir -p "$HOME_DIR/documents"
mkdir -p "$HOME_DIR/scripts"
mkdir -p "$HOME_DIR/logs"

chown -R "$USERNAME:$USERNAME" "$HOME_DIR"

chmod 700 "$HOME_DIR"
chmod 700 "$HOME_DIR/documents"
chmod 700 "$HOME_DIR/scripts"
chmod 700 "$HOME_DIR/logs"

echo "Welcome $USERNAME" > "$HOME_DIR/welcome.txt"

chown "$USERNAME:$USERNAME" "$HOME_DIR/welcome.txt"
chmod 600 "$HOME_DIR/welcome.txt"
