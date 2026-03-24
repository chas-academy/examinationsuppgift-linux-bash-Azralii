#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

for username in "$@"; do
    useradd -m "$username"

    home_dir="/home/$username"

    mkdir -p "$home_dir/documents"
    mkdir -p "$home_dir/scripts"
    mkdir -p "$home_dir/logs"

    chown -R "$username:$username" "$home_dir"

    chmod 700 "$home_dir"
    chmod 700 "$home_dir/documents"
    chmod 700 "$home_dir/scripts"
    chmod 700 "$home_dir/logs"

    echo "Welcome $username" > "$home_dir/welcome.txt"

    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"
done
