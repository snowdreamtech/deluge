#!/bin/sh

if command -v flood >/dev/null 2>&1; then
    mkdir -p /var/lib/flood/config
    mkdir -p /var/lib/flood/downloads
    chown -R ${PUID}:${PGID} /var/lib/flood

    if [ "${KEEPALIVE}" -eq 1 ]; then
        echo "Starting flood..."
        su -s /bin/sh -c "flood --host 0.0.0.0 --port 3000 --rundir /var/lib/flood/config" ${USER} &
    fi
fi
