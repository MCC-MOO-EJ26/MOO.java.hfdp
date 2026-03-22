#!/bin/bash
set -e

VNC_DISPLAY=":1"
VNC_PORT="${VNC_PORT:-5901}"
NOVNC_PORT="${NOVNC_PORT:-6080}"
VNC_RESOLUTION="${VNC_RESOLUTION:-1280x800}"
VNC_DEPTH="${VNC_DEPTH:-24}"
VNC_PASSWD_FILE="$HOME/.vnc/passwd"

# Create VNC password file if it doesn't exist (use random password)
if [ ! -f "$VNC_PASSWD_FILE" ]; then
    mkdir -p "$HOME/.vnc"
    VNC_RANDOM_PASS="$(openssl rand -base64 12)"
    echo "$VNC_RANDOM_PASS" | vncpasswd -f > "$VNC_PASSWD_FILE"
    chmod 600 "$VNC_PASSWD_FILE"
    echo "🔑 VNC password set to: $VNC_RANDOM_PASS"
fi

# Create Xstartup script for fluxbox window manager
cat > "$HOME/.vnc/xstartup" << 'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XKL_XMODMAP_DISABLE=1
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey &
fluxbox &
EOF
chmod +x "$HOME/.vnc/xstartup"

# Kill any existing VNC server on display :1
vncserver -kill "$VNC_DISPLAY" 2>/dev/null || true
sleep 1

# Start TigerVNC server
vncserver "$VNC_DISPLAY" \
    -geometry "$VNC_RESOLUTION" \
    -depth "$VNC_DEPTH" \
    -rfbport "$VNC_PORT" \
    -rfbauth "$VNC_PASSWD_FILE" \
    -localhost no

echo "✅ TigerVNC server started on display $VNC_DISPLAY (port $VNC_PORT)"

# Start noVNC websocket proxy in the background
NOVNC_PATH="/usr/share/novnc"
if [ -d "$NOVNC_PATH" ]; then
    websockify --web="$NOVNC_PATH" --daemon \
        --log-file=/tmp/novnc.log \
        "$NOVNC_PORT" "localhost:$VNC_PORT"
    echo "✅ noVNC started on port $NOVNC_PORT"
    echo "🌐 Open noVNC in your browser at: http://localhost:$NOVNC_PORT/vnc.html"
else
    echo "⚠️  noVNC path not found at $NOVNC_PATH. Skipping noVNC startup."
fi
