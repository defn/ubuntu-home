#!/usr/bin/env bash

set -efu

nm_program="${BASH_SOURCE##*/}"
nm_program="${nm_program%-entrypoint.sh}"

if [[ "${1:0:1}" = '-' ]]; then
  set -- "$nm_program" "$@"
fi

if [[ "$1" = "$nm_program" ]] && [[ "$(id -u)" = '0' ]]; then
  exec gosu ubuntu "$BASH_SOURCE" "$@"
fi

if [[ "$1" = "$nm_program" ]]; then
  true
fi

exec "$@"
