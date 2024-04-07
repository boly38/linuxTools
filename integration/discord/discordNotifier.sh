#!/bin/bash
  removeDoubleQuotes() {
    sed 's/"//g'
    # EXAMPLES:
    # somethingThatProducesDoubleQuotesHere | removeDoubleQuotes
  }
  removeQuotes() {
    sed "s/'//g"
    # EXAMPLES:
    # somethingThatProducesQuotesHere | removeQuotes
  }

  function discordNotification() {
    DISCORD_TEXT_MSG=${1:-Something from discordNotification shell}
    DISCORD_TEXT_MSG=$(echo "${DISCORD_TEXT_MSG}"|removeDoubleQuotes|removeQuotes)
    DISCORD_PJ=$2
    DISCORD_USERNAME=linuxTools-shell
    if [ -z ${DISCORD_WEBHOOK_URL+x} ]; then
      echo " warn - no DISCORD_WEBHOOK_URL - unable to send to discord ${DISCORD_TEXT_MSG}"
      return;
    fi
    # discord webhook : https://discord.com/developers/docs/resources/channel#embed-object-embed-limits
    DISCORD_WEBHOOK_CONTENT_FIELD_MAX_LENGTH=2000
    MESSAGE_LENGTH=${#DISCORD_TEXT_MSG}
    if [[ ${MESSAGE_LENGTH} -gt ${DISCORD_WEBHOOK_CONTENT_FIELD_MAX_LENGTH} ]]; then
      echo " warn - message is too big (length > ${DISCORD_WEBHOOK_CONTENT_FIELD_MAX_LENGTH}),"\
      "please use file arg in addition to a short message - unable to send to discord ${DISCORD_TEXT_MSG}"
      return;
    fi

    # form_entries array
    form_entries=("payload_json='{\"username\": \"${DISCORD_USERNAME}\", \"content\":\"${DISCORD_TEXT_MSG}\"}'")
    if [ -n "$DISCORD_PJ" ]; then
      form_entries+=("file1=@${DISCORD_PJ}")
    fi
    # curl silent
    curl_args=("-s")
    # form entries as "-F" curl args
    for form_entry in "${form_entries[@]}" ; do
        curl_args+=(-F "$form_entry")
    done
    # curl target args
    curl_args+=("-X POST" "${DISCORD_WEBHOOK_URL}")
    # call curl
    # echo curl "${curl_args[@]}" || echo "unable to discord notify"
    # shellcheck disable=SC2294 # keep by hand args
    eval curl "${curl_args[@]}" || echo "unable to discord notify"
  }
