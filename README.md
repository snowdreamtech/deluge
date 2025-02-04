# Deluge

[![Deluge](http://dockeri.co/image/snowdreamtech/deluge)](https://hub.docker.com/r/snowdreamtech/deluge)

Docker Image packaging for Deluge. (amd64, arm32v5,  arm32v6, arm32v7, arm64v8, i386, mips64le, ppc64le,riscv64, s390x)

# Usage

To help you get started creating a container from this image you can either use docker-compose or the docker cli.

## Docker Cli

### Simple

```bash
docker run -d \
  --name=deluge \
  -e TZ=Etc/UTC \
  -e WEBUI_LANG=en \
  -e WEBUI_PASS=admin \
  -p 8112:8112 \
  -p 3000:3000 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v /path/to/downloads:/var/lib/deluge/downloads  \
  -v /path/to/incomplete:/var/lib/deluge/incomplete  \
  -v /path/to/torrents:/var/lib/deluge/torrents  \
  --restart unless-stopped \
  snowdreamtech/deluge:flood-latest
```

### Advance

```bash
docker run -d \
  --name=deluge \
  -e TZ=Etc/UTC \
  -e WEBUI_LANG=en \
  -e WEBUI_PASS=admin \
  -e WEBUI_PORT=8112 \
  -e PEER_PORT=6881 \
  -e RPC_USER=localclient \
  -e RPC_PASS=localclient \
  -e RPC_PORT=58846 \
  -e AUTH_LEVEL=10 \
  -e FLOOD_AUTH=none \
  -e FLOOD_PORT=3000 \
  -p 8112:8112 \
  -p 3000:3000 \
  -p 58846:58846 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v /path/to/config:/var/lib/deluge/config \
  -v /path/to/downloads:/var/lib/deluge/downloads  \
  -v /path/to/incomplete:/var/lib/deluge/incomplete  \
  -v /path/to/torrents:/var/lib/deluge/torrents  \
  --restart unless-stopped \
  snowdreamtech/deluge:flood-latest
```

## Docker Compose

### Simple

```bash
version: "3"

services:
  deluge:
    image: snowdreamtech/deluge:flood-latest
    container_name: deluge
    environment:
      - TZ=Etc/UTC
      - WEBUI_LANG=en
      - WEBUI_PASS=admin
    volumes:
      - /path/to/downloads:/var/lib/deluge/downloads
      - /path/to/incomplete:/var/lib/deluge/incomplete
      - /path/to/torrents:/var/lib/deluge/torrents
    ports:
      - 8112:8112
      - 3000:3000
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
```

### Advance

```bash
version: "3"

services:
  deluge:
    image: snowdreamtech/deluge:flood-latest
    container_name: deluge
    environment:
      - TZ=Etc/UTC
      - WEBUI_LANG=en
      - WEBUI_PASS=admin
      - WEBUI_PORT=8112
      - PEER_PORT=6881
      - RPC_USER=localclient
      - RPC_PASS=localclient
      - RPC_PORT=58846
      - AUTH_LEVEL=10
      - FLOOD_AUTH=none
      - FLOOD_PORT=3000
    volumes:
      - /path/to/config:/var/lib/deluge/config #optional
      - /path/to/downloads:/var/lib/deluge/downloads
      - /path/to/incomplete:/var/lib/deluge/incomplete
      - /path/to/torrents:/var/lib/deluge/torrents
    ports:
      - 8112:8112
      - 3000:3000
      - 58846:58846
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
```

# Development

```bash
docker buildx create --use --name build --node build --driver-opt network=host
docker buildx build -t snowdreamtech/deluge --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x . --push
```

## Reference

1. [使用 buildx 构建多平台 Docker 镜像](https://icloudnative.io/posts/multiarch-docker-with-buildx/)
1. [如何使用 docker buildx 构建跨平台 Go 镜像](https://waynerv.com/posts/building-multi-architecture-images-with-docker-buildx/#buildx-%E7%9A%84%E8%B7%A8%E5%B9%B3%E5%8F%B0%E6%9E%84%E5%BB%BA%E7%AD%96%E7%95%A5)
1. [Building Multi-Arch Images for Arm and x86 with Docker Desktop](https://www.docker.com/blog/multi-arch-images/)
1. [How to Rapidly Build Multi-Architecture Images with Buildx](https://www.docker.com/blog/how-to-rapidly-build-multi-architecture-images-with-buildx/)
1. [Faster Multi-Platform Builds: Dockerfile Cross-Compilation Guide](https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/)
1. [docker/buildx](https://github.com/docker/buildx)

## Contact (备注：base)

* Email: sn0wdr1am@qq.com
* QQ: 3217680847
* QQ群: 949022145
* WeChat/微信群: sn0wdr1am

## License

MIT
