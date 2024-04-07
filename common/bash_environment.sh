#!/bin/bash

# exit code list: https://ioflood.com/blog/bash-exit-codes/
# BASH_EXIT_SUCCESS=0
BASH_EXIT_ERROR=1
# BASH_EXIT_COMMAND_MIS_USAGE=2
# BASH_EXIT_COMMAND_CANNOT_EXECUTE=126
# BASH_EXIT_COMMAND_NOT_FOUND=127


load_local_dot_env_file() {
  DEFAULT_LOCAL_DOT_ENV="./env"
  LOCAL_DOT_ENV=${1:-${DEFAULT_LOCAL_DOT_ENV}}
  if [ ! -f "${LOCAL_DOT_ENV}" ]; then
    echo "$LOCAL_DOT_ENV does not exist."
    exit ${BASH_EXIT_ERROR};
  fi
  # shellcheck disable=SC1090 # this file is already analysed and source didnt work
  source "${LOCAL_DOT_ENV}" set
  # echo "${LOCAL_DOT_ENV} loaded";
}

expect_variable_to_be_set() {
  var_name=$1
  # echo "expect ${var_name}"
  if [ -z "${!var_name}" ]; then
    echo "expect environment variable ${var_name} to be set"
    exit ${BASH_EXIT_ERROR};
  # else
  #   echo "variable ${var_name} is set to ${!var_name}"
  fi
}