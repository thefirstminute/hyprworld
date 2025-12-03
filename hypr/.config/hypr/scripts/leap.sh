#!/usr/bin/env bash
# Simple InputLeap launcher for host/client
# Usage:
#   ./leap.sh host
#   ./leap.sh client <server-ip>

PORT=24800

case "$1" in
  host)
    echo "[*] Starting InputLeap server on port $PORT..."
    # Allow firewall traffic
    if command -v ufw >/dev/null 2>&1; then
      sudo ufw allow $PORT/tcp
    elif command -v firewall-cmd >/dev/null 2>&1; then
      sudo firewall-cmd --add-port=$PORT/tcp --permanent
      sudo firewall-cmd --reload
    fi

    # Launch server
    input-leap --server --config ~/.inputleap.conf
    ;;

  client)
    if [ -z "$2" ]; then
      echo "Usage: $0 client <server-ip>"
      exit 1
    fi
    SERVER_IP=$2
    echo "[*] Connecting to InputLeap server at $SERVER_IP:$PORT..."
    input-leap --client $SERVER_IP:$PORT
    ;;

  *)
    echo "Usage: $0 {host|client <server-ip>}"
    exit 1
    ;;
esac

