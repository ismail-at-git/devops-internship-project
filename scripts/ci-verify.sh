#!/bin/bash
set -e

echo "== Structure =="
test -f backend/server.js
test -f backend/package.json
test -f frontend/package.json
test -f docker-compose.yml
test -f frontend/nginx/nginx.conf

echo "== Backend =="
cd backend
npm ci
node --check server.js
cd ..

echo "== Frontend =="
cd frontend
npm ci
CI=true npm run build
cd ..

echo "== Docker build =="
docker compose build

echo "CI verify OK"
