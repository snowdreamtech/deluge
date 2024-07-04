#!/bin/sh
set -e


# set WEBUI_LANG
if [ -n "${WEBUI_LANG}" ]; then
    sed -i "s|\"language\":.*|\"language\": \"${WEBUI_LANG}\",|g" /var/lib/deluge/config/web.conf
fi

# Deluge Bittorrent Client Web Interface
/usr/bin/deluge-web --config  /var/lib/deluge/config -p 8112

# Deluge Bittorrent Client Daemon
/usr/bin/deluged -d --config  /var/lib/deluge/config

# exec commands
exec "$@"
