FROM snowdreamtech/nodejs:20.19.2-trixie

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Deluge Image Based On Debian" \
    org.opencontainers.image.description="Docker Images for Deluge on Debian. (i386,amd64,arm32v5,arm32v7,arm64,mips64le,ppc64le,s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/deluge" \
    org.opencontainers.image.base.name="snowdreamtech/deluge:debian" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/deluge" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="2.0.3" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/deluge"

# Switch to the user
USER root

# Set the workdir
WORKDIR /root

# keep the docker container running
ARG DEBIAN_FRONTEND=noninteractive \
    KEEPALIVE=0 \
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

ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND} \
    # keep the docker container running
    KEEPALIVE=${KEEPALIVE} \
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

ENV DELUGE_VERSION=2.0.3-4 \
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
    addgroup --gid ${PGID} ${USER}; \
    adduser --home /home/${USER} --uid ${PUID} --gid ${PGID} --gecos ${USER} --shell /bin/bash --disabled-password ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi
    
RUN set -eux \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy update  \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy install --no-install-recommends \ 
    deluged=${DELUGE_VERSION}  \
    deluge-web=${DELUGE_VERSION}  \
    uuid-runtime \
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
    && rm -rfv maxmind.dat.gz \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy --purge autoremove \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Enable CAP_NET_BIND_SERVICE
# RUN if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
#     # setcap 'cap_net_bind_service=+ep' `which nginx`; \
#     fi
    
COPY config /var/lib/deluge/config

COPY account.py passwd.py  /usr/local/bin/

RUN npm install --global flood

EXPOSE 3000 8112 58846 6881 6881/udp

COPY entrypoint.d /usr/local/bin/entrypoint.d

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.d/*

ENTRYPOINT ["docker-entrypoint.sh"]