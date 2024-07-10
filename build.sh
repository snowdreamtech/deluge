#!/bin/sh

DOCKER_HUB_PROJECT=snowdreamtech/deluge

GITHUB_PROJECT=ghcr.io/snowdreamtech/deluge

docker buildx build --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
-t ${DOCKER_HUB_PROJECT}:flood-latest \
-t ${DOCKER_HUB_PROJECT}:flood-2.1.1\
-t ${DOCKER_HUB_PROJECT}:flood-2.1 \
-t ${DOCKER_HUB_PROJECT}:flood-2 \
-t ${GITHUB_PROJECT}:flood-latest \
-t ${GITHUB_PROJECT}:flood-2.1.1\
-t ${GITHUB_PROJECT}:flood-2.1 \
-t ${GITHUB_PROJECT}:flood-2 \
. \
--push
