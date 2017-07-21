function bashrc {
  if [[ -f "$shome/.bashrc.cache" ]]; then
    source "$shome/.bashrc.cache"
    _profile
  fi
}

function clean_path {
  echo "$PATH"
  #echo $PATH | tr ':' '\n' | uniq | grep -v "$shome" | grep -v "${PKG_HOME:-"$shome"}" | perl -ne 'm{^\s*$} && next; s{\s*$}{:}; print'
}

function home_bashrc {
  local shome="$(cd -P -- "$(dirname "${BASH_SOURCE}")" && pwd -P)"

  export BOARD_PATH="${shome}"
  export CALLING_PATH="${CALLING_PATH:-"$(clean_path)"}"

  PATH="${CALLING_PATH}"
  if [[ "$(type -t require)" != "function" ]]; then
    if ! bashrc; then
      echo WARNING: "Something's wrong with .bashrc"
    fi
  fi
}

umask 0022
home_bashrc

if [[ "$#" -gt 1  && "$1" == "" ]]; then
  shift
  for __a in "$@"; do pushd "$__a" >/dev/null && { require; popd >/dev/null; }; done
fi
