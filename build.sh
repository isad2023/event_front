#!/bin/bash

# Build script for event_front service
set -e  # Exit on any error

echo "🚀 Starting build process..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml not found in current directory"
    exit 1
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker compose down

# Remove old images (optional, uncomment if needed)
# echo "🗑 Removing old images..."
# docker compose down --rmi all

# Build the event_front image with the specified tag
echo "🏗 Building the event_front image with tag auxxxxx/prog2025-event_front..."
docker build -t auxxxxx/prog2025-event_front .

# Start services with Docker Compose
echo "🏗 Starting services with Docker Compose..."
docker compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 3

# Check if services are running
echo "🔍 Checking service status..."
docker ps

echo "ℹ️ No test service found in docker-compose.yml"

echo "✅ Build completed successfully!"
echo "🌐 Services are running. Check docker compose ps for details."
echo "🏃 To view logs: docker compose logs -f"
echo "🛑 To stop services: docker compose down" 