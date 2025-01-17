#!/bin/sh
set -e

DELUGE_PATH=/var/lib/deluge
DELUGE_BIN_PATH=/usr/local/bin
DELUGE_CONFIG_PATH=${DELUGE_PATH}/config
DELUGE_AUTH_PATH=${DELUGE_CONFIG_PATH}/auth
DELUGE_CORE_PATH=${DELUGE_CONFIG_PATH}/core.conf
DELUGE_WEB_PATH=${DELUGE_CONFIG_PATH}/web.conf
DELUGE_HOSTLIST_PATH=${DELUGE_CONFIG_PATH}/hostlist.conf

# RPC_PASS openssl rand -base64 33
if [ -z "${RPC_PASS}" ]; then
    {
        RPC_PASS=$(openssl rand -base64 33)
        echo " Generate Random RPC password: ${RPC_PASS}"
    }
fi

# WEBUI_PASS openssl rand -base64 33
if [ -z "${WEBUI_PASS}" ]; then
    {
        WEBUI_PASS=$(openssl rand -base64 33)
        echo " Generate Random WEBUI password: ${WEBUI_PASS}"
    }
fi

# set Auth for RPC
if [ ! -f "${DELUGE_AUTH_PATH}" ]; then
    touch ${DELUGE_AUTH_PATH}
fi

AUTH=$(${DELUGE_BIN_PATH}/account.py "${RPC_USER}" "${RPC_PASS}" "${AUTH_LEVEL}")
RPC_USER=$(echo "${AUTH}" | cut -d ":" -f 1)
RPC_HASH=$(echo "${AUTH}" | cut -d ":" -f 2)

sed -i "/^${RPC_USER}:/d" ${DELUGE_AUTH_PATH}
echo "${AUTH}" >>${DELUGE_AUTH_PATH}

# set Hostlist for RPC
if [ ! -f "${DELUGE_HOSTLIST_PATH}" ]; then
    HOST_ID=$(uuidgen -x | sed "s|-||g")

    echo "{
        \"file\": 3,
        \"format\": 1
    }{
        \"hosts\": [
            [
                \"${HOST_ID}\",
                \"127.0.0.1\",
                ${RPC_PORT},
                \"${RPC_USER}\",
                \"${RPC_HASH}\"
            ]
        ]
    }" >${DELUGE_HOSTLIST_PATH}
fi

# set RPC_PORT
if [ -n "${RPC_PORT}" ]; then
    sed -i "s|\"daemon_port\":.*|\"daemon_port\": ${RPC_PORT},|g" ${DELUGE_CORE_PATH}

    (
        sleep 5
        if [ -f "${DELUGE_HOSTLIST_PATH}" ]; then
            sed -i "\:127.0.0.1:{
        n
        s/.*/                ${RPC_PORT},/
            }" ${DELUGE_HOSTLIST_PATH}
        fi
    ) &
fi

# set WEBUI_PASS
if [ -n "${WEBUI_PASS}" ]; then
    # password
    HASH=$(${DELUGE_BIN_PATH}/passwd.py "${WEBUI_PASS}")

    pwd_salt=$(echo "${HASH}" | cut -d ":" -f 1)
    pwd_sha1=$(echo "${HASH}" | cut -d ":" -f 2)

    sed -i "s|\"pwd_salt\":.*|\"pwd_salt\": \"${pwd_salt}\",|g" ${DELUGE_WEB_PATH}
    sed -i "s|\"pwd_sha1\":.*|\"pwd_sha1\": \"${pwd_sha1}\",|g" ${DELUGE_WEB_PATH}
fi

# set WEBUI_LANG
if [ -n "${WEBUI_LANG}" ]; then
    sed -i "s|\"language\":.*|\"language\": \"${WEBUI_LANG}\",|g" ${DELUGE_WEB_PATH}
fi

# set WEBUI_PORT
if [ -n "${WEBUI_PORT}" ]; then
    sed -i "s|\"port\":.*|\"port\": ${WEBUI_PORT},|g" ${DELUGE_WEB_PATH}
fi

# set PEER_PORT
if [ -n "${PEER_PORT}" ]; then
    sed -i "\:listen_ports:{
     n
     s/.*/            ${PEER_PORT},/
     n
     s/.*/            ${PEER_PORT}/
    }" ${DELUGE_CORE_PATH}
fi

# Deluge Bittorrent Client Daemon
/usr/bin/deluged --config ${DELUGE_CONFIG_PATH}

# Deluge Bittorrent Client Web Interface
/usr/bin/deluge-web -d --config ${DELUGE_CONFIG_PATH}

# exec commands
if [ -n "$*" ]; then
    sh -c "$*"
fi

# keep the docker container running
# https://github.com/docker/compose/issues/1926#issuecomment-422351028
if [ "${KEEPALIVE}" -eq 1 ]; then
    trap : TERM INT
    tail -f /dev/null &
    wait
    # sleep infinity & wait
fi
