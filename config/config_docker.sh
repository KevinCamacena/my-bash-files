#!/bin/bash

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
  echo "Docker is not installed. Please install Docker first."
  exit 1
fi

# Create the docker group if it doesn't exist
if ! getent group docker >/dev/null; then
  echo "Creating the Docker group..."
  sudo groupadd docker
fi

# Add the current user to the Docker group
echo "Adding the current user to the Docker group..."
sudo usermod -aG docker $USER

# Inform the user to log out and back in
echo "Configuration completed. You need to log out and log back in for the changes to take effect."
echo "Alternatively, you can run 'newgrp docker' to apply the changes immediately."

# Verify Docker can run without sudo
echo "Verifying Docker access without root..."
newgrp docker <<EONG
docker run hello-world
EONG
