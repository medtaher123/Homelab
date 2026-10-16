# scanservjs Docker Setup Guide 📄

**scanservjs** is a web front end for [SANE](http://www.sane-project.org/) scanners. It lets you scan documents from a browser instead of sitting at the machine the scanner is plugged into.

The image used here is [`sbs20/scanservjs`](https://github.com/sbs20/scanservjs).

This is the sequel to the [CUPS print server](../cups/README.md). Printing was solved. Scanning was not.

---

## The Story: Same Machine, Other Direction 📖

So the printer pilgrimage was over. CUPS was running, the USB cable stayed in the server, and I could print from the couch. Living in the future. 🚀

Then I needed to scan something.

Same machine. Same USB port. Completely different problem. Printing pushes paper **out**. Scanning pulls a document **in**, and the only software that could talk to this scanner wanted me physically next to it again. The new routine:

1. Realize I need a scan
2. Get up from the desk
3. Walk to the server with the document
4. Fumble with the scanner software
5. Email the PDF to myself
6. Walk back
7. Repeat

I had just spent a weekend teaching the homelab to print. I was not about to keep walking documents over to it. 😅

SANE already sees the scanner on the host (`scanimage -L` lists it). What was missing was a page I could open from a phone. **scanservjs** is that page: a small web UI in front of SANE, running in Docker with the USB bus passed through, behind Traefik at `scan.<domain>`.

Put the page on the glass, open the site, hit scan, download the PDF. The cable never moves. Same "why didn't I do this sooner?" feeling as CUPS, just in the other direction. 📄

---

## Why Use scanservjs? 🤔

* **Browser UI**: Scan, preview, and download from any device on the LAN.
* **USB scanner on the server**: The scanner stays plugged into the homelab host.
* **SANE underneath**: Uses the same backends as `scanimage` on the host.
* **Traefik**: Reachable as `scan.<your-domain>` or under the `/scan` path prefix.

This setup pairs with the host CUPS install: CUPS shares the printer, scanservjs shares the scanner.

---

## Docker Compose Overview

* **scanservjs**: Privileged container with the USB bus mounted so it can talk to the scanner.
* **Port**: `8093` on the host maps to `8080` in the container.
* **Config**: Host SANE config for the Epson backend is mounted read-only at `/etc/sane.d/epson2.conf`.
* **Traefik**: Router name `scan`, strip prefix `/scan`, load balancer port `8080`.

The container needs `privileged: true` and `/dev/bus/usb` because SANE talks to the scanner over USB.

---

## Installation Steps 🚀

1. **Install SANE on the host and confirm the scanner is visible**:

   ```bash
   sudo apt update
   sudo apt install sane-utils
   scanimage -L
   ```

   `scanimage -L` should list the device before you start the container. If it does not, fix drivers and `/etc/sane.d` on the host first. The container only mounts `epson2.conf`; other scanners need their own backend file mounted the same way.

2. **Create the directory and copy the compose file**:

   ```bash
   mkdir -p ~/scanservjs
   cp /path/to/homelab-repo/scanservjs/docker-compose.yml ~/scanservjs/
   cd ~/scanservjs
   ```

3. **Start it** (Traefik’s external network must already exist):

   ```bash
   docker compose up -d
   ```

4. **Open the UI**:
   - Direct: `http://<server>:8093`
   - Traefik: `http://scan.<your-domain>`

---

## Notes 📝

* If the scanner disappears after a reboot, unplug and replug it, then restart the container. USB device nodes are created when the device enumerates.
* Change the host port `8093` if something else already uses it.
* For a non-Epson scanner, replace the `epson2.conf` volume with the matching file under `/etc/sane.d/`.

---

## Useful Links 🔗

* [scanservjs](https://github.com/sbs20/scanservjs)
* [SANE supported devices](http://www.sane-project.org/sane-mfgs.html)
