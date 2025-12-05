#!/bin/sh
set -e

if [ "$DEBUG" = "true" ]; then echo "→ [deluge] Starting deluge..."; fi

# Deluge Bittorrent Client Daemon
/usr/bin/deluged --config ${DELUGE_CONFIG_PATH}

# Deluge Bittorrent Client Web Interface
/usr/bin/deluge-web -d --config ${DELUGE_CONFIG_PATH}


if [ "$DEBUG" = "true" ]; then echo "→ [deluge] Deluge started."; fi
