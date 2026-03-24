
#!/bin/bash

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Du måste köra scriptet som root."
  exit 1
fi

USERNAME="student"
HOME_DIR="/home/$USERNAME"

if ! id "$USERNAME" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "$USERNAME"
fi

mkdir -p "$HOME_DIR/documents"
mkdir -p "$HOME_DIR/scripts"
mkdir -p "$HOME_DIR/logs"

chown -R "$USERNAME:$USERNAME" "$HOME_DIR"

chmod 700 "$HOME_DIR"
chmod 700 "$HOME_DIR/documents"
chmod 700 "$HOME_DIR/scripts"
chmod 700 "$HOME_DIR/logs"

cat > "$HOME_DIR/welcome.txt" <<EOF
Welcome $USERNAME
EOF

chown "$USERNAME:$USERNAME" "$HOME_DIR/welcome.txt"
chmod 600 "$HOME_DIR/welcome.txt"

echo "Klart"
