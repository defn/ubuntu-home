function envrc {
  set +f
  for a in $shome/.env.d/*; do
  	set -f
    if [[ ! -f "$a" ]]; then break; fi
    local name="${a##*/}"
    export "$name"="$(cat "$a")"
  done
}

function bashrc {
	envrc

  source "$shome/script/rc"

  if [[ -f "$shome/.bashrc.cache" ]]; then
    source "$shome/.bashrc.cache"
    _profile
  fi

	envrc
}

function home_bashrc {
  local shome="$(cd -P -- "$(dirname "${BASH_SOURCE}")" && pwd -P)"

  export BOARD_PATH="${shome}"
  export CALLING_PATH="${CALLING_PATH:-"$PATH"}"
  export PATH="${CALLING_PATH}"

  if ! bashrc; then
    echo WARNING: "Something's wrong with .bashrc"
  fi
}

function bashrc_main {
  umask 0022
  home_bashrc

  if [[ "$#" -gt 1  && "$1" == "" ]]; then
    shift
    for __a in "$@"; do pushd "$__a" >/dev/null && { require; popd >/dev/null; }; done
  fi

  set +f
}

bashrc_main "$@"

if [[ "${TERM:-}" == "screen" ]]; then
  export TERM="screen-256color"
fi

if [[ -n "${TMUX:-}" ]]; then
  if [[ -S "${BOARD_PATH}/.ssh/ssh_auth_sock" ]]; then
    export SSH_AUTH_SOCK="${BOARD_PATH}/.ssh/ssh_auth_sock"
  fi
fi

