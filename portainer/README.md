# Portainer Docker Setup Guide ⚓

**Portainer** is a lightweight management UI for Docker, allowing easy monitoring and administration of containers, volumes, networks, and images.

## Standard Docker Compose Setup

Here is the standard Docker Compose configuration:

```yaml
services:
  portainer:
    container_name: portainer
    image: portainer/portainer-ce:lts
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    ports:
      - 9443:9443
      - 8082:9000

volumes:
  portainer_data:
    name: portainer_data

networks:
  default:
    name: portainer_network
```

## Traefik Version

There is also a version with **Traefik** configuration included in the repository.

## Instructions

1. Save the `docker-compose.yml` file in a folder on your server.
2. Run `docker-compose up -d` to start Portainer.
3. Access Portainer at `https://<server-ip>:9443` or `http://<server-ip>:8082`.

## Notes

* The database and configuration are stored in the volume `portainer_data`.
* Ensure the ports do not conflict with other services.
* If using the Traefik version, make sure `traefik-network` exists and Traefik is running.
* **Important:** When I did this project, Docker v29 had issues with Portainer, causing difficulties accessing containers. I downgraded to Docker v28 to solve the problem. If you encounter similar issues, consider using v28.
