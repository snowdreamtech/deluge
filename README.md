# Deluge

[![CI Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/deluge/ci.yml?branch=main&label=CI%20Pipeline)](https://github.com/snowdreamtech/deluge/actions/workflows/ci.yml)
[![CD Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/deluge/cd.yml?branch=main&label=CD%20Pipeline)](https://github.com/snowdreamtech/deluge/actions/workflows/cd.yml)
[![CodeQL](https://img.shields.io/github/actions/workflow/status/snowdreamtech/deluge/codeql.yml?branch=main&label=CodeQL&logo=github)](https://github.com/snowdreamtech/deluge/actions/workflows/codeql.yml)
[![Security Audit](https://img.shields.io/badge/Security-Zizmor%20%7C%20Trivy%20%7C%20Gitleaks-brightgreen)](https://github.com/snowdreamtech/deluge/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/MIT)
![Docker Image Version](https://img.shields.io/docker/v/snowdreamtech/deluge)
![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/deluge/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/deluge)
![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/deluge)

[English](README.md) | [简体中文](README_zh-CN.md)

Docker image for Deluge providing standardized container foundations with flexible entrypoint systems, multi-architecture support, and consistent configuration patterns across Alpine, Debian, and Rocky Linux distributions, with optional Flood web user interface.

## Overview

The Deluge container provides:

- **Standardized Dockerfiles** with OCI annotations and best practices
- **Flexible entrypoint system** supporting custom initialization scripts
- **Consistent environment variable configuration** across all variants
- **Multi-architecture support** for diverse hardware platforms
- **User/group management** with PUID/PGID support for permission handling
- **Three distribution variants**: Alpine (lightweight), Debian (default/widely-compatible), Rocky (enterprise)
- **Two flavors**: core `deluge` (with native Deluge Web UI) and `flood` (with modern Flood Web UI)

## Quick Start

```bash
# Pull and run the default Debian variant
docker pull snowdreamtech/deluge:debian
docker run -d \
  --name=deluge \
  -e TZ=Asia/Shanghai \
  -p 8112:8112 \
  -p 58846:58846 \
  -p 58081:58081 \
  -p 58081:58081/udp \
  -v ./downloads:/var/lib/deluge/downloads \
  -v ./config:/var/lib/deluge/config \
  --restart unless-stopped \
  snowdreamtech/deluge:debian

# Or use docker compose
docker compose up -d
```

## Usage

Default Deluge Web UI access:
- **URL**: `http://localhost:8112`
- **Password**: `deluge` (Prompted to change on first login)

### Docker CLI

```bash
docker run -d \
  --name=deluge \
  -e TZ=Asia/Shanghai \
  -p 8112:8112 \
  -p 58846:58846 \
  -p 58081:58081 \
  -p 58081:58081/udp \
  -v ./downloads:/var/lib/deluge/downloads \
  -v ./config:/var/lib/deluge/config \
  --restart unless-stopped \
  snowdreamtech/deluge:latest
# snowdreamtech/deluge:alpine
# snowdreamtech/deluge:debian
# snowdreamtech/deluge:rocky
```

### Docker Compose

```yaml
services:
  deluge:
    image: snowdreamtech/deluge:latest
    container_name: deluge
    environment:
      - TZ=Asia/Shanghai
      - PUID=1000
      - PGID=1000
    ports:
      - "8112:8112"
      - "58846:58846"
      - "58081:58081"
      - "58081:58081/udp"
    volumes:
      - ./downloads:/var/lib/deluge/downloads
      - ./config:/var/lib/deluge/config
    restart: unless-stopped
```

## Web UI Flavors

In addition to the standard `deluge` flavor with native Web UI, a Flood-integrated flavor is available:

### Standard (`deluge`)

Features the built-in Deluge Web UI on port 8112 and Deluge Daemon on port 58846.

```bash
docker run -d \
  --name=deluge \
  -e TZ=Asia/Shanghai \
  -p 8112:8112 \
  -p 58846:58846 \
  -p 58081:58081 \
  -p 58081:58081/udp \
  -v ./downloads:/var/lib/deluge/downloads \
  -v ./config:/var/lib/deluge/config \
  --restart unless-stopped \
  snowdreamtech/deluge:latest
```

### Flood (`flood`)

Features the modern, responsive [Flood](https://github.com/jesec/flood) interface on port 3000 alongside Deluge daemon and web.

```bash
docker run -d \
  --name=deluge-flood \
  -e TZ=Asia/Shanghai \
  -p 3000:3000 \
  -p 8112:8112 \
  -p 58846:58846 \
  -p 58081:58081 \
  -p 58081:58081/udp \
  -v ./downloads:/var/lib/deluge/downloads \
  -v ./config:/var/lib/deluge/config \
  -v ./flood:/var/lib/flood/config \
  --restart unless-stopped \
  snowdreamtech/deluge:latest-flood
```

## Distribution Variants

### Debian (Default)

The recommended variant for most use cases, providing wide compatibility and extensive package availability.

```bash
docker run -d \
  --name=deluge \
  -e TZ=Asia/Shanghai \
  -p 8112:8112 \
  -p 58846:58846 \
  -p 58081:58081 \
  -p 58081:58081/udp \
  -v ./downloads:/var/lib/deluge/downloads \
  -v ./config:/var/lib/deluge/config \
  --restart unless-stopped \
  snowdreamtech/deluge:debian
```

**Supported Architectures**: amd64, arm32v7, arm64, ppc64le, riscv64, s390x

**Base Image**: `snowdreamtech/debian:13.6.0`

### Alpine

Lightweight variant optimized for minimal image size and fast startup times.

```bash
docker run -d \
  --name=deluge \
  -e TZ=Asia/Shanghai \
  -p 8112:8112 \
  -p 58846:58846 \
  -p 58081:58081 \
  -p 58081:58081/udp \
  -v ./downloads:/var/lib/deluge/downloads \
  -v ./config:/var/lib/deluge/config \
  --restart unless-stopped \
  snowdreamtech/deluge:alpine
```

**Supported Architectures**: 386, amd64, arm/v6, arm/v7, arm64, ppc64le, riscv64, s390x

**Base Image**: `snowdreamtech/alpine:3.24.1`

### Rocky

Enterprise-focused variant based on Rocky Linux.

```bash
docker run -d \
  --name=deluge \
  -e TZ=Asia/Shanghai \
  -p 8112:8112 \
  -p 58846:58846 \
  -p 58081:58081 \
  -p 58081:58081/udp \
  -v ./downloads:/var/lib/deluge/downloads \
  -v ./config:/var/lib/deluge/config \
  --restart unless-stopped \
  snowdreamtech/deluge:rocky
```

**Supported Architectures**: amd64, arm64, ppc64le, s390x

**Base Image**: `snowdreamtech/rocky:10.2.0`

> [!NOTE]
> Rocky builds are temporarily paused in CI due to upstream repository availability for Deluge on EL10.

## Environment Variables

All variants support the following environment variables for runtime configuration:

| Variable | Default | Description |
|----------|---------|-------------|
| `KEEPALIVE` | `1` | Keep container running (1=enabled, 0=disabled) |
| `LANG` | `C.UTF-8` | Locale setting for UTF-8 character support |
| `UMASK` | `022` | Default file creation mask |
| `DEBUG` | `false` | Enable debug output in entrypoint scripts |
| `PASSWORDLESS_SUDO` | `false` | Enable passwordless sudo for user |
| `PGID` | `0` | Primary group ID for custom user creation |
| `PUID` | `0` | User ID for custom user creation |
| `USER` | `root` | Username for custom user creation |
| `WORKDIR` | `/root` | Working directory path |
| `TZ` | - | Timezone (e.g., `Asia/Shanghai`, `America/New_York`) |
| `DELUGE_VERSION` | - | Upstream package version of Deluge |
| `FLOOD_VERSION` | `4.16.4` | Upstream package version of Flood |

**Debian-specific**:

| Variable | Default | Description |
|----------|---------|-------------|
| `DEBIAN_FRONTEND` | `noninteractive` | Debian package installation mode |

## Architecture Support

Each distribution variant supports multiple CPU architectures for deployment across diverse hardware platforms:

| Variant | Architectures |
|---------|---------------|
| **Debian** | amd64, arm32v7, arm64, ppc64le, riscv64, s390x |
| **Alpine** | 386, amd64, arm/v6, arm/v7, arm64, ppc64le, riscv64, s390x |
| **Rocky** | amd64, arm64, ppc64le, s390x |

Docker automatically selects the appropriate architecture for your platform when pulling images.

## Entrypoint System

The image includes a flexible entrypoint system that executes custom initialization scripts before starting your application.

### How It Works

1. The `docker-entrypoint.sh` script runs at container startup
2. It executes all executable scripts in `/usr/local/bin/entrypoint.d/` in lexical order
3. Each script receives the container's command-line arguments
4. If any script fails, the container stops (fail-fast behavior)

### Debug Mode

Enable debug output to troubleshoot entrypoint execution:

```bash
docker run -e DEBUG=true snowdreamtech/deluge:debian
```

## Development

### Prerequisites

- Docker (>= 20.10) with Docker Buildx plugin
- [UniRTM](https://github.com/snowdreamtech/UniRTM) for workspace quality guard and toolchain management

### Quality & Verification

```bash
# Setup toolchain and verify environment
unirtm run setup

# Run comprehensive workspace quality check (formatters, linters, security)
unirtm run verify

# Run security audits (Zizmor, Gitleaks, OSV-Scanner, Trivy)
unirtm run audit

# Automatically fix linting and formatting issues where supported
unirtm run fix
```

## Reference

1. [Deluge Official Website](https://deluge-torrent.org/)
2. [Deluge Official Repository](https://github.com/deluge-torrent/deluge)
3. [Flood - Modern Web UI for Torrent Clients](https://github.com/jesec/flood)

## Contact (备注：deluge)

- Email: <sn0wdr1am@qq.com>
- QQ: 3217680847
- QQ群: 949022145
- WeChat/微信群: sn0wdr1am

## License

MIT
