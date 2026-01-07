#!/usr/bin/env bash
set -euo pipefail

echo "======================================="
echo "=== Emacs + mu4e + mbsync installer ==="
echo "======================================="
echo

# --- Install packages --------------------------------------------------------
sudo pacman -S --noconfirm --needed emacs isync
yay -S --noconfirm --needed mu

if [ ! -f ~/.config/doom/init.el ]; then
  echo "======================================="
  echo "===      Installing Doom Emacs      ==="
  echo "======================================="
  echo
  mkdir -p ~/.config/emacs
  cd ~/.config/emacs
  git clone --depth 1 https://github.com/doomemacs/doomemacs
  ~/.config/emacs/bin/doom install

fi

cd ~

# --- Ask for account info ----------------------------------------------------
read -rp "Email address: " USER
read -rp "IMAP host: " HOST
read -rp "Account directory e.g. dude-host: " ACC
read -rp "Password store entry (pass show ...): " PASSENTRY

# --- Maildir ----------------------------------------------------------------
mkdir -p "$HOME/.mail/$ACC"

# --- Append mbsync config ----------------------------------------------------
cat >> "$HOME/.mbsyncrc" <<EOF

IMAPAccount $ACC
Host $HOST
User $USER
PassCmd "pass show $PASSENTRY"
SSLType IMAPS

IMAPStore ${ACC}-remote
Account $ACC

MaildirStore ${ACC}-local
Path ~/.mail/$ACC/
Inbox ~/.mail/$ACC/INBOX

Channel $ACC
Master :${ACC}-remote:
Slave :${ACC}-local:
Patterns *
Create Slave
SyncState *
EOF

# --- Systemd timer (created once) -------------------------------------------
mkdir -p "$HOME/.config/systemd/user"

if [ ! -f "$HOME/.config/systemd/user/mbsync.service" ]; then
cat > "$HOME/.config/systemd/user/mbsync.service" <<'EOF'
[Unit]
Description=mbsync mail sync

[Service]
Type=oneshot
ExecStart=/usr/bin/mbsync -a
EOF
fi

if [ ! -f "$HOME/.config/systemd/user/mbsync.timer" ]; then
cat > "$HOME/.config/systemd/user/mbsync.timer" <<'EOF'
[Unit]
Description=Run mbsync every 5 minutes

[Timer]
OnBootSec=30s
OnUnitActiveSec=5m

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now mbsync.timer
fi

# --- mu4e index --------------------------------------------------------------
mu init --maildir="$HOME/.mail"
mu index

echo "Account '$ACC' added. Launch Emacs and open mu4e."

