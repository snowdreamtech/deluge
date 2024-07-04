FROM snowdreamtech/alpine:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV WEBUI_PORT=8112 \
    TORRENTING_PORT=6881 \
    WEBUI_PASS="deluge" \
    WEBUI_LANG="en" 

RUN apk add --no-cache deluge   \
    && mkdir -p /var/lib/deluge/  \
    && adduser -h /var/lib/deluge/ -s /sbin/nologin -g deluge -D deluge >/dev/null 2>&1 \
    && mkdir -p /var/lib/deluge/config/  \
    && mkdir -p /var/lib/deluge/incomplete/  \
    && mkdir -p /var/lib/deluge/downloads/  \
    && mkdir -p /var/lib/deluge/torrents/  \
    && mkdir -p /var/lib/deluge/log/  \
    && chown -R  deluge:deluge /var/lib/deluge 

COPY config /var/lib/deluge/config

COPY bin /var/lib/deluge/bin

COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 8112 58846 58946 58946/udp

ENTRYPOINT ["docker-entrypoint.sh"]