# Plex Docker Setup Guide 🍿

**Plex** is a self-hosted media server for organizing, streaming, and sharing your movies, TV shows, music, and photos. Think of it as your personal Netflix running on your own hardware. 😎  

This guide covers running Plex via Docker on your homelab with Traefik routing. For the official Plex Docker repository, see [plexinc/pms-docker](https://github.com/plexinc/pms-docker).

---

## Docker Compose Overview

The Compose file contains the **Plex Media Server** service:

* **plex**: Core Plex server, connects to your media library and transcode directories, and integrates with Traefik for web access.

### Key Configuration Notes

* **Network Modes**:
  - **bridge**: Expose individual ports manually. I started with this, but ran into discovery issues and had to tweak configs manually.  
  - **host**: Recommended for most setups—simplifies DLNA, discovery, and streaming. No port mapping required.  
  - **macvlan**: Another option for giving Plex its own IP on your network. Works well if host mode isn’t suitable.  

* **Volumes**:
  - `./config` → Plex server configuration
  - `./transcode` → Temporary transcode files
  - `<path/to/your/media/folder>` → Media library (movies, TV shows, music). **Organize your folders into libraries** (e.g., `Movies`, `TVShows`, `Music`) for Plex to detect content properly. You can use the same library structure for Jellyfin if you want to run both.

* **Environment variables**:
  - `TZ` → Set your timezone
  - `PLEX_CLAIM` → Required for initial server claim. Update after deleting config volumes ([claim link](https://www.plex.tv/claim/))  

* **Traefik labels**:
  - Routes traffic to `plex.<your-domain>` or via `/plex` path prefix
  - Strips `/plex` prefix for proper routing
  - Configures Plex service port (`32400`) for Traefik

> Note: If you want more details on configuration options, networking, or advanced setup, check out the [official Plex Docker repo](https://github.com/plexinc/pms-docker).

---

## Accessing Plex

* After `docker-compose up -d`, Plex should be available at:  
  `http://plex.<your-domain>` (Traefik routed)  
  or via your local network if using host mode.

* Complete the Plex setup in the web interface to create your admin account and add libraries.

* Remember to organize your media folders into libraries (`Movies`, `TVShows`, etc.) so Plex can detect them correctly. The same libraries can be used for Jellyfin if you want to run both.

---

## Plex vs Jellyfin

I have **Jellyfin** running in another folder as well. Both Plex and Jellyfin do basically the same thing—serve media—but have different philosophies:

* **Plex**: Closed-source, polished UI, supports streaming to lots of devices, remote access works out of the box, some features require a Plex Pass subscription.  
* **Jellyfin**: Fully open-source, free, similar features but some setups (like remote access) require extra configuration, updates faster because it’s community-driven.

**Opinion**: If you want convenience and broad device support, Plex is smoother. If you want control, free software, and faster community updates, Jellyfin is better.

---

## Tips & Notes

* Update `PLEX_CLAIM` every time you delete your Plex config directory.  
* Host networking simplifies DLNA, discovery, and streaming but be mindful of port conflicts.  
* Macvlan is another flexible option if host mode doesn’t fit your network.  
* Traefik routing allows you to access Plex securely through your reverse proxy without exposing unnecessary ports.  
* Ensure media directories are accessible with proper read/write permissions.  

---

> This folder contains the Compose file, Traefik labels, and notes to help you run Plex on your homelab. Enjoy streaming your personal media collection! 🎉
