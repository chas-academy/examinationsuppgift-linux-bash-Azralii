#!/bin/bash

# Kontrollera root
if [ "$EUID" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

USERNAME="student"

# Skapa användare
useradd -m "$USERNAME"

# Skapa mappar
mkdir /home/$USERNAME/documents
mkdir /home/$USERNAME/scripts
mkdir /home/$USERNAME/logs

# Sätt rättigheter (endast ägare)
chmod 700 /home/$USERNAME
chmod 700 /home/$USERNAME/documents
chmod 700 /home/$USERNAME/scripts
chmod 700 /home/$USERNAME/logs

# Sätt ägare
chown -R $USERNAME:$USERNAME /home/$USERNAME

# Skapa välkomstfil
echo "Welcome $USERNAME" > /home/$USERNAME/welcome.txt

# Rättigheter på fil
chmod 600 /home/$USERNAME/welcome.txt
chown $USERNAME:$USERNAME /home/$USERNAME/welcome.txt
