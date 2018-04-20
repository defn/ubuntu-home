#!/usr/bin/env bash

set -efu

nm_program="${BASH_SOURCE##*/}"
nm_program="${nm_program%-entrypoint.sh}"

if [[ "${1:0:1}" = '-' ]]; then
  set -- "$nm_program" "$@"
fi

exec "$@"
