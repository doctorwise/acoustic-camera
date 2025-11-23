FROM python:3.11-slim

# Install system dependencies
# pulseaudio, alsa-utils, libsndfile1 are needed for audio
# gcc, python3-dev are needed for building some python packages
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    pulseaudio \
    alsa-utils \
    libsndfile1 \
    libasound2-dev \
    portaudio19-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first for caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Environment variables
ENV PYTHONUNBUFFERED=1
ENV PULSE_SERVER=docker.for.mac.localhost

# Expose ports for Flask and Bokeh
EXPOSE 5000
EXPOSE 5006

# Command to run the application
# We need to make sure PulseAudio cookie is handled if needed,
# but usually setting PULSE_SERVER is enough if the host is configured correctly.
CMD ["python", "acoustic-camera/start.py"]
