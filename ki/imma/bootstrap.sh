#!/usr/bin/env bash

set -exfu
umask 0022

function main {
  cd "$HOME"
  source .bash_profile

  sudo chgrp docker /var/run/docker.sock

  ssh -o StrictHostKeyChecking=no git@github.com true 2>/dev/null || true

  bl sync
  bl bootstrap
}

main "$@"
