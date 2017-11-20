#!/usr/bin/env bash

set -exfu
umask 0022

function main {
  cd "$HOME"
  source .bash_profile

  env
  pwd
  id -a

  set -x
  block bootstrap
  block stale
  pkg update list
}

if [[ "$(id -u -n)" == "root" ]]; then
  ssh -A -o BatchMode=yes -o StrictHostKeyChecking=no ubuntu@localhost "$0"
else
  main "$@"
fi
