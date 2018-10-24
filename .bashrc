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

  case "$(uname -s)" in
    Linux)
      PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      source ~/work/site/script/profile.linux
      ;;
    Darwin)
      if [[ -f "$shome/.bashrc.cache" ]]; then
        source "$shome/.bashrc.cache"
        _profile
      fi
      ;;
  esac

  PATH="$HOME/.cargo/bin:$PATH"
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
    if [[ -S "${BOARD_PATH}/.ssh/ssh_auth_sock" ]]; then
      export SSH_AUTH_SOCK="${BOARD_PATH}/.ssh/ssh_auth_sock"
    fi
  fi

  if [[ -d "$shome/org/bin" ]]; then
    PATH="$PATH:$shome/org/bin"
  fi

  if [[ -z "${PROMPT_COMMAND:-}" ]]; then
    CUE_FILLER='-'
    case "${CUE_SCHEME:-}" in
      sdark|slight)
        "${CUE_SCHEME}"
        ;;
      *)
        sdark
        ;;
    esac
    source cue_prompt
  fi
}

bashrc3 "$@"
