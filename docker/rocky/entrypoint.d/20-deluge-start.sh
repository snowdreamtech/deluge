#!/bin/sh

if command -v deluged >/dev/null 2>&1; then
  mkdir -p /var/lib/deluge/config
  mkdir -p /var/lib/deluge/downloads
  chown -R "${PUID}":"${PGID}" /var/lib/deluge

  if [ "${KEEPALIVE}" -eq 1 ]; then
    echo "Starting deluged daemon..."
    su -s /bin/sh -c "deluged -d -c /var/lib/deluge/config" "${USER}" &
    echo "Starting deluge-web daemon..."
    su -s /bin/sh -c "deluge-web -d -c /var/lib/deluge/config" "${USER}" &
  fi
fi
