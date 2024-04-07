#!/bin/bash
## load common
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR="${SCRIPT_DIR}/../.."
# shellcheck disable=SC1091 # this file is already analysed and source didnt work
source "${ROOT_DIR}/common/bash_environment.sh"
## load common end

load_local_dot_env_file "${ROOT_DIR}/.env"

# with env set

## import function definition
# shellcheck disable=SC1091 # this file is already analysed and source didnt work
source "${ROOT_DIR}/integration/discord/discordNotifier.sh"

## use it
discordNotification "hello, this is a strange '\"sample, an so quotes / double-quotes are removed"
echo "this is a file" > myFile
discordNotification "here is the file" ./myFile

