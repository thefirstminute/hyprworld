#!/bin/bash

# Automated Lan Mouse install for CachyOS (Arch-based) Hyprland server

# Update system and install dependencies
sudo pacman -Syu --noconfirm
sudo pacman -S git rustup base-devel libadwaita gtk4 libx11 libxtst firewalld --noconfirm

# Install stable from repos if available, else build from source
if ! pacman -Ss lan-mouse | grep -q installed; then
  if pacman -Ss lan-mouse >/dev/null 2>&1; then
    sudo pacman -S lan-mouse --noconfirm
  else
    # Build from source with Hyprland features
    git clone https://github.com/feschber/lan-mouse.git
    cd lan-mouse
    rustup default stable
    cargo build --release --features hyprland_capture,hyprland_emulation,wlroots_capture,wlroots_emulation,layer_shell_capture
    sudo cp target/release/lan-mouse /usr/local/bin/
    cd ..
    rm -rf lan-mouse
  fi
fi

# Install desktop integration
sudo mkdir -p /usr/local/share/icons/hicolor/scalable/apps
wget https://raw.githubusercontent.com/feschber/lan-mouse/main/lan-mouse-gtk/resources/de.feschber.LanMouse.svg -O lan-mouse.svg
sudo mv lan-mouse.svg /usr/local/share/icons/hicolor/scalable/apps/de.feschber.LanMouse.svg
sudo gtk-update-icon-cache /usr/local/share/icons/hicolor/

sudo mkdir -p /usr/local/share/applications
wget https://raw.githubusercontent.com/feschber/lan-mouse/main/de.feschber.LanMouse.desktop -O desktop_entry.desktop
sudo mv desktop_entry.desktop /usr/local/share/applications/de.feschber.LanMouse.desktop

# Firewall: Open UDP 4242
sudo ufw allow 4242/udp comment 'LAN-mouse custom port'

# Reload firewall to apply changes
sudo ufw reload

# Confirm status
sudo ufw status verbose


# Create basic config
mkdir -p ~/.config/lan-mouse
cat << EOF > ~/.config/lan-mouse/config.toml
port = 4242

[[clients]]
hostname = "yoga"
ips = ["192.168.1.187"]
position = "right"
activate_on_startup = true
EOF

echo "Installation complete. Launch with 'lan-mouse'. Authorize on client and test."
