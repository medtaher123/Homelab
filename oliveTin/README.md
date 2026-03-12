# OliveTin 🫒🖥️

Welcome to the **OliveTin** service! If you ever get tired of opening a terminal, logging in via SSH, and typing out long commands just to restart a service or update your server, this is the tool for you.

## What is OliveTin?

OliveTin is a web interface for running Linux shell commands. It takes complex scripts or daily terminal commands and turns them into safe, clickable buttons on a webpage. 

**Why we use it:**
* **Convenience:** Reboot your server, update Docker containers, or wake up sleeping devices directly from your phone's web browser.
* **Safety:** You pre-define the exact commands in a configuration file. This means you (or family members) can click a "Restart Plex" button without accidentally breaking the server.

## The Big Choice: Docker vs. Bare Metal Install

When setting up OliveTin to manage your server, you have two distinct paths. It is important to understand the difference before you begin:

### 1. Direct Host Installation (The Easier Way)
You can install OliveTin directly onto your Ubuntu server (often called "bare metal") using a standard package manager. 
* **Why do it?** Because it runs directly on the host, it already has access to your system. If you create a button that runs `sudo reboot`, it will just work instantly without any extra configuration.
* **The downside:** It goes against the "Dockerized Homelab" philosophy. It scatters configuration files across your operating system instead of keeping them neatly inside a container.

### 2. Docker Installation (The Homelab Way)
You run OliveTin inside an isolated Docker container, just like Homepage, Plex, or Nextcloud.
* **Why do it?** It keeps your host machine completely clean. You can back up, move, or delete OliveTin in seconds. 
* **The downside (and our challenge):** Docker containers are built to be *isolated*. An OliveTin container cannot naturally reach out and reboot the host machine it lives on. It is trapped inside its box.

## Our Setup: Docker + SSH Bridge 🌉

In this homelab, **we chose the Docker route** to keep everything portable and clean. 

To solve the isolation problem, we use a clever trick: we give the OliveTin container its own set of SSH keys. When you click a button, the container officially SSHs into the host machine (just like you would from your laptop) to execute the command.

### Setting up the SSH Bridge (Follow these steps first!)

Before you can run `docker compose up -d`, you must generate an SSH key on your host machine and give the container permission to use it. 

Run these commands in your terminal, exactly inside this `olivetin` folder:

**1. Generate the key for the container to use:**
*(Note: We use `-N ""` to create a key with no password, because the container needs to log in automatically in the background).*
```bash
ssh-keygen -t ed25519 -f ./ssh/id_ed25519 -N "" -C "olivetin-docker-key"
```

**2. Trust the key on your host machine:**
This command copies the public half of the key we just made and adds it to your host's list of approved logins.

```bash
cat ./ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
```

*(Note: Depending on your exact Docker setup and permissions, you may need to ensure the ./ssh folder has strict 700 and 600 permissions so SSH doesn't reject it for being too open).*

## How to Configure Your Buttons
OliveTin builds its buttons by reading a file called `config.yaml` located in the `config/` folder.

Here is an example of what an action looks like inside that file:

```yaml
actions:
  - title: Reboot Host Machine
    icon: "&#128259;"
    # Notice how it uses the SSH key we generated to log into the host!
    shell: ssh -i /root/.ssh/id_ed25519 -o StrictHostKeyChecking=no your_username@host.docker.internal "sudo reboot"
    arguments:
      - type: confirmation
        title: Are you sure you want to REBOOT?

```

## Quick Start
1. Ensure you have run the two ssh-keygen commands above.

2. Edit the config/config.yaml file to match your host's username and the commands you want to run.

3. Start the container:

```Bash
docker compose up -d
```
4. Open your browser and go to `http://<your-server-ip>:1337` to see your new command dashboard!