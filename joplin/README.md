# Joplin Server Docker Setup Guide 📝

**Joplin Server** syncs notes between the Joplin apps (desktop, mobile, and CLI). Notes stay on your homelab instead of Joplin Cloud or a third-party sync target like Dropbox.

The image used here is [`joplin/server`](https://github.com/laurent22/joplin), with Postgres 15 for storage.

Joplin can also sync through Nextcloud, and [Nextcloud is already in this repo](../nextCloud/README.md). That would have been the shorter path: install the app, pick Nextcloud as the sync target, and stop there. I wanted to try something new, so this stack is Joplin's own sync server instead of another folder inside Nextcloud.

---

## Why Use Joplin Server? 🤔

* **Self-hosted sync**: The same notebooks on your phone and your laptop, without a cloud account.
* **End-to-end encryption**: Turn it on in the Joplin app. The server stores ciphertext.
* **Postgres**: Notes and user accounts live in a named volume, `joplin-data`.
* **Separate from the app**: This container is the sync server. Install the Joplin client on each device and point it at this URL.

---

## Docker Compose Overview

* **db**: Postgres 15. User, database name, and password come from `.env`.
* **app**: `joplin/server` on host port `22300`. `APP_BASE_URL` must match the URL clients use.
* **Network**: Both services sit on `joplin-network`. Postgres is not published to the host.

The first account you create in the web UI becomes the admin.

---

## Installation Steps 🚀

1. **Copy the files**:

   ```bash
   mkdir -p ~/joplin
   cp /path/to/homelab-repo/joplin/docker-compose.yml ~/joplin/
   cp /path/to/homelab-repo/joplin/.env.example ~/joplin/.env
   ```

2. **Edit `.env`**:
   - Set `POSTGRES_PASSWORD` to something that is not the example value.
   - Set `APP_BASE_URL` to the URL you will open, for example `http://<server>:22300`.

3. **Start it**:

   ```bash
   cd ~/joplin
   docker compose up -d
   ```

4. **Open** `http://<server>:22300`, create the admin account, then in each Joplin app set **Synchronisation** to Joplin Server and use that same URL.

---

## Notes 📝

* Do not commit `.env`. The example file is the only copy that belongs in git.
* Changing `POSTGRES_PASSWORD` after the database volume already exists does not update the existing Postgres role. Set the password before the first start, or change it inside Postgres as well.
* `APP_BASE_URL` has to match what the apps use. A mismatch shows up as sync or login failures.

---

## Useful Links 🔗

* [Joplin Server](https://github.com/laurent22/joplin/blob/dev/packages/server/README.md)
* [Joplin apps](https://joplinapp.org/)
