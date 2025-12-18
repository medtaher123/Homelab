# Immich Docker Setup Guide 📸

**Immich** is a self-hosted photo and video backup solution. It's like your own personal Google Photos, but running on your server. 😎

## Installation Notes

* Follow the official Immich Docker guide: [https://docs.immich.app/install/docker-compose](https://docs.immich.app/install/docker-compose)
* Always use the docker-compose.yml from the **latest release**: [Latest Compose File](https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml)
* The Compose file on `main` may not be compatible with the latest release, so don't use it.

## Docker Compose Overview

The Compose file contains the following services:

* **immich-server**: Handles the core backend, exposes port `2283`, connects to Redis and PostgreSQL, and has Traefik labels for routing.
* **immich-machine-learning**: Optional service for AI features, supports hardware acceleration.
* **redis**: Redis cache for performance.
* **database**: PostgreSQL database for storing metadata.

### Important Notes

* Make sure **traefik-network** exists so that Traefik can route traffic to Immich.
* The server and ML services use volumes for persistent storage and model caching.
* Ports and network labels are already configured for Traefik routing.
* You can tweak environment variables in the `.env` file for DB credentials, upload location, and other options.

## Accessing Immich

* After `docker-compose up -d`, access the web interface at `http://immich.<your-domain>` or the port you mapped if not using Traefik.
* Follow the setup instructions in the web UI to configure admin account and users.

## Notes

* Keep your `.env` file updated with proper paths and passwords.
* You can enable hardware acceleration for transcoding or ML if your hardware supports it by following Immich docs.
* Traefik labels in this Compose file are an example of configuring routing via labels (you could also use dynamic config files).

> This folder contains the Compose file and notes to help you run Immich on your homelab. Enjoy your self-hosted media backup! 🎉
