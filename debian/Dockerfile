FROM snowdreamtech/debian:12.8.0

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
ENV KEEPALIVE=1 \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=0

ENV DELUGE_VERSION=2.0.3-4 \
    PEER_PORT=6881 \
    RPC_PORT=58846 \
    RPC_USER="deluge" \
    RPC_PASS="" \
    AUTH_LEVEL=10 \
    WEBUI_PORT=8112 \
    WEBUI_PASS="" \
    WEBUI_LANG="en" 

ARG GID=1000 \
    UID=1000  \
    USER=deluge \
    WORKDIR=/var/lib/deluge

# Create a user with UID and GID
RUN set -eux \
    && if [ "${USER}" != "root" ]; then \
    addgroup --gid ${GID} ${USER}; \
    adduser --home ${WORKDIR} --uid ${UID} --gid ${GID} --gecos ${USER} --shell /bin/bash --disabled-password ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy --purge autoremove \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* 

# Enable CAP_NET_BIND_SERVICE
RUN set -eux \
    && if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
    DEBIAN_FRONTEND=noninteractive apt-get -qqy update; \
    DEBIAN_FRONTEND=noninteractive apt-get -qqy install --no-install-recommends libcap2-bin; \
    # setcap 'cap_net_bind_service=+ep' `which nginx`; \
    fi \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy --purge autoremove \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* 

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
    # Chown the files to USER
    && chown -R  ${USER}:${USER} /var/lib/deluge \
    && find /usr/lib  -name "*deluge*" -exec chown -Rv ${USER}:${USER} {} \; \
    && find /usr/bin  -name "*deluge*" -exec chown -Rv ${USER}:${USER} {} \; \
    && mkdir -p /usr/share/GeoIP \
    && wget -c https://dl.miyuru.lk/geoip/maxmind/country/maxmind.dat.gz \
    && gunzip maxmind.dat.gz \
    && mv maxmind.dat /usr/share/GeoIP/GeoIP.dat \
    && chown -R  ${USER}:${USER} /usr/share/GeoIP \
    && rm -rfv maxmind.dat.gz \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy --purge autoremove \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

COPY --chown=${USER}:${USER} config /var/lib/deluge/config

# Switch to the user
USER ${USER}

# Set the workdir
WORKDIR ${WORKDIR}

EXPOSE 8112 58846 6881 6881/udp

COPY --chown=${USER}:${USER} docker-entrypoint.sh account.py passwd.py  /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]