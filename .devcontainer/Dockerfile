FROM mcr.microsoft.com/devcontainers/java:21-bullseye

# Install TigerVNC, noVNC, websockify, a lightweight window manager, and fonts
RUN apt-get update && apt-get install -y --no-install-recommends \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    fluxbox \
    xterm \
    x11-xserver-utils \
    dbus-x11 \
    fonts-dejavu-core \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set default display and VNC environment variables
ENV DISPLAY=:1
ENV VNC_PORT=5901
ENV NOVNC_PORT=6080
ENV VNC_RESOLUTION=1280x800
ENV VNC_DEPTH=24

# Copy startup script
COPY scripts/start-vnc.sh /usr/local/bin/start-vnc.sh
RUN chmod +x /usr/local/bin/start-vnc.sh
