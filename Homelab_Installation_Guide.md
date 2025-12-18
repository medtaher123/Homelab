# Homelab Installation & Setup Guide 🛠️

## OS Options 🖥️

When setting up a home lab, there are multiple OS options: Ubuntu Server, Debian, CentOS, Fedora, or even specialized NAS systems like TrueNAS. Each has its pros and cons.

## Choosing Ubuntu Server 🐧

I chose **Ubuntu Server** for my setup. Ubuntu Server is lightweight, stable, and well-supported, making it ideal for running multiple services in containers. It also allows full control through the terminal, which suits my workflow.

## GUI Setup 🌟

SSH connection is enough for most tasks, but I also installed a lightweight GUI: **XFCE**. XFCE is fast and minimal, unlike heavier alternatives like GNOME or KDE. I mostly stick to the terminal, but the GUI is useful when I need a browser to test services running on `localhost`.

To access the GUI from my Windows PC, I installed **xrdp**, which allows remote desktop connections.

## File Sharing 📂

I set up **Samba** to expose files over my local network, making it easy to access documents from any machine in the network.

## Main Services 🔧

* **Pi-hole**: DNS server and ad blocker (more details in the `pihole/README.md`).
* **Traefik**: Reverse proxy and routing (see `traefik/README.md`).
* **Immich**: Photo/video management.
* **Nextcloud**: Personal cloud storage.
* **Portainer**: Docker management dashboard.
* **Plex** & **Jellyfin**: Media servers.
* **ARR Stack**: Automation for TV/movies.

Each service has its own folder with detailed setup instructions.

## Networking 🌐

* The server has a **static IP** on my local network.
* For remote access outside my network, I used **Tailscale**, a VPN tool that creates a secure mesh network. It makes my server accessible safely without exposing ports directly to the internet.

## Mobile Access 📱

* **Termius**: SSH terminal on Android.
* **QuickEdit**: Edit files remotely.
* Hosted dashboards: Portainer, Cockpit, Pi-hole, Traefik and other services dashboards for browser access.

## Power Management ⚡

One challenge: I could shut down the server remotely, but turning it on required pressing the power button physically. To fix this, I set up **Wake-on-LAN (WOL)** in the BIOS. WOL allows a device to turn on when it receives a special network packet from another device.

Additionally, I enabled **auto power on** in the BIOS. If the power goes out, the server automatically turns back on when electricity is restored.

---

This document serves as a general overview. Each service folder contains detailed instructions, configurations, and tips for smooth operation.
