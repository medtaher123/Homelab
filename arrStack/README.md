# ARR Stack Docker Setup Guide 📥

The **ARR Stack** automates downloading and organizing media for your homelab. It works seamlessly with Plex or Jellyfin, so you don’t have to manually fetch movies, TV shows, or music. This stack is designed for self-hosted automation using **Sonarr, Radarr, Lidarr, Deluge, SABnzbd, Prowlarr**, and optionally **FlareSolverr**.

I found the [Servarr Wiki](https://wiki.servarr.com/) and [Docker Guide](https://wiki.servarr.com/docker-guide) incredibly helpful when starting out, especially since I had little context about these tools.

---

## Workflow Overview 🔄

The ARR stack works like a media automation pipeline:

1. **Prowlarr** → Your indexer manager. Adds, manages, and monitors torrent/NZB indexers for Sonarr, Radarr, and Lidarr.  
2. **Sonarr** → Automates TV show downloads. Checks indexers for new episodes and sends download requests to Deluge or SABnzbd.  
3. **Radarr** → Automates movie downloads in the same way as Sonarr.  
4. **Lidarr** → Automates music downloads.  
5. **Deluge** → Torrent client. Receives torrent downloads from Sonarr, Radarr, Lidarr.  
6. **SABnzbd** → Usenet client. Handles NZB downloads if using Usenet indexers.  
7. **FlareSolverr** (optional) → Handles Cloudflare-protected sites for Prowlarr, especially when some indexers (like x1337) block requests.

Once downloaded, media is placed in your organized library folders (`Movies`, `TVShows`, `Music`), ready to be consumed by Plex or Jellyfin.

---

## Docker Compose Services 🐳

### **Sonarr** 📺
* Image: `lscr.io/linuxserver/sonarr:latest`  
* Automates TV show downloads.
* Connects to your media folder to organize episodes automatically.

### **Radarr** 🎬
* Image: `lscr.io/linuxserver/radarr:latest`  
* Automates movie downloads.
* Organizes movies in your Plex/Jellyfin library.

### **Lidarr** 🎵
* Image: `lscr.io/linuxserver/lidarr:latest`  
* Automates music downloads.
* Organizes albums and artists into your library.

### **Deluge** ⚡
* Image: `lscr.io/linuxserver/deluge:2.2.0-r1-ls354`  
* Torrent client that handles downloads from Sonarr, Radarr, and Lidarr.

### **SABnzbd** 📰
* Image: `lscr.io/linuxserver/sabnzbd:latest`  
* Usenet client for NZB downloads.
* Can be used as an alternative to Deluge for non-torrent sources.

### **Prowlarr** 🔎
* Image: `lscr.io/linuxserver/prowlarr:latest`  
* Indexer manager. Adds and manages all torrent/NZB indexers.  
* Feeds indexer info to Sonarr, Radarr, and Lidarr.

### **FlareSolverr** 🌐
* Image: `flaresolverr/flaresolverr`  
* Optional. Required for bypassing Cloudflare blocks on some indexers (e.g., x1337).  
* Remove if not needed or using indexers without protection.

---

## Volumes & Configuration 📂

* Each service has a `./config` folder for settings and database.  
* Downloaded media is stored in `/mnt/immich/plex/data` (or your media folder).  
* Deluge stores torrent-specific downloads in `/data/torrents`.  
* SABnzbd stores Usenet downloads in `/data/usenet`.  
* Fonts folder optional for subtitle burn-in if needed.  

---

## Ports Overview 🌐

| Service      | Port(s)       | Purpose                                 |
|-------------|---------------|-----------------------------------------|
| Sonarr      | 8989          | Web UI                                  |
| Radarr      | 7878          | Web UI                                  |
| Lidarr      | 8686          | Web UI                                  |
| Deluge      | 8112, 6881    | Web UI and torrent connections          |
| SABnzbd     | 1682          | Web UI                                  |
| Prowlarr    | 9696          | Web UI                                  |
| FlareSolverr| 8191          | API for bypassing Cloudflare blocks     |

---

## Tips & Notes 💡

* Always map your media folders correctly in the volumes section.  
* Use the same libraries for Plex or Jellyfin for seamless integration.  
* Start with Prowlarr, then Sonarr/Radarr/Lidarr, and finally your download clients.  
* FlareSolverr is only needed if an indexer blocks requests; you can remove it later.  
* The Servarr Wiki and Docker guide were extremely helpful when I didn’t know where to start. I recommend reading them:  
  - [Servarr Wiki](https://wiki.servarr.com/)  
  - [Docker Guide](https://wiki.servarr.com/docker-guide)  

---

> This folder contains the ARR stack Docker Compose setup and notes to help you automate media downloads in your homelab. Enjoy never manually fetching shows, movies, or music again! 🎉
