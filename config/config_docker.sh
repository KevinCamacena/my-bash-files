#!/bin/bash

set -e # Exit on error

echo "=== Docker Permission Configuration Script ==="

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
  echo "❌ Docker is not installed. Please install Docker first."
  exit 1
fi

echo "✓ Docker is installed"

# Check if Docker daemon is running
if ! sudo systemctl is-active --quiet docker 2>/dev/null && ! sudo service docker status >/dev/null 2>&1; then
  echo "⚠ Docker daemon is not running. Starting Docker..."
  if command -v systemctl &>/dev/null; then
    sudo systemctl start docker
    sudo systemctl enable docker
  else
    sudo service docker start
  fi
  echo "✓ Docker daemon started"
fi

# Create the docker group if it doesn't exist
if ! getent group docker >/dev/null; then
  echo "Creating the Docker group..."
  sudo groupadd docker
  echo "✓ Docker group created"
else
  echo "✓ Docker group already exists"
fi

# Add the current user to the Docker group
if groups $USER | grep -q '\bdocker\b'; then
  echo "✓ User $USER is already in the docker group"
else
  echo "Adding user $USER to the Docker group..."
  sudo usermod -aG docker $USER
  echo "✓ User added to docker group"
fi

# Set proper permissions on the Docker socket
echo "Setting permissions on Docker socket..."
sudo chmod 666 /var/run/docker.sock

# Test Docker access
echo ""
echo "Testing Docker access..."
if docker ps >/dev/null 2>&1; then
  echo "✓ Docker is working correctly!"
  docker --version
else
  echo "⚠ Docker test failed. Attempting to fix socket permissions..."
  sudo chown root:docker /var/run/docker.sock
  sudo chmod 660 /var/run/docker.sock

  # Try again
  if docker ps >/dev/null 2>&1; then
    echo "✓ Docker is now working!"
  else
    echo "❌ Still having issues. Please try the following:"
    echo "   1. Log out and log back in"
    echo "   2. Or run: newgrp docker"
    echo "   3. Or reboot your system"
  fi
fi

echo ""
echo "=== Configuration Complete ==="
echo "If you still get permission errors, run one of these:"
echo "  • newgrp docker    (applies changes to current shell)"
echo "  • Log out and log back in"
echo "  • Reboot your system"
