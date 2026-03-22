# Imagen base con Java 17 de Microsoft Dev Containers
FROM mcr.microsoft.com/devcontainers/java:1-17

# Eliminar el repositorio de Yarn para evitar el error de clave GPG (no es necesario en este proyecto)
RUN rm -f /etc/apt/sources.list.d/yarn.list

# Instalar dependencias para GUI: TigerVNC, noVNC, websockify y un gestor de ventanas ligero
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
       tigervnc-standalone-server \
       tigervnc-common \
       novnc \
       websockify \
       openbox \
       xterm \
       dbus-x11 \
       x11-utils \
       libxtst6 \
       libxrender1 \
       libxi6 \
       fonts-dejavu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configurar VNC sin contraseña (entorno de desarrollo)
RUN mkdir -p /home/vscode/.vnc \
    && echo "1234" | vncpasswd -f > /home/vscode/.vnc/passwd \
    && chmod 600 /home/vscode/.vnc/passwd \
    && chown -R vscode:vscode /home/vscode/.vnc

# Script de arranque para VNC + noVNC
RUN echo '#!/bin/bash\n\
vncserver :1 -geometry 1280x800 -depth 24 -localhost no &\n\
sleep 2\n\
websockify --web=/usr/share/novnc/ 6080 localhost:5901 &\n\
openbox-session &\n\
echo "VNC y noVNC iniciados. Abre el puerto 6080 en tu navegador."' \
    > /home/vscode/start-vnc.sh \
    && chmod +x /home/vscode/start-vnc.sh \
    && chown vscode:vscode /home/vscode/start-vnc.sh

EXPOSE 5901 6080
