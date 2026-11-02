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

基于 Alpine、Debian 与 Rocky Linux 的标准化 Deluge Docker 镜像，具备灵活的 entrypoint 系统、多架构支持和跨发行版的一致配置模式，并提供集成了现代化 Flood Web 界面的版本。

## 概述

Deluge 容器镜像提供：

- **标准化 Dockerfile**，遵循 OCI 规范与容器最佳实践
- **灵活的 entrypoint 体系**，支持自定义初始化脚本
- **一致的环境变量配置**，跨所有发行版变体统一
- **全面的多架构支持**，适配各类硬件平台
- **用户/用户组管理**，支持 PUID/PGID 权限映射
- **三种系统变体**：Alpine（轻量级）、Debian（默认/高兼容性）、Rocky（企业级）
- **两种构建风味**：核心 `deluge`（内置 Web UI）以及现代化的 `flood`（集成 Flood Web UI）

## 快速上手

```bash
# 拉取并运行默认的 Debian 镜像
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

# 或者使用 docker compose
docker compose up -d
```

## 使用说明

默认 Deluge Web UI 访问信息：
- **访问地址**: `http://localhost:8112`
- **默认密码**: `deluge`（首次登录后会提示修改）

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

## Web UI 风味版本

除了带有原生 Web UI 的标准版 `deluge` 之外，还提供了集成现代 Web 前端 Flood 的镜像：

### 标准版 (`deluge`)

采用 Deluge 原生 Web UI（8112 端口）及守护进程（58846 端口）。

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

### Flood 前端版 (`flood`)

集成基于 Node.js 开发的现代化 [Flood](https://github.com/jesec/flood) 前端界面（监听 3000 端口），与 Deluge 服务共存。

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

## 发行版变体

### Debian（默认）

适用于绝大多数使用场景的推荐变体，具备极佳的兼容性与完备的软件包生态。

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

**支持的架构**: amd64, arm32v7, arm64, ppc64le, riscv64, s390x

**基础镜像**: `snowdreamtech/debian:13.6.0`

### Alpine

轻量级变体，针对极小的镜像体积和极快的容器启动速度进行了优化。

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

**支持的架构**: 386, amd64, arm/v6, arm/v7, arm64, ppc64le, riscv64, s390x

**基础镜像**: `snowdreamtech/alpine:3.24.1`

### Rocky

基于 Rocky Linux 的企业级变体。

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

**支持的架构**: amd64, arm64, ppc64le, s390x

**基础镜像**: `snowdreamtech/rocky:10.2.0`

> [!NOTE]
> 由于上游 EL10 软件仓库中 Deluge 相关依赖包暂不可用，Rocky 构建目前在 CI 中已暂时停用。

## 环境变量

所有发行版变体均支持以下环境变量进行运行时配置：

| 变量名 | 默认值 | 描述 |
|--------|--------|------|
| `KEEPALIVE` | `1` | 保持容器持续运行（1=启用，0=禁用） |
| `LANG` | `C.UTF-8` | 区域设置，确保 UTF-8 字符支持 |
| `UMASK` | `022` | 默认文件创建权限掩码 |
| `DEBUG` | `false` | 启用 entrypoint 脚本的调试输出 |
| `PASSWORDLESS_SUDO` | `false` | 为用户启用免密 sudo |
| `PGID` | `0` | 自定义用户的主要组 ID |
| `PUID` | `0` | 自定义用户的用户 ID |
| `USER` | `root` | 自定义用户的用户名 |
| `WORKDIR` | `/root` | 工作目录路径 |
| `TZ` | - | 时区（例如 `Asia/Shanghai`, `America/New_York`） |
| `DELUGE_VERSION` | - | Deluge 软件版本 |
| `FLOOD_VERSION` | `4.16.4` | Flood 软件版本 |

**Debian 专属变量**：

| 变量名 | 默认值 | 描述 |
|--------|--------|------|
| `DEBIAN_FRONTEND` | `noninteractive` | Debian 软件包安装交互模式 |

## 架构支持

每个发行版变体均支持多种 CPU 架构，以满足不同硬件平台的部署需求：

| 变体 | 支持架构 |
|------|----------|
| **Debian** | amd64, arm32v7, arm64, ppc64le, riscv64, s390x |
| **Alpine** | 386, amd64, arm/v6, arm/v7, arm64, ppc64le, riscv64, s390x |
| **Rocky** | amd64, arm64, ppc64le, s390x |

拉取镜像时，Docker 会自动识别并拉取适用于当前平台架构的镜像层。

## Entrypoint 系统

本镜像包含灵活的 entrypoint 系统，在启动主应用程序之前执行自定义初始化脚本。

### 工作机制

1. 容器启动时运行 `docker-entrypoint.sh` 脚本
2. 按字典顺序执行 `/usr/local/bin/entrypoint.d/` 目录下的所有可执行脚本
3. 每个脚本都会接收到容器传入的命令行参数
4. 若任意脚本执行失败，容器将立即终止（快速失败机制）

### 调试模式

启用调试输出以排查 entrypoint 执行问题：

```bash
docker run -e DEBUG=true snowdreamtech/deluge:debian
```

## 开发与维护

### 前置要求

- Docker (>= 20.10) 及 Docker Buildx 插件
- [UniRTM](https://github.com/snowdreamtech/UniRTM) 用于工作区质量守卫和工具链管理

### 质量检查与验证

```bash
# 安装并配置环境工具链
unirtm run setup

# 执行全面的工作区质量检查（格式化、Lint、安全审计）
unirtm run verify

# 运行安全审计（Zizmor, Gitleaks, OSV-Scanner, Trivy）
unirtm run audit

# 自动修复支持的代码规范和格式问题
unirtm run fix
```

## 参考文档

1. [Deluge 官方网站](https://deluge-torrent.org/)
2. [Deluge 官方仓库](https://github.com/deluge-torrent/deluge)
3. [Flood - 现代化 Torrent 网页前端](https://github.com/jesec/flood)

## 联系方式 (备注：deluge)

- Email: <sn0wdr1am@qq.com>
- QQ: 3217680847
- QQ群: 949022145
- WeChat/微信群: sn0wdr1am

## 许可协议

MIT
