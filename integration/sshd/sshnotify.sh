#!/bin/bash
# SSH Notification Script
#
# Installation:
# 1. Place this script in /etc/ssh/scripts/sshnotify.sh
# 2. Make it executable: chmod +x /etc/ssh/scripts/sshnotify.sh
# 3. Add this line to /etc/pam.d/sshd:
#    session optional pam_exec.so seteuid /etc/ssh/scripts/sshnotify.sh
#
# WARN: double check by opening another ssh session in parallel before logging out to test current script

# Configuration - can be overridden by environment variables
# Default webhook URL
DISCORD_WEBHOOK_URL=${DISCORD_WEBHOOK_URL:-"https://discord.com/api/webhooks/xxx/updateme/yyy"}

# Excluded subnets (space-separated list of IP prefixes)
# Example: "10.0.1 192.168.1. 172.16"
EXCLUDED_SUBNETS=${EXCLUDED_SUBNETS:-"10.0.1"}

# Configuration file (will override defaults if exists)
CONFIG_FILE="/etc/ssh/scripts/notify.conf"
if [ -f "$CONFIG_FILE" ]; then
    # shellcheck disable=SC1090,SC1091
    source "$CONFIG_FILE"
fi

# Only run on session open, not on session close
if [ "$PAM_TYPE" != "close_session" ]; then
    # Get system info
    HOST="$(hostname)"
    USER="${PAM_USER}"
    REMOTE_IP="${PAM_RHOST}"
    DATE="$(date '+%Y-%m-%d %H:%M:%S')"

    # Check if the IP is from an excluded subnet
    IP_EXCLUDED=false

    for SUBNET in $EXCLUDED_SUBNETS; do
        # Check if IP starts with the subnet prefix (simple string matching)
        if [[ "$REMOTE_IP" == "$SUBNET"* ]]; then
            IP_EXCLUDED=true
            ## logger -p auth.debug "SSH login from excluded CIDR subnet ($SUBNET): $USER from $REMOTE_IP on $HOST"
            break
        fi
    done

    # Continue only if IP is not excluded
    if [ "$IP_EXCLUDED" = false ]; then
        # Get country info based on IP (if geoiplookup is installed)
        ## sudo apt install geoip-bin geoip-database
        COUNTRY=""
        if command -v geoiplookup &> /dev/null; then
            COUNTRY=$(geoiplookup "$REMOTE_IP" 2>/dev/null | head -n1 | cut -d':' -f2 | xargs)
            if [ -n "$COUNTRY" ]; then
                COUNTRY=" from $COUNTRY"
            fi
        fi

        # Check if this is a root login (higher security risk)
        ALERT_LEVEL=""
        if [ "$USER" = "root" ]; then
            ALERT_LEVEL=":warning: **ROOT LOGIN** :warning:"
        fi

        # Format the message
        MESSAGE="$DATE - SSH Login: $USER@$HOST from $REMOTE_IP$COUNTRY $ALERT_LEVEL"

        # Send to Discord
        curl -s -X POST -H "Content-Type: application/json" \
            -d "{\"username\": \"SSH-Notify\",\"content\": \"$MESSAGE\"}" \
            "$DISCORD_WEBHOOK_URL" > /dev/null

        ### Send to syslog
        ## logger -p auth.info "SSH login: $USER from $REMOTE_IP on $HOST"
    fi
fi
exit 0
