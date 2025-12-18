# Traefik Setup Guide 🌐

**Traefik** is basically a reverse proxy and load balancer on steroids. It connects directly to Docker and just *magically* sees all your containers. No more fiddling with Nginx configs for every little service! 😎

You *could* use Nginx, but I went with Traefik because I already knew Nginx and wanted to play and discover what Traefik could do.

## Why Traefik is Awesome 🚀

* Finds your Docker containers automatically.
* Routes traffic based on domain names or paths.
* Handles HTTPS and load balancing.
* Lets you manage your network traffic like a boss.

## Ways to Configure Services 🛠️

There are a couple of ways to tell Traefik what to do:

1. **Labels in Docker Compose**: Stick the config directly into your `docker-compose.yml`. Quick, easy, and perfect for experimenting.
2. **Dynamic config files**: Keep all Traefik stuff in one place, nice and neat.

Personally, I like keeping Traefik configs together, but here I used **labels** to experiment and learn stuff.

## Networks and Traefik 🌐

For Traefik to route traffic to a service, the service must share a network with Traefik. In my setup, I created an **external network** called `traefik-network` where all my containers connect.

You can also:

* Create **multiple networks** (e.g., `pihole-traefik`, `portainer-traefik`) if you want separation and don't want containers to communicate with each other.
* Link Traefik to the **host network** without connecting to individual containers.
* Expose services that are **not running in Docker** (like my Pi-hole, exemple below) through Traefik using the host network.

## The Legendary `traefikize.sh` Script (that I am proud of) 🥳

Before using the script, make sure you have **fzf** and **yq** installed, otherwise it won't work.

I wrote this little gem to make adding Traefik labels super easy. Here's what it does:

* Lists all Docker Compose YAML files in your folder and lets you pick one with `fzf`.
* Shows all services in that Compose file and lets you pick which one to Traefik-ize.
* Lets you rename the service for Traefik labels if you feel fancy.
* Finds the internal ports and asks which one Traefik should route to.
* Backs up your Compose file before touching anything (because safety first).
* Adds all the right Traefik labels to the service.
* Makes sure the service is attached to `traefik-network` and the network is declared external.
* Prints out the next steps to run `docker-compose` and see it in action.

The script is super user-friendly (did I mention that I am proud of it?), and you can put it in your `bin` folder or anywhere in your `$PATH` to use it from anywhere.

> Quick tip: Install **fzf** (`sudo apt install fzf`) and **yq** (`sudo snap install yq`) before running the script.

## Dynamic Configuration Example

If you like living on the edge, you can also use dynamic config files, like this:

```yaml
http:
  routers:
    pihole:
      rule: 'HostRegexp(`^pihole\..+$`) || PathPrefix(`/pihole`)'
      service: pihole
      entrypoints:
        - web

  services:
    pihole:
      loadBalancer:
        servers:
          - url: "http://host.docker.internal:81"
```

Play around with it, tweak things, and see what magic happens.

---

This folder has my Traefik setup, notes, and the `traefikize.sh` script to make your life easier. Go wild!
