# Syncthing Docker Setup Guide 🔁

**Syncthing** keeps folders in sync between your own devices. There is no central account: each device talks to the others, and you approve every connection.

The image used here is [`lscr.io/linuxserver/syncthing`](https://docs.linuxserver.io/images/docker-syncthing/).

Joplin Server syncs notebooks. Nextcloud syncs files through one server. Syncthing is the peer-to-peer option: a folder on the homelab and the same folder on a laptop or phone, without uploading it to either of those apps.

---

## Why Use Syncthing? 🤔

* **No cloud account**: Devices sync directly. This container is just another device that stays online.
* **Per-folder control**: You choose what is shared, and with which device.
* **LinuxServer image**: `PUID` and `PGID` match the host user that owns `./config` and `./data`.

---

## Docker Compose Overview

* **GUI**: host port `8384`.
* **Sync**: `22000` TCP and UDP. Leave these published. The web UI is not enough for other devices to transfer files.
* **Discovery**: `21027/udp`, so devices on the LAN can find this instance.
* **Volumes**:
  - `./config` → device identity, GUI settings, and shared-folder config
  - `./data` → default place for synced files

`TZ` is set to `Africa/Tunis`. Change it if the host is somewhere else.

---

## Installation Steps 🚀

1. **Copy the compose file**:

   ```bash
   mkdir -p ~/syncthing
   cp /path/to/homelab-repo/syncthing/docker-compose.yml ~/syncthing/
   cd ~/syncthing
   ```

2. **Match the user id** if your host user is not `1000`:

   ```bash
   id -u
   id -g
   ```

   Put those values in `PUID` and `PGID`.

3. **Start it**:

   ```bash
   docker compose up -d
   ```

4. **Open** `http://<server>:8384`. Set a GUI password, then add your other devices and share a folder under `./data` (or mount another host path next to it).

---

## Notes 📝

* `./config` is the device identity. Deleting it makes this instance look like a new device, and the others will need to be paired again.
* The GUI has no authentication until you set a username and password. Do that before the port is reachable beyond your LAN.
* Phone clients are the Syncthing app, not a browser tab. The browser is only the admin UI.

---

## Useful Links 🔗

* [LinuxServer Syncthing image](https://docs.linuxserver.io/images/docker-syncthing/)
* [Syncthing documentation](https://docs.syncthing.net/)
