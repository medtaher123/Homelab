# Nextcloud Docker Setup Guide ☁️

**Nextcloud** is a self-hosted cloud storage platform that lets you store, sync, and share files securely.

## Docker Compose Setup

Below is the Docker Compose configuration I used. Make sure to **change the passwords** before using it in production.

```yaml
services:
  db:
    image: mariadb
    restart: always
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    volumes:
      - ./db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root     # CHANGE THIS
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_PASSWORD=pass          # CHANGE THIS

  app:
    image: nextcloud
    restart: always
    ports:
      - 8083:80   # You can choose any port; 8083 is used here because multiple services are running
    links:
      - db
    volumes:
      - ./data:/var/www/html
    environment:
      - MYSQL_PASSWORD=pass          # CHANGE THIS
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=db
```

## Instructions

1. Save the `docker-compose.yml` file in a folder on your server.
2. Run `docker-compose up -d` to start the Nextcloud instance.
3. Access Nextcloud in your browser at `http://<server-ip>:8083` (or the port you chose).

## Notes

* Remember to change all default passwords for security.
* The database data is stored in `./db` and Nextcloud files in `./data`.
* Ensure your firewall and router settings allow access to the chosen port (8083 in this example).
