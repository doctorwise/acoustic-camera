#!/bin/bash

# Script to start PulseAudio and configure it for Docker access on macOS

if ! command -v pulseaudio &> /dev/null; then
    echo "PulseAudio is not installed. Please install it first:"
    echo "brew install pulseaudio"
    exit 1
fi

echo "Starting PulseAudio..."
pulseaudio --start --exit-idle-time=-1

echo "Loading native-protocol-tcp..."
# Unload first just in case to avoid errors
pacmd unload-module module-native-protocol-tcp 2>/dev/null
# Load module accepting connections from everywhere (or restrict to local subnet)
# auth-anonymous=1 is easiest for local dev; for security, use cookie auth
pacmd load-module module-native-protocol-tcp port=4713 auth-ip-acl=127.0.0.1;192.168.0.0/16 auth-anonymous=1

echo "PulseAudio configured. Starting Docker Compose..."
docker-compose up --build
