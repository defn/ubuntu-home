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
  export BOARD_PATH="${shome}"
  export CALLING_PATH="${CALLING_PATH:-"$PATH"}"
  export PATH="${CALLING_PATH}"

  if ! bashrc; then
    echo WARNING: "Something's wrong with .bashrc"
  fi
}

function bashrc_main {
  local shome="$(cd -P -- "$(dirname "${BASH_SOURCE}")" && pwd -P)"

  umask 0022
  home_bashrc

  if [[ "$#" -gt 1  && "$1" == "" ]]; then
    shift
    for __a in "$@"; do pushd "$__a" >/dev/null && { require; popd >/dev/null; }; done
  fi

  if type -P vg >/dev/null; then
    eval "$(vg eval --shell bash)"
  fi

  set +f

  if [[ -n "${TMUX:-}" ]]; then
    export SSH_AUTH_SOCK="${BOARD_PATH}/.ssh/ssh_auth_sock"
  fi

  if [[ -d "$shome/org/bin" ]]; then
    PATH="$PATH:$shome/org/bin"
  fi
}

bashrc_main "$@"
