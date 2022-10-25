#!/bin/bash

  function discordNotification() {
    DISCORD_TEXT_MSG="${1:-Something from discordNotification shell}"
    DISCORD_PJ=$2
    DISCORD_USERNAME=linuxTools-shell
    if [ -z ${DISCORD_WEBHOOK_TOKEN+x} ]; then
      echo "${DISCORD_TEXT_MSG}"
    elif [ -n "$DISCORD_PJ" ]; then
      curl -s -F "payload_json={\"username\": \"${DISCORD_USERNAME}\", \"content\":\"${DISCORD_TEXT_MSG}\"}" \
           -F "file1=@${DISCORD_PJ}" \
           "${DISCORD_WEBHOOK_TOKEN}" \
           || echo "unable to discord notify"
    else
      curl -s -X POST -H "Content-Type: application/json" \
           --data "{\"username\": \"${DISCORD_USERNAME}\", \"content\":\"${DISCORD_TEXT_MSG}\"}" \
           "${DISCORD_WEBHOOK_TOKEN}" \
           || echo "unable to discord notify"
    fi
  }
