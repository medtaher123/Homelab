# n8n Docker Setup Guide 🔗

**n8n** (pronounced "nodemation") is a powerful workflow automation tool that lets you connect apps and automate tasks. It's like Zapier or Make.com, but **self-hosted and open-source**, giving you complete control over your automations and data. 🚀

Think of it as a visual programming tool where you can create workflows by connecting different services (Gmail, Slack, databases, APIs, etc.) without writing code—though you can add custom code if needed.

---

## Why Use n8n? 🤔

* **Self-Hosted**: Full control over your data and automations—no cloud vendor lock-in.
* **Open Source**: Free to use with an active community and extensive documentation.
* **350+ Integrations**: Connect to popular services, databases, APIs, and more.
* **Visual Workflow Builder**: Drag-and-drop interface for creating automations.
* **Extendable**: Write custom nodes with JavaScript/TypeScript if needed.
* **No Usage Limits**: Unlike cloud automation services, there are no artificial limits on executions or workflows.
* **Webhooks & APIs**: Trigger workflows via HTTP requests or scheduled cron jobs.

Perfect for automating tasks in your homelab like monitoring services, processing files, sending notifications, or integrating different systems.

---

## Docker Compose Overview

The Compose file contains the **n8n** service:

* **n8n**: The main workflow automation engine, connects to Traefik for web access, and uses persistent storage for workflows and credentials.

### Key Configuration Notes

* **Network**:
  - Uses standard Docker networks (`default` + `traefik-network`) to integrate with Traefik.
* **Ports**:
  - `5678:5678` → Web interface and webhook endpoint
* **Volumes**:
  - `n8n_data` → Named volume for n8n configuration, workflows, and credentials
  - `./local-files:/files` → Local folder for file operations in workflows (e.g., reading/writing files)
  - Optional: Mount additional directories like media folders if workflows need access
* **Traefik labels**:
  - Routes traffic to `n8n.<your-domain>` or via `/n8n` path prefix
  - Strips `/n8n` prefix for proper routing
  - Configures n8n service port (`5678`) for Traefik

* **Environment Variables** (see `.env.example`):
  - `DOMAIN_NAME` → Your n8n domain (e.g., `n8n.example.com`)
  - `SUBDOMAIN` → Optional subdomain (leave empty if using full domain)
  - `GENERIC_TIMEZONE` → Timezone for cron and scheduling nodes
  - `SSL_EMAIL` → Email for TLS/SSL certificate creation
  - `N8N_PROTOCOL` → Set to `https` when using Traefik with SSL
  - `N8N_RUNNERS_ENABLED` → Enable runners for executing workflows
  - `WEBHOOK_URL` → Base URL for webhooks

---

## Installation Steps 🚀

1. **Create the n8n directory**:
   ```bash
   mkdir -p ~/n8n
   cd ~/n8n
   ```

2. **Copy the configuration files**:
   Copy the `docker-compose.yml` and `.env.example` from this folder:
   ```bash
   cp /path/to/homelab-repo/n8n/docker-compose.yml .
   cp /path/to/homelab-repo/n8n/.env.example .env
   ```

3. **Configure environment variables**:
   Edit the `.env` file and customize the settings:
   ```bash
   nano .env
   ```
   
   Update:
   - `DOMAIN_NAME=n8n.yourdomain.com` (or your server IP for local access)
   - `GENERIC_TIMEZONE=Your/Timezone` (e.g., `America/New_York`, `Europe/London`)
   - `SSL_EMAIL=your-email@example.com`

4. **Create the local-files directory** (optional):
   ```bash
   mkdir -p local-files
   ```

5. **Start the container**:
   ```bash
   docker compose up -d
   ```

6. **Access n8n**:
   - Via Traefik: `http://n8n.<your-domain>` or `http://<server-ip>/n8n`
   - Direct access: `http://<server-ip>:5678`

7. **Initial Setup**:
   - On first access, create your admin account
   - Set up your owner credentials (username and password)
   - Start creating workflows!

---

## Workflow Tips & Use Cases 💡

Here are some practical automation ideas for your homelab:

* **Service Monitoring**: Create workflows that check if services are running and send alerts via email/Slack/Discord.
* **File Processing**: Automatically process files dropped in a folder (resize images, convert formats, etc.)
* **Backup Automation**: Trigger backups and send notifications when complete.
* **Media Management**: Integrate with Plex/Jellyfin to organize media or send notifications for new content.
* **Home Assistant Integration**: Automate smart home tasks based on sensor data or schedules.
* **API Integrations**: Connect different services in your homelab that don't natively talk to each other.
* **Data Collection**: Scrape websites, collect data, and store it in databases or spreadsheets.
* **Scheduled Tasks**: Run cron-based workflows for regular maintenance or reporting.

---

## Ports Overview 🌐

| Service | Port | Purpose                                    |
|---------|------|--------------------------------------------|
| n8n     | 5678 | Web UI and webhook endpoint                |

---

## Tips & Notes 📝

* **Local Files**: The `./local-files` directory is mounted to `/files` inside the container. Use this for file operations in workflows.
* **Webhooks**: Workflows can be triggered via webhooks at `http://<your-domain>/webhook/<webhook-id>`
* **Traefik Integration**: Make sure `traefik-network` exists if using Traefik routing.
* **Timezone**: Set `GENERIC_TIMEZONE` correctly for scheduled workflows and cron nodes to work as expected.
* **Credentials**: n8n stores credentials securely in the database. Back up the `n8n_data` volume regularly.
* **Community Nodes**: You can install additional community-built nodes from the n8n interface or CLI.
* **Custom Code**: Use Function and Code nodes to write custom JavaScript for complex logic.
* **Error Notifications**: Set up error workflows to get notified when automations fail.

---

## Security Considerations 🔒

* **Authentication**: Always set a strong password for your n8n admin account.
* **HTTPS**: Use Traefik with SSL certificates for secure access.
* **Firewall**: Don't expose port `5678` publicly unless necessary—use Traefik instead.
* **File Access**: The `N8N_RESTRICT_FILE_ACCESS_TO` variable controls which directories workflows can access.
* **Webhook Security**: Use webhook authentication or unique webhook IDs to prevent unauthorized triggers.

---

## Useful Links 🔗

* [n8n Official Documentation](https://docs.n8n.io/)
* [n8n GitHub Repository](https://github.com/n8n-io/n8n)
* [n8n Community](https://community.n8n.io/)
* [Workflow Templates](https://n8n.io/workflows/)
* [n8n Docker Documentation](https://docs.n8n.io/hosting/installation/docker/)

---

> This folder contains the Docker Compose file and environment configuration to help you run n8n on your homelab. Enjoy automating everything! 🎉
