#!/bin/bash
# add one line to:  /etc/pam.d/sshd
# session    optional     pam_exec.so seteuid /etc/ssh/scripts/sshnotify.sh
#
if [ "$PAM_TYPE" != "close_session" ]; then
DISCORD_WEBHOOK_TOKEN=https://discord.com/api/webhooks/xxx/updateme/yyy
host="$(hostname)"
user="${PAM_USER}"
remoteip="${PAM_RHOST}"
# curl -X POST --data "{\"type\": \"mrkdwn\",\"text\": \"${remoteip} - SSH Login : ${user} connected to \`$host\`\"}" ${SLACK_WEBHOOK_ENDPOINT}
curl -X POST -H "Content-Type: application/json" \
-d "{\"username\": \"ch-pam\",\"content\": \"${remoteip} - SSH Login : ${user} connected to \`$host\`\"}" \
${DISCORD_WEBHOOK_TOKEN}
fi
exit