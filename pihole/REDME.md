# Pi-hole Setup Guide 🛡️

**Pi-hole** is a network-wide ad blocker and DNS server.

I installed Pi-hole directly on my server because it handles most of the setup automatically. Using Docker for Pi-hole would require extra manual configuration on the Linux level.

## Installation

You can install Pi-hole using the official command:

```
curl -sSL https://install.pi-hole.net | bash
```

Follow the prompts to configure your network and select the upstream DNS provider.

## Basic Configuration

* Set a **static IP** for your server (recommended for DNS consistency).
* Choose the network interface to bind Pi-hole.
* Select your preferred block lists.

## Router DNS Settings 🌐

To make all devices on your network use Pi-hole as the DNS server, configure your router to use the server's IP as the primary DNS.

> Note: Some devices, like certain mobile phones, may ignore the network DNS settings. In those cases, you need to manually change the DNS settings on the device to use Pi-hole.

## Accessing the Dashboard

* Web interface: `http://<server-ip>/admin`
* Default login credentials are set during installation.
* From here you can monitor blocked requests, add whitelist/blacklist entries, and see statistics.

## Adding Custom Domain Names 🏷️

Pi-hole allows you to assign custom domain names to devices on your network. For example, you can link `homelab.local` to the static IP of your server. This makes it easier to access your services without remembering the IP address.

## Notes

* Make sure Pi-hole is reachable by all devices on your network.
* If using Traefik or another reverse proxy, configure routing carefully.
* For more advanced options like DHCP, refer to the Pi-hole documentation.

> This folder contains any additional scripts, configuration files, and notes related to my Pi-hole setup.
