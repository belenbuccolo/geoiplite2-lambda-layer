#!/bin/bash
set -e

# Check if .env file exists
if [ ! -f .env ]; then
    echo ".env file not found. Please create one with your MAXMIND_LICENSE_KEY."
    exit 1
fi

# Load environment variables
source .env

# Check if MAXMIND_LICENSE_KEY is set
if [ -z "$MAXMIND_LICENSE_KEY" ]; then
    echo "MAXMIND_LICENSE_KEY is not set in .env file."
    exit 1
fi

# Remove existing layer directory
rm -rf layer

# Build Docker image
docker build --no-cache \
  --build-arg MAXMIND_LICENSE_KEY="$MAXMIND_LICENSE_KEY" \
  --build-arg MAXMIND_USER_ID="$MAXMIND_USER_ID" \
  -t nodejs-geoiplite2-lambda-layer .

# Create a container from the image
CONTAINER=$(docker create nodejs-geoiplite2-lambda-layer)

# Copy the layer contents from the container
docker cp $CONTAINER:/opt layer

# Remove the container
docker rm $CONTAINER

echo "Layer contents extracted successfully!"

# Create a ZIP file
(cd layer && zip -r ../lambda-layer.zip .)

echo "Lambda layer ZIP created successfully!"
