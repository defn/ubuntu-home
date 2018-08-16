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
}

function bashrc3 {
  local shome="$(cd -P -- "$(dirname "${BASH_SOURCE}")" && pwd -P)"

  umask 0022
  export BOARD_PATH="${shome}"
  export CALLING_PATH="${CALLING_PATH:-"$PATH"}"
  export PATH="${CALLING_PATH}"

  if ! bashrc; then
    echo WARNING: "Something's wrong with .bashrc"
  fi

  if [[ "$#" -gt 1  && "$1" == "" ]]; then
    shift
    for __a in "$@"; do pushd "$__a" >/dev/null && { require; popd >/dev/null; }; done
  fi

  set +f

  if [[ -n "${TMUX:-}" ]]; then
    export SSH_AUTH_SOCK="${BOARD_PATH}/.ssh/ssh_auth_sock"
  fi

  if [[ -d "$shome/org/bin" ]]; then
    PATH="$PATH:$shome/org/bin"
  fi

  case "${CUE_SCHEME:-}" in
    sdark|slight)
      "${CUE_SCHEME}"
      ;;
  esac
}

bashrc3 "$@"
