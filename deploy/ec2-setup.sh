#!/bin/bash
# Run on Ubuntu 22.04 EC2 after cloning the repo.
set -e

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl git

# Docker
if ! command -v docker &>/dev/null; then
  curl -fsSL https://get.docker.com | sudo sh
  sudo usermod -aG docker "$USER"
fi

# Docker Compose plugin
if ! docker compose version &>/dev/null; then
  sudo apt-get install -y docker-compose-plugin
fi

REPO_DIR="${1:-$HOME/devops-internship-project}"
if [ ! -d "$REPO_DIR/.git" ]; then
  git clone https://github.com/ismail-at-git/devops-internship-project.git "$REPO_DIR"
fi
cd "$REPO_DIR"

if [ ! -f backend/.env ]; then
  echo "Create backend/.env from backend/.env.example before continuing."
  exit 1
fi

docker compose build
docker compose up -d
docker compose ps

PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s icanhazip.com)
echo "App: http://${PUBLIC_IP}:8080"
echo "Add ${PUBLIC_IP} to MongoDB Atlas Network Access if not using 0.0.0.0/0."
