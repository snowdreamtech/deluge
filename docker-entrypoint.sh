#!/bin/sh
set -e

# set WEBUI_PASS
if [ -n "${WEBUI_PASS}" ]; then
    # password
    HASH=$(/var/lib/deluge/bin/passwd.py "${WEBUI_PASS}")

    pwd_salt=$(echo "${HASH}" | cut -d ":" -f 1)
    pwd_sha1=$(echo "${HASH}" | cut -d ":" -f 2)
    
    sed -i "s|\"pwd_salt\":.*|\"pwd_salt\": \"${pwd_salt}\",|g" /var/lib/deluge/config/web.conf
    sed -i "s|\"pwd_sha1\":.*|\"pwd_sha1\": \"${pwd_sha1}\",|g" /var/lib/deluge/config/web.conf
fi

# set WEBUI_LANG
if [ -n "${WEBUI_LANG}" ]; then
    sed -i "s|\"language\":.*|\"language\": \"${WEBUI_LANG}\",|g" /var/lib/deluge/config/web.conf
fi

# set WEBUI_PORT
if [ -n "${WEBUI_PORT}" ]; then
    sed -i "s|\"port\":.*|\"port\": \"${WEBUI_PORT}\",|g" /var/lib/deluge/config/web.conf
fi

# Deluge Bittorrent Client Web Interface
/usr/bin/deluge-web --config  /var/lib/deluge/config -p 8112

# Deluge Bittorrent Client Daemon
/usr/bin/deluged -d --config  /var/lib/deluge/config

# exec commands
exec "$@"
