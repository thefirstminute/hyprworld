#!/bin/bash

# Automated Lan Mouse install for MX-Linux (Debian-based) client

# Update system and install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install git curl build-essential libadwaita-1-dev libgtk-4-dev libx11-dev libxtst-dev ufw -y

# Install Rust if not present
if ! command -v cargo &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

# Build from source with X11 features
git clone https://github.com/feschber/lan-mouse.git
cd lan-mouse
cargo build --release --features x11_capture,x11_emulation
sudo cp target/release/lan-mouse /usr/local/bin/
cd ..
rm -rf lan-mouse

# Install desktop integration
sudo mkdir -p /usr/local/share/icons/hicolor/scalable/apps
curl -s https://raw.githubusercontent.com/feschber/lan-mouse/main/lan-mouse-gtk/resources/de.feschber.LanMouse.svg -o lan-mouse.svg
sudo mv lan-mouse.svg /usr/local/share/icons/hicolor/scalable/apps/de.feschber.LanMouse.svg
sudo gtk-update-icon-cache /usr/local/share/icons/hicolor/

sudo mkdir -p /usr/local/share/applications
curl -s https://raw.githubusercontent.com/feschber/lan-mouse/main/de.feschber.LanMouse.desktop -o desktop_entry.desktop
sudo mv desktop_entry.desktop /usr/local/share/applications/de.feschber.LanMouse.desktop

# Firewall: Open UDP 4242 (outbound usually open, but allow inbound for flexibility)
sudo ufw allow 4242/udp
sudo ufw reload
sudo ufw enable  # If not already enabled; answer 'y' if prompted

# Create minimal config (client-side)
mkdir -p ~/.config/lan-mouse
cat << EOF > ~/.config/lan-mouse/config.toml
port = 4242
EOF

echo "Installation complete. Launch with 'lan-mouse'. Accept incoming connection from server (192.168.1.130)."
