# Glance Dashboard Setup Guide 📊

**Glance** is a self-hosted dashboard that brings all your important information to one beautiful, customizable page. It's like having your own personal information hub—check weather, RSS feeds, news, markets, GitHub releases, Twitch streams, videos, and so much more, all from one place. 

Think of it as a modern, self-hosted alternative to services like Google News or Apple News+, but **you control everything**. 🎯

---

## The Story: Why I Set This Up 📖

I realized I had this bad habit: every morning, I'd open my browser and hit at least 5 different tabs to get my daily information fix.

Tab 1: Reddit for tech news. Tab 2: Hacker News. Tab 3: YouTube for new uploads. Tab 4: Weather. Tab 5: Market prices. Tab 6: Sometimes more...

It was chaotic. Every single morning, same routine, same tabs. I'd think *"there has to be a better way to aggregate all this information into one place."* 

Then I discovered Glance. Now I have one dashboard that loads all of that automatically. Open my browser, boom—everything I need is right there. No clicking around. No juggling tabs. Just a beautiful, customizable dashboard with all my feeds, weather, markets, and more organized exactly how I want them.

The best part? It's completely self-hosted, works offline for cached content, and I can add literally any widget I want. It's become my homelab's "command center"—the first page I see every morning. Way better than bouncing between 6 different websites. ✨

---

## Why Use Glance? 🤔

* **All-in-One Dashboard**: Aggregate RSS feeds, news, weather, markets, streams, and more on one page.
* **Highly Customizable**: Create multiple pages, arrange widgets, and configure exactly what you want to see.
* **Privacy-Focused**: Self-hosted dashboard—no tracking, no analytics, no selling your data.
* **Fast & Lightweight**: Built in Go, runs efficiently even on low-power hardware.
* **Flexible Widgets**: Calendar, weather, RSS, Reddit, Hacker News, YouTube, Twitch, markets, releases, and more.
* **Environment Variables**: Use secrets from `.env` file in your configuration for API tokens and sensitive data.
* **Offline Support**: Cached content is available even if services go down.
* **Easy to Extend**: Add custom CSS and configure via simple YAML files.

Perfect for homelabbers who want a central hub to monitor their tech world without relying on corporate dashboards.

---

## Docker Compose Overview

The Compose file contains the **Glance** service:

* **glance**: The main dashboard application, mounts configuration files and integrates with Traefik for web access.

### Key Configuration Notes

* **Network**:
  - Uses standard Docker networks (`default` + `traefik-network`) to integrate with Traefik.
* **Ports**:
  - `8087:8080` → Web interface (change `8087` if this port conflicts)
* **Volumes**:
  - `./config:/app/config` → Dashboard configuration YAML files
  - `./assets:/app/assets` → Custom CSS and assets
  - `/etc/localtime:/etc/localtime:ro` → Local timezone (read-only)
  - `/var/run/docker.sock:/var/run/docker.sock:ro` → Optional, for Docker containers widget
* **Traefik labels**:
  - Routes traffic to `glance.<your-domain>` or via `/glance` path prefix
  - Strips `/glance` prefix for proper routing
  - Configures Glance service port (`8080`) for Traefik

* **Environment Variables** (see `.env.example`):
  - `MY_SECRET_TOKEN` → Store API tokens or secrets here to use in config files via `${MY_SECRET_TOKEN}`

---

## Installation Steps 🚀

1. **Create the Glance directory**:
   ```bash
   mkdir -p ~/glance/{config,assets}
   cd ~/glance
   ```

2. **Copy the configuration files**:
   Copy the `docker-compose.yml` and `.env.example` from this folder:
   ```bash
   cp /path/to/homelab-repo/glance/docker-compose.yml .
   cp /path/to/homelab-repo/glance/.env.example .env
   ```

3. **Create a basic configuration** (optional):
   Create `config/glance.yml`:
   ```yaml
   server:
     assets-path: /app/assets

   theme:
     custom-css-file: /assets/user.css

   pages:
     - $include: home.yml
   ```

4. **Create your home page** (optional):
   Create `config/home.yml`:
   ```yaml
   - name: Home
     columns:
       - size: small
         widgets:
           - type: calendar
             first-day-of-week: monday

           - type: weather
             location: "London, United Kingdom"
             units: metric

       - size: full
         widgets:
           - type: hacker-news
           - type: rss
             feeds:
               - url: https://example.com/feed.xml
                 title: My Feed
   ```

5. **Configure environment variables** (optional):
   Edit the `.env` file to add any API tokens or secrets:
   ```bash
   nano .env
   ```

6. **Start the container**:
   ```bash
   docker compose up -d
   ```

7. **Access Glance**:
   - Via Traefik: `http://glance.<your-domain>` or `http://<server-ip>/glance`
   - Direct access: `http://<server-ip>:8087`

---

## Available Widgets 📦

Glance comes with many built-in widgets:

