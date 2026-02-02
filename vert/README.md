# VERT Docker Setup Guide 🔄

**VERT** is a privacy-focused file conversion utility that converts files **locally on your device** using WebAssembly instead of uploading them to the cloud. Think of it as your own self-hosted file converter that supports **250+ file formats** for images, audio, documents, and videos. 🎯

The official instance is at [vert.sh](https://vert.sh), but self-hosting gives you complete control and privacy.

---

## Why Use VERT? 🤔

* **Privacy First**: Files are converted on your device using WebAssembly—nothing is uploaded to a cloud server.
* **No Limits**: No file size or usage limits. Convert as much as you want.
* **250+ Formats**: Supports images, audio, documents, and video conversions.
* **Self-Hosted**: Run your own instance for complete control.
* **User-Friendly**: Built with Svelte and TypeScript for a smooth, modern interface.
* **Free & Open Source**: Licensed under AGPL-3.0.

If you care about privacy and want unlimited file conversions without relying on third-party services, VERT is perfect for your homelab.

---

## Docker Compose Overview

The Compose file contains the **VERT** service:

* **vert**: The main VERT web application, built from the Dockerfile with customizable environment variables. Integrates with Traefik for routing.

### Key Configuration Notes

* **Network**:
  - Uses standard Docker networks (`default` + `traefik-network`) to integrate with Traefik.
* **Ports**:
  - `1682:80` → Web interface (change `1682` if this port conflicts with another service)
* **Build Arguments**:
  - Environment variables are baked into the image during build time via build args
  - Modify `.env` file before building to customize your instance
* **Traefik labels**:
  - Routes traffic to `vert.<your-domain>` or via `/vert` path prefix
  - Strips `/vert` prefix for proper routing
  - Configures VERT service port (`80`) for Traefik

* **Environment Variables** (see `.env.example`):
  - `PUB_ENV` → Set to `production` for production use, `development` for local testing
  - `PUB_HOSTNAME` → Your domain or hostname for analytics
  - `PUB_PLAUSIBLE_URL` → Optional analytics (leave empty to disable)
  - `PUB_VERTD_URL` → Video conversion daemon URL (defaults to official instance or self-host for full privacy)
  - `PUB_DISABLE_ALL_EXTERNAL_REQUESTS` → Set to `true` for air-gapped/privacy-focused deployments
  - `PUB_DISABLE_FAILURE_BLOCKS` → Set to `true` for local deployments without HTTPS

> Note: Video conversion uses WebAssembly but can optionally use a [vertd daemon](https://github.com/VERT-sh/vertd) for advanced video processing. The default points to the official instance, but you can self-host vertd for complete privacy.

---

## Installation Steps 🚀

1. **Clone the VERT repository**:
   ```bash
   git clone https://github.com/VERT-sh/VERT
   cd VERT/
   ```

2. **Copy the configuration files**:
   Copy the `docker-compose.yml`, `Dockerfile`, and `.env.example` from this folder to the VERT repository directory:
   ```bash
   cp /path/to/homelab-repo/vert/docker-compose.yml .
   cp /path/to/homelab-repo/vert/Dockerfile .
   cp /path/to/homelab-repo/vert/.env.example .env
   ```

3. **Configure environment variables**:
   Edit the `.env` file and customize the settings:
   ```bash
   nano .env
   ```
   
   At minimum, update:
   - `PUB_ENV=production`
   - `PUB_HOSTNAME=vert.yourdomain.com` (or your server IP)
   - `PUB_DISABLE_ALL_EXTERNAL_REQUESTS=true` (for full privacy)
   - Leave `PUB_PLAUSIBLE_URL` empty if you don't want analytics

4. **Build and start the container**:
   ```bash
   docker compose up -d
   ```

5. **Access VERT**:
   - Via Traefik: `http://vert.<your-domain>` or `http://<server-ip>/vert`
   - Direct access: `http://<server-ip>:1682`

---

## Privacy & Self-Hosting Tips 🔒

* **Full Privacy Mode**: Set `PUB_DISABLE_ALL_EXTERNAL_REQUESTS=true` to disable all external connections (analytics, donations, etc.)
* **Video Conversion**: For complete privacy with video conversions, self-host the [vertd daemon](https://github.com/VERT-sh/vertd) and set `PUB_VERTD_URL` to your instance.
* **No HTTPS?**: If running locally without HTTPS, set `PUB_DISABLE_FAILURE_BLOCKS=true` to avoid video conversion issues.
* **Air-Gapped**: VERT works in air-gapped environments—just set `PUB_DISABLE_ALL_EXTERNAL_REQUESTS=true`.

---

## Ports Overview 🌐

| Service | Port  | Purpose                                |
|---------|-------|----------------------------------------|
| VERT    | 1682  | Web UI (change if conflicts exist)     |

> Note: Port 1682 is used because other services in my homelab are already using common ports. Feel free to change it to any available port.

---

## Tips & Notes 💡

* Rebuild the image after changing environment variables: `docker compose up -d --build`
* VERT uses WebAssembly for most conversions, so processing happens in your browser—no server-side conversion needed for most formats.
* The official VERT documentation is great for advanced setups: [VERT Docs](https://github.com/VERT-sh/VERT/tree/main/docs)
* If using the default `PUB_VERTD_URL`, video conversions will use the official VERT instance. Self-host vertd for full local processing.
* Make sure `traefik-network` exists if using Traefik routing.

---

## Useful Links 🔗

* [VERT GitHub Repository](https://github.com/VERT-sh/VERT)
* [VERT Official Instance](https://vert.sh)
* [vertd Daemon (for video conversion)](https://github.com/VERT-sh/vertd)
* [VERT Documentation](https://github.com/VERT-sh/VERT/tree/main/docs)

---

> This folder contains the Docker Compose file, Dockerfile, and environment configuration to help you run VERT on your homelab. Enjoy privacy-focused, unlimited file conversions! 🎉
