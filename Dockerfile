FROM snowdreamtech/alpine:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV PEER_PORT=6881 \
    RPC_PORT=58846 \
    RPC_USER="localclient" \
    RPC_PASS="" \
    AUTH_LEVEL=10 \
    WEBUI_PORT=8112 \
    WEBUI_PASS="deluge" \
    WEBUI_LANG="en" 

RUN apk add --no-cache deluge \
    uuidgen \
    && mkdir -p /var/lib/deluge/  \
    && adduser -h /var/lib/deluge/ -s /sbin/nologin -g deluge -D deluge >/dev/null 2>&1 \
    && mkdir -p /var/lib/deluge/config/  \
    && mkdir -p /var/lib/deluge/incomplete/  \
    && mkdir -p /var/lib/deluge/downloads/  \
    && mkdir -p /var/lib/deluge/torrents/  \
    && mkdir -p /var/lib/deluge/log/  \
    && chown -R  deluge:deluge /var/lib/deluge \
    && mkdir -p /usr/share/GeoIP \
    && wget -c https://dl.miyuru.lk/geoip/maxmind/country/maxmind.dat.gz \
    && gunzip maxmind.dat.gz \
    && mv maxmind.dat /usr/share/GeoIP/GeoIP.dat

COPY config /var/lib/deluge/config

COPY bin /var/lib/deluge/bin

COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 8112 58846 58946 58946/udp

ENTRYPOINT ["docker-entrypoint.sh"]