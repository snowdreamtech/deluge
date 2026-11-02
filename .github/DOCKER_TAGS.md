# Docker Image Tags Reference

This document describes the Docker image tagging strategy for the deluge project.

## Tag Naming Convention

All images use the format: `snowdreamtech/deluge:TAG`

Where `TAG` follows these patterns:

- **Variant-specific tags**: `TAG-variant` (e.g., `nightly-alpine`, `2.2.0-alpine`)
- **Default tags** (Debian only): `TAG` (e.g., `nightly`, `latest`, `2.2.0`)
- **Flavor tags**:
  - `deluge`: Core daemon and native Web UI
  - `flood`: Web UI powered by Flood (e.g., `latest-flood`, `latest-flood-alpine`, `2.2.0-flood-alpine`)

## Supported Registries

All tags are pushed to two registries:

- **GitHub Container Registry**: `ghcr.io/snowdreamtech/deluge:TAG`
- **DockerHub**: `snowdreamtech/deluge:TAG`

## Tag Scenarios

### 1. Branch Builds (dev/main)

#### Push to `dev` branch

```bash
git push origin dev
```

**Generated tags:**

```
snowdreamtech/deluge:dev-alpine
snowdreamtech/deluge:dev-debian
snowdreamtech/deluge:dev              # ← Debian (default)
snowdreamtech/deluge:dev-rocky
```

#### Push to `main` branch

```bash
git push origin main
```

**Generated tags:**

```
snowdreamtech/deluge:main-alpine
snowdreamtech/deluge:latest-alpine
snowdreamtech/deluge:main-debian
snowdreamtech/deluge:latest-debian
snowdreamtech/deluge:main             # ← Debian (default)
snowdreamtech/deluge:latest           # ← Debian (default)
snowdreamtech/deluge:main-rocky
snowdreamtech/deluge:latest-rocky
```

---

### 2. Release Tags (Semantic Versioning)

#### Alpine Release

```bash
git tag alpine-v2.2.0
git push origin alpine-v2.2.0
```

**Generated tags:**

```
snowdreamtech/deluge:2.2.0-alpine
snowdreamtech/deluge:latest-alpine
```

#### Debian Release

```bash
git tag debian-v2.2.0
git push origin debian-v2.2.0
```

**Generated tags:**

```
snowdreamtech/deluge:2.2.0-debian
snowdreamtech/deluge:latest-debian
snowdreamtech/deluge:2.2.0            # ← Debian (default)
snowdreamtech/deluge:latest           # ← Debian (default)
```

#### Rocky Release

```bash
git tag rocky-v2.2.0
git push origin rocky-v2.2.0
```

**Generated tags:**

```
snowdreamtech/deluge:2.2.0-rocky
snowdreamtech/deluge:latest-rocky
```

---

### 3. Nightly Builds (Scheduled)

**Trigger:** Automatically every day at 17:00 UTC

**Generated tags:**

```
# Alpine
snowdreamtech/deluge:nightly-alpine

# Debian (with default tags)
snowdreamtech/deluge:nightly-debian
snowdreamtech/deluge:nightly          # ← Debian (default)

# Rocky
snowdreamtech/deluge:nightly-rocky
```

---

## Tag Priority

Tags are generated with the following priority (higher number = higher priority):

| Priority | Type | Example Tags | Trigger |
|----------|------|--------------|---------|
| 1000 | Nightly | `nightly`, `nightly-alpine` | Schedule |
| 800 | Version | `2.2.0-alpine`, `2.2.0` | Tag push |
| 600 | Branch | `dev-alpine`, `main-debian` | Branch push |
| 200 | Latest | `latest`, `latest-alpine` | Main/Tag |

---

## Default Variant (Debian)

Debian is designated as the **default variant** (`is_latest: true`), which means:

✅ **Debian gets BOTH suffixed AND unsuffixed tags:**

```
snowdreamtech/deluge:nightly-debian   # Variant-specific
snowdreamtech/deluge:nightly          # Default (no suffix)

snowdreamtech/deluge:2.2.0-debian     # Variant-specific
snowdreamtech/deluge:2.2.0            # Default (no suffix)

snowdreamtech/deluge:latest-debian    # Variant-specific
snowdreamtech/deluge:latest           # Default (no suffix)
```

❌ **Alpine and Rocky get ONLY suffixed tags:**

```
snowdreamtech/deluge:nightly-alpine   # Variant-specific only
snowdreamtech/deluge:nightly-rocky    # Variant-specific only
```

---

## Usage Examples

### Pull the latest Debian image (default)

```bash
docker pull snowdreamtech/deluge:latest
# or
docker pull snowdreamtech/deluge:latest-debian
```

### Pull the latest Alpine image

```bash
docker pull snowdreamtech/deluge:latest-alpine
```

### Pull the latest Rocky image

```bash
docker pull snowdreamtech/deluge:latest-rocky
```

### Pull a specific version

```bash
# Alpine 2.2.0
docker pull snowdreamtech/deluge:2.2.0-alpine

# Debian 2.2.0 (two ways)
docker pull snowdreamtech/deluge:2.2.0-debian
docker pull snowdreamtech/deluge:2.2.0

# Rocky 2.2.0
docker pull snowdreamtech/deluge:2.2.0-rocky
```

### Pull Flood Web UI images

```bash
# Flood Web UI
docker pull snowdreamtech/deluge:latest-flood
docker pull snowdreamtech/deluge:latest-flood-alpine
docker pull snowdreamtech/deluge:latest-flood-debian
docker pull snowdreamtech/deluge:latest-flood-rocky
```

---

## Metadata Action Configuration

The key configuration that enables this tagging strategy:

```yaml
images: |
  name=ghcr.io/snowdreamtech/deluge,enable=true
  name=snowdreamtech/deluge,enable=true
flavor: |
  latest=false
  prefix=
  suffix=
```
