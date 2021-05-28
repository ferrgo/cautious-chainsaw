#!/bin/sh

error() {
  errorCode=$1
  shift
  printf "\e[1m\e[31m[ERROR]\033[0m\e[0m %s\n" "$@"
  exit "${errorCode:-1}"
}

log() {
  printf "\e[1m[INFO]\e[0m %s\n" "$@"
}

log_wait() {
  printf "\e[1m[WAIT] \e[0mTried %s time(s)\033[0K\r\n" "$1"
}
