#!/bin/bash
## load common
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR="${SCRIPT_DIR}/../.."
# shellcheck disable=SC1091 # this file is already analysed and source didnt work
source "${ROOT_DIR}/common/bash_environment.sh"
## load common end

###### ipinfo.sh - https://ipinfo.io/developers
load_local_dot_env_file "${ROOT_DIR}/.env"
expect_variable_to_be_set "IPINFO_TOKEN"

# accept IPADDRESS as env var, or else as first command argument
IPADDRESS=${IPADDRESS:-$1}
expect_variable_to_be_set "IPADDRESS"

if [ "${IPADDRESS}" = "me" ]; then
  echo "curl -u \"xxx:\" ipinfo.io"
  curl -u "${IPINFO_TOKEN}:" ipinfo.io
else
  echo "curl ipinfo.io/${IPADDRESS}?token=xxx"
  curl "ipinfo.io/${IPADDRESS}?token=${IPINFO_TOKEN}"
fi