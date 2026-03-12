# Uptime Kuma ⏱️🩺

Welcome to the **Uptime Kuma** service! If Homepage is the front door to your homelab, think of Uptime Kuma as your server's **heartbeat monitor and alarm system**.

## What is Uptime Kuma?

When you start running multiple services (like media servers, dashboards, and file syncs), occasionally things will crash. A Docker container might freeze, a recent update might break a configuration, or a service might run out of memory. 

Uptime Kuma is a brilliant, open-source monitoring tool. Instead of finding out your media server is down when you sit on the couch to watch a movie, Kuma constantly checks it in the background and alerts you the second it stops responding.

**Why we use it:**
* **Active Monitoring:** It can ping your other containers (like `http://homepage:3000` or `192.168.1.50`) every 30 seconds to make sure they are actually alive.
* **Instant Alerts:** If a service drops offline, Kuma can instantly send you a message via Discord, Telegram, Slack, Email, or push notification. 
* **Beautiful Status Pages:** You can build a public "All Systems Operational" page to show off the health of your homelab to your friends and family.

## How it works

Unlike Homepage (which is configured using text files), Uptime Kuma is entirely managed through its own beautiful web interface. You don't need to write any code to set up your monitors.

It stores all of your monitors, alert settings, and ping history in a simple internal database (SQLite). Because of this, our Docker setup only needs to map a single folder (`./data`) to keep all your settings safe if the container ever restarts.

### 🧠 Pro-Tip: The "Dead House" Paradox

Because Uptime Kuma lives *inside* your server, it is incredible at monitoring your internal, private network. However, there is a catch: **If your house loses power, or your internet drops, Uptime Kuma dies with it!** It cannot send you a Discord message saying the server is down if the server has no power. 

*Best Practice:* Use Uptime Kuma to monitor all your internal apps and Docker containers. For your main internet connection, consider using a free external cloud service (like UptimeRobot) just to ping your home router from the outside world!

## Quick Start

1. Ensure you are inside the `kuma` folder.
2. Run the following command to download and start the monitor:

```bash
docker compose up -d
```

3. Open your browser and go to `http://<your-server-ip>:3001`. 

