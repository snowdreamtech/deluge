FROM snowdreamtech/nodejs:22.16.0-alpine3.22

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Deluge Image Based On Alpine" \
    org.opencontainers.image.description="Docker Images for Deluge on Alpine. (i386, amd64, arm32v6, arm32v7, arm64, ppc64le,riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/deluge" \
    org.opencontainers.image.base.name="snowdreamtech/deluge:alpine" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/deluge" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="2.1.1" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/deluge"
    
# Switch to the user
USER root

# Set the workdir
WORKDIR /root

# keep the docker container running
ARG KEEPALIVE=0 \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=0 \
    # Ensure the container exec commands handle range of utf8 characters based of
    # default locales in base image (https://github.com/docker-library/docs/tree/master/debian#locales)
    LANG=C.UTF-8\
    UMASK=022 \
    DEBUG=false \
    PGID=0 \
    PUID=0  \
    USER=root \
    WORKDIR=/root 

# keep the docker container running
ENV KEEPALIVE=${KEEPALIVE} \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=${CAP_NET_BIND_SERVICE} \
    # Ensure the container exec commands handle range of utf8 characters based of
    # default locales in base image (https://github.com/docker-library/docs/tree/master/debian#locales)
    LANG=${LANG} \
    UMASK=${UMASK} \
    DEBUG=${DEBUG} \
    PGID=${PGID} \
    PUID=${PUID}  \
    USER=${USER} \
    WORKDIR=${WORKDIR} 

ENV DELUGE_VERSION=2.1.1-r10 \
    PEER_PORT=6881 \
    RPC_PORT=58846 \
    RPC_USER="deluge" \
    RPC_PASS="" \
    AUTH_LEVEL=10 \
    WEBUI_PORT=8112 \
    WEBUI_PASS="" \
    WEBUI_LANG="en" 

ENV FLOOD_AUTH=none \
    FLOOD_PORT=3000 

# Create a user with PUID and PGID
RUN if [ "${USER}" != "root" ] && [ ! -d "/home/${USER}" ] && [ "${PUID}" -ne 0 ] && [ "${PGID}" -ne 0 ]; then \
    addgroup -g ${PGID} ${USER}; \
    adduser -h /home/${USER} -u ${PUID} -g ${USER} -G ${USER} -s /bin/sh -D ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi

RUN apk update \
    && apk add --no-cache \
    deluge=${DELUGE_VERSION}  \
    uuidgen \
    && mkdir -p /var/lib/deluge/  \
    && mkdir -p /var/lib/deluge/config/  \
    && mkdir -p /var/lib/deluge/incomplete/  \
    && mkdir -p /var/lib/deluge/downloads/  \
    && mkdir -p /var/lib/deluge/torrents/  \
    && mkdir -p /var/lib/deluge/log/  \
    && mkdir -p /usr/share/GeoIP \
    && wget -c https://dl.miyuru.lk/geoip/maxmind/country/maxmind.dat.gz \
    && gunzip maxmind.dat.gz \
    && mv maxmind.dat /usr/share/GeoIP/GeoIP.dat \
    && rm -rfv maxmind.dat.gz

# Enable CAP_NET_BIND_SERVICE
# RUN if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
    # setcap 'cap_net_bind_service=+ep' `which nginx`; \
    # fi
    
COPY config /var/lib/deluge/config

COPY account.py passwd.py  /usr/local/bin/

RUN npm install --global flood

EXPOSE 3000 8112 58846 6881 6881/udp

COPY entrypoint.d /usr/local/bin/entrypoint.d

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.d/*

ENTRYPOINT ["docker-entrypoint.sh"]