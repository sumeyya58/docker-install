#!/bin/bash

# Exit on any error
set -e

# Update package index
sudo apt update

# Install prerequisites for adding the Docker repository
sudo apt install -y ca-certificates curl gnupg

# Create directory for keyrings
sudo mkdir -p /etc/apt/keyrings
sudo chmod 755 /etc/apt/keyrings

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod 644 /etc/apt/keyrings/docker.gpg  # Ensure file is readable by all

# Set up the Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index with Docker repo included
sudo apt update

# Install Docker Engine, CLI, and containerd
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Download and install Docker Compose (specific version for reliability)
# Check for the latest stable version at https://github.com/docker/compose/releases
DOCKER_COMPOSE_VERSION="v2.33.1"  
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Verify Docker and Docker Compose installation
docker --version
docker-compose --version

# Add current user to the docker group (optional, to run Docker without sudo)
sudo usermod -aG docker $USER

echo "Docker and Docker Compose installed successfully. Log out and back in to use Docker without sudo."
