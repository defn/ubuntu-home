function source_blocks {
  if [[ -f "$shome/work/block/script/profile" ]]; then
    source "$shome/work/block/script/profile" "$shome"
    if block gen profile > $shome/.bashrc.cache.$$; then
      mv $shome/.bashrc.cache.$$ $shome/.bashrc.cache
    fi
  fi
}

function source_cache {
  source "$shome/.bashrc.cache"
  _profile
}

function bashrc {
  if [[ -f "$shome/.bashrc.cache" ]]; then
    if ! source_cache; then
      source_blocks
    fi
  else
    source_blocks
  fi
}

function home_bashrc {
  local shome="$(cd -P -- "$(dirname "${BASH_SOURCE}")" && pwd -P)"

  PATH="$(echo $PATH | tr ':' '\n' | uniq | grep -v "$shome" | grep -v "${PKG_HOME:-"$shome"}" | perl -ne 'm{^\s*$} && next; s{\s*$}{:}; print')"
  if [[ "$(type -t require)" != "function" ]]; then
    if ! bashrc; then
      echo WARNING: "Something's wrong with .bashrc"
    fi
  fi
}

home_bashrc
