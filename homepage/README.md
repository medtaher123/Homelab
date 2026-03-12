# Homepage 🏠✨

Welcome to the **Homepage** service! If your homelab is a house, think of this as the front door. 

If you are new to self-hosting, this is usually the very first service you want to set up so you have a clean, organized place to access everything else you build.

## What is Homepage (and why use it)?

When you start building a homelab, you quickly run into a silly problem: you end up with a dozen different services, each running on a random port. Remembering that your media server is at `192.168.1.50:32400` and your file sync is at `192.168.1.50:8080` gets exhausting.

**Homepage** (specifically, the `gethomepage/homepage` project) is a modern, highly customizable application dashboard. 

**Why we use it:**
* **One link to rule them all:** You just bookmark one single address (like `http://homepage.local` or `http://<your-server-ip>:3000`), and it gives you clickable buttons for every service you run.
* **Live Stats:** It doesn't just link to your apps; it actually talks to them. It can show you if your media server is currently playing a movie, how much space is left on your hard drive, or if your ad-blocker is working.

## How it works

Homepage doesn't have a graphical settings menu. Instead, it is configured entirely through text files (YAML). It reads these files, connects to the APIs of your other services, and generates a beautiful webpage on the fly. 

The configuration is split into a few main files inside the `config/` directory:
* `services.yaml`: Where you define your apps and their links.
* `widgets.yaml`: For system stats (CPU, RAM, weather).
* `settings.yaml`: For the general look and feel of the page.

### 🔑 Handling API Keys & Secrets (`.env`)

To make Homepage show live data from your apps (like Plex or Portainer), it needs API keys to securely log into them. **Never hardcode your passwords or API keys directly into your `services.yaml` file**, especially if you plan to share your code!

Instead, we use an `.env` (environment) file:
1. All sensitive keys are stored in the `.env` file.
2. The `docker-compose.yml` file reads the `.env` file and passes the keys securely into the container.
3. Your `services.yaml` file references the keys using variables like `{{HOMEPAGE_VAR_PLEX_KEY}}`.

> **⚠️ Crucial Restart Rule:** > * If you modify a YAML file (like `config/services.yaml`), Homepage will detect the change and update your dashboard **automatically** in seconds. Just refresh your browser!
> * If you modify the `.env` file, the container itself needs to be refreshed to see the new keys. You **must** run `docker compose up -d` in your terminal to apply those changes.

### 🖼️ Custom Background Images

To make the dashboard truly yours, I've set up a dedicated folder specifically for background images. 
1. Drop your favorite wallpaper into the mapped images directory.
2. Open `config/settings.yaml`.
3. Set the background image to point to your new file. The UI will pick it up automatically!

## Quick Start

1. Duplicate the `.env.example` file and rename it to `.env` (add your API keys here when you are ready).
2. Ensure your `config/` directory has the base YAML files ready.
3. Run the following command inside this folder to spin it up:

```bash
docker compose up -d
```

4. Open your browser and go to the port specified in your compose file (usually http://<your-server-ip>:3000).