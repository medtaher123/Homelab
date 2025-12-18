#!/bin/bash

# Let user pick a Docker Compose file
echo "Looking for docker-compose YAML files in the current directory..."
FILES=$(ls *.yml 2>/dev/null; ls *.yaml 2>/dev/null)
if [ -z "$FILES" ]; then
  echo "No YAML files found in this directory. Exiting."
  exit 1
fi

FILE=$(echo "$FILES" | fzf --height 10 --reverse --border --prompt="Select a Docker Compose file: ")
if [ -z "$FILE" ]; then
  echo "No file selected. Exiting."
  exit 1
fi

echo "You selected file: $FILE"

# Check if file exists (extra safety)
if [ ! -f "$FILE" ]; then
  echo "Error: $FILE not found."
  exit 1
fi

echo "Reading Docker Compose services..."
SERVICES=$(yq '.services | keys | .[]' "$FILE")
if [ -z "$SERVICES" ]; then
  echo "No services found in $FILE."
  exit 1
fi

echo "Please select the service to add Traefik labels and network:"
SERVICE=$(echo "$SERVICES" | fzf --height 10 --reverse --border --prompt="Select a service: " \
  --preview "yq '.services.\"{}\"' $FILE")
if [ -z "$SERVICE" ]; then
  echo "No service selected. Exiting."
  exit 1
fi

echo "You selected service: $SERVICE"

# Check if traefik-network already exists for this service
HAS_NETWORK=$(yq ".services.\"$SERVICE\".networks[]? | select(. == \"traefik-network\")" "$FILE")
if [ -n "$HAS_NETWORK" ]; then
  echo "Service $SERVICE already has traefik-network. No changes made."
  exit 0
fi

# Ask the user if they want to rename the service for Traefik
read -p "Do you want to use the service name '$SERVICE' in Traefik labels? (y/n): " USE_ORIGINAL
if [[ "$USE_ORIGINAL" =~ ^[Nn]$ ]]; then
  read -p "Enter the custom name to use in Traefik labels: " CUSTOM_NAME
  TRAEFIK_NAME="$CUSTOM_NAME"
else
  TRAEFIK_NAME="$SERVICE"
fi

echo "Traefik labels will use the name: $TRAEFIK_NAME"


# Extract exposed ports from the selected service
INTERNAL_PORTS=$(yq ".services.\"$SERVICE\".ports[]" "$FILE" 2>/dev/null | awk -F':' '{print $NF}')

if [ -n "$INTERNAL_PORTS" ]; then
  echo "Select the internal port Traefik should route to:"
  PORT=$(echo -e "$INTERNAL_PORTS\n<Custom>" | fzf --height 10 --reverse --border --prompt="Select a port or <Custom>: ")
  if [ "$PORT" == "<Custom>" ]; then
    read -p "Enter the internal port manually: " PORT
  fi
else
  read -p "No internal ports found. Enter the port manually: " PORT
fi

echo "Using port $PORT for Traefik routing."


# Create a backup with automatic increment
BACKUP_FILE="$FILE.bak"
COUNT=1
while [ -f "$BACKUP_FILE" ]; do
  BACKUP_FILE="$FILE.bak.$COUNT"
  COUNT=$((COUNT + 1))
done

cp "$FILE" "$BACKUP_FILE"
echo "Backup of $FILE created as $BACKUP_FILE"


echo "Adding Traefik labels for $SERVICE..."

# Define each label as an exported variable
export LABEL1="'traefik.http.routers.${TRAEFIK_NAME}.rule=HostRegexp(\`^${TRAEFIK_NAME}\..+\$\`) || PathPrefix(\`/${TRAEFIK_NAME}\`)'"
export LABEL2="\"traefik.http.middlewares.${TRAEFIK_NAME}-remove-prefix.stripprefix.prefixes=/${TRAEFIK_NAME}\""
export LABEL3="\"traefik.http.routers.${TRAEFIK_NAME}.middlewares=${TRAEFIK_NAME}-remove-prefix\""
export LABEL4="\"traefik.http.services.${TRAEFIK_NAME}.loadbalancer.server.port=${PORT}\""
export LABEL5="\"traefik.docker.network=traefik-network\""

echo "test"

# Assign the labels to the service using yq env()
yq eval -i '.services."'"$SERVICE"'".labels = [env(LABEL1), env(LABEL2), env(LABEL3), env(LABEL4), env(LABEL5)]' "$FILE"




echo "Labels added successfully."

echo "Attaching $SERVICE to traefik-network (preserving default network)..."

HAS_NETWORKS=$(yq '.services."'"$SERVICE"'".networks?' "$FILE")

if [ "$HAS_NETWORKS" = "null" ]; then
  echo "Service has no explicit networks. Adding default + traefik-network."
  yq -i '
    .services."'"$SERVICE"'".networks = ["default", "traefik-network"]
  ' "$FILE"
else
  echo "Service already has networks. Appending traefik-network."
  yq -i '
    .services."'"$SERVICE"'".networks += ["traefik-network"]
  ' "$FILE"
fi

echo "Network added successfully."

# Ensure traefik-network is declared as external
EXISTS_EXTERNAL=$(yq '.networks.traefik-network.external?' "$FILE")
if [ "$EXISTS_EXTERNAL" != "true" ]; then
  echo "Declaring traefik-network as external..."
  yq -i "
.networks.traefik-network.external = true
" "$FILE"
  echo "traefik-network declared as external."
else
  echo "traefik-network already declared as external. No changes made."
fi

echo
echo
echo "✅ Traefik setup completed for $SERVICE in file $FILE."
echo
echo "Next steps:"
echo "1. Make sure you save any other changes to your Docker Compose file."
echo "2. Run the following command to apply the changes and start the service:"
echo "   docker-compose -f $FILE up -d"
echo
echo "Traefik will automatically detect the new labels and route traffic to your service."