| Widget | Description |
|--------|-------------|
| `calendar` | Calendar widget with customizable first day of week |
| `weather` | Weather display with temperature, conditions, and forecasts |
| `rss` | RSS feed aggregation with caching and limit options |
| `hacker-news` | Latest from Hacker News |
| `reddit` | Reddit subreddit feed with optional thumbnails |
| `twitch-channels` | Display online/offline status of Twitch channels |
| `youtube` | Video uploads from YouTube channels |
| `videos` | Group widget for video content |
| `markets` | Stock prices, crypto, and other market data |
| `releases` | GitHub release notifications for repositories |
| `lobsters` | Lobsters.rs tech community feed |
| `docker-containers` | Show Docker containers status (requires docker.sock mount) |
| `group` | Group multiple widgets together |

---

## Configuration Examples 💡

### Simple Dashboard with Weather, Calendar, and News

Create `config/home.yml`:

```yaml
- name: Home
  columns:
    - size: small
      widgets:
        - type: calendar
          first-day-of-week: monday

        - type: weather
          location: "New York, United States"
          units: imperial
          hour-format: 12h

    - size: full
      widgets:
        - type: hacker-news
        - type: rss
          limit: 10
          feeds:
            - url: https://example.com/feed.xml
              title: My Tech Blog
```

### Tech Dashboard with Multiple News Sources

Create `config/tech.yml`:

```yaml
- name: Tech
  columns:
    - size: small
      widgets:
        - type: rss
          collapse-after: 3
          feeds:
            - url: https://news.ycombinator.com/rss
              title: Hacker News
            - url: https://www.reddit.com/r/selfhosted/.rss
              title: r/selfhosted

    - size: full
      widgets:
        - type: group
          widgets:
            - type: youtube
              channels:
                - UCR-DXc1voovS8nhAvccRZhg # Jeff Geerling
                - UCBJycsmduvYEL83R_U4JriQ # Marques Brownlee
            - type: twitch-channels
              channels:
                - theprimeagen
                - EJ_SA
```

### Using Environment Variables for API Tokens

In `.env`:
```
GITHUB_TOKEN=ghp_your_github_token_here
```

In `config/home.yml`:
```yaml
- type: releases
  token: ${GITHUB_TOKEN}
  repositories:
    - myrepo/myproject
    - golang/go
```

---

## Custom CSS Styling 🎨

Create `assets/user.css` to customize the appearance:

```css
/* Change primary color */
:root {
  --color-primary: #ff6b6b;
}

/* Darken background */
body {
  background-color: #1a1a1a;
  color: #ffffff;
}

/* Custom widget styling */
.widget {
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
}
```

---

## Ports Overview 🌐

| Service | Port | Purpose                                |
|---------|------|----------------------------------------|
| Glance  | 8087 | Web UI (change if conflicts exist)     |

---

## Tips & Notes 💡

* **Multiple Pages**: You can create multiple pages by defining different sections in YAML and including them.
* **Caching**: RSS feeds and other content can be cached to improve performance—set `cache: 12h` for feeds.
* **Docker Socket**: Mount `/var/run/docker.sock` if you want to use the Docker containers widget to see container status.
* **Timezone**: The `/etc/localtime:ro` mount ensures the container uses your server's timezone.
* **Responsive Design**: Glance works great on desktop, tablet, and mobile—customize column sizes accordingly.
* **Performance**: Built in Go, very fast and lightweight. Works great on ARM devices like Raspberry Pi.
* **Offline Content**: Cached content is available even if external services are down.
* **Configuration Reload**: Edit YAML files and restart the container to apply changes: `docker compose restart`

---

## Troubleshooting 🔧

### Dashboard Not Loading

- Check if container is running: `docker compose ps`
- View logs: `docker compose logs -f glance`
- Ensure config files are readable: `ls -la config/`

### Widgets Not Showing Content

- Check external service is accessible from the container
- For RSS feeds, ensure feed URL is valid
- Check logs for specific widget errors: `docker compose logs glance | grep widget`
- Some feeds may require authentication (API tokens)

### Configuration Not Updating

- After editing YAML files, restart the container: `docker compose restart`
- For environment variables, restart is required: `docker compose up -d`

### Port Already in Use

- Change the port mapping in `docker-compose.yml`
- Or find what's using port 8087: `sudo lsof -i :8087`

---

## Useful Links 🔗

* [Glance GitHub Repository](https://github.com/glanceapp/glance)
* [Glance Official Documentation](https://github.com/glanceapp/glance/wiki)
* [Glance Widget Configuration](https://github.com/glanceapp/glance/wiki/Configuring-Glance)
* [Available Widgets & Examples](https://github.com/glanceapp/glance/wiki/Widgets)
* [Glance Docker Hub](https://hub.docker.com/r/glanceapp/glance)

---

> This folder contains the Docker Compose file, environment template, and setup guide to help you run Glance on your homelab. Build your perfect personal dashboard! 📊✨
