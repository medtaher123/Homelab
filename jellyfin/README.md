# Jellyfin Docker Setup Guide 🎬

**Jellyfin** is a fully open-source media server for organizing, streaming, and sharing your movies, TV shows, music, and photos. It’s a free alternative to Plex, giving you full control over your media and server. 😎  

This guide covers running Jellyfin via Docker on your homelab with Traefik routing. For the official Jellyfin documentation, see [Jellyfin Docker Docs](https://jellyfin.org/docs/general/installation/container/).

---

## Docker Compose Overview

The Compose file contains the **Jellyfin Media Server** service:

* **jellyfin**: Core Jellyfin server, connects to your media library, cache, and configuration directories. Integrates with Traefik for web access.

### Key Configuration Notes

* **Network**:
  - Uses standard Docker networks (`default` + `traefik-network`) to integrate with Traefik.
* **Ports**:
  - `8096/tcp` → Web interface
  - `7359/udp` → DLNA discovery
* **Volumes**:
  - `./config` → Jellyfin server configuration
  - `./cache` → Temporary cache files
  - `<path/to/media/folder>` → Media library (movies, TV shows, music), read-only  
  - `./fonts` → Optional fonts for subtitle burn-in during transcoding
* **Traefik labels**:
  - Routes traffic to `jellyfin.<your-domain>` or via `/jellyfin` path prefix
  - Strips `/jellyfin` prefix for proper routing
  - Configures Jellyfin service port (`8096`) for Traefik

* **Optional**:
  - Specify `user: uid:gid` if you want Jellyfin to run as a non-root user.  
  - `extra_hosts` allows proper host gateway resolution inside the container.

> Note: For full configuration options, advanced networking, and troubleshooting, check out the [official Jellyfin Docker Docs](https://jellyfin.org/docs/general/installation/container/).

---

## Accessing Jellyfin

* After `docker-compose up -d`, Jellyfin should be available at:  
  `http://jellyfin.<your-domain>` (Traefik routed)  
  or `http://<server-ip>:8096` on your local network.
* Complete the setup in the web interface to create your admin account and add libraries.
* **Organize your media folders into libraries** (`Movies`, `TVShows`, etc.) so Jellyfin can detect them correctly. You can use the same library structure as Plex if running both.

---

## Jellyfin vs Plex

I also have **Plex** running in another folder. Both servers serve the same purpose but differ in philosophy:

* **Jellyfin**: Fully open-source, free, similar features to Plex, but some setups (like remote access) require extra configuration. Updates faster because it’s community-driven.  
* **Plex**: Closed-source, polished UI, supports streaming to lots of devices, remote access works out of the box, some features require a Plex Pass subscription.

**Opinion**: If you want convenience and broad device support, Plex is smoother. If you want control, free software, and faster community updates, Jellyfin is better.

---

## Tips & Notes

* Ensure media directories are accessible with proper read/write permissions.  
* Traefik routing allows you to access Jellyfin securely through your reverse proxy.  
* Organize your media into clear libraries for proper detection (`Movies`, `TVShows`, etc.).  
* You can share the same libraries between Plex and Jellyfin if running both.  

---

> This folder contains the Compose file, Traefik labels, and notes to help you run Jellyfin on your homelab. Enjoy streaming your personal media collection! 🎉
