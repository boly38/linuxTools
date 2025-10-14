#!/bin/bash

log_info() {
  echo -e "[\\e[1;94mINFO\\e[0m] $*"
}

log_warn() {
  echo -e "[\\e[1;93mWARN\\e[0m] $*"
}

log_error() {
  echo -e "[\\e[1;91mERROR\\e[0m] $*"
}

check_not_used_host_port_with_warn_message() {
  HOST=$1
  PORT=$2
  MESSAGE=$3
  if nc -vz "${HOST}" "$PORT" >/dev/null 2>&1 ; then
      log_error "${HOST} ${PORT} : ${MESSAGE}"
      exit 1
  fi
}

check_no_git_diff() {
  MESSAGE=$1
  if ! git diff --quiet ;then
    log_warn "$MESSAGE"
  fi
}