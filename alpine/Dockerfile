FROM snowdreamtech/node:22.11.0-alpine

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
ENV KEEPALIVE=1 \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=0 

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

ARG GID=1000 \
    UID=1000  \
    USER=deluge \
    WORKDIR=/var/lib/deluge

# Create a user with UID and GID
RUN if [ "${USER}" != "root" ]; then \
    addgroup -g ${GID} ${USER}; \
    adduser -h ${WORKDIR} -u ${UID} -g ${USER} -G ${USER} -s /sbin/nologin -D ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi

# Enable CAP_NET_BIND_SERVICE
RUN if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
    apk add --no-cache libcap; \
    # setcap 'cap_net_bind_service=+ep' `which nginx`; \
    fi

RUN apk add --no-cache deluge=${DELUGE_VERSION}  \
    uuidgen \
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
    && rm -rfv maxmind.dat.gz

RUN npm install --global flood

COPY --chown=${USER}:${USER} config /var/lib/deluge/config

# Switch to the user
USER ${USER}

# Set the workdir
WORKDIR ${WORKDIR}

EXPOSE 3000 8112 58846 6881 6881/udp

COPY --chown=${USER}:${USER} docker-entrypoint.sh account.py passwd.py  /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]