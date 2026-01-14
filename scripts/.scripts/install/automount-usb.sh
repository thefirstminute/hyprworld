#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm udisks2 udiskie

mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/udiskie.service <<'EOF'
[Unit]
Description=Automount USB drives

[Service]
ExecStart=/usr/bin/udiskie --no-tray --notify

[Install]
WantedBy=default.target
EOF

systemctl --user enable --now udiskie.service

