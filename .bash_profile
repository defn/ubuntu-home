function bash_main {
  local shome="$(cd -P -- "${BASH_SOURCE%/*}" 2>/dev/null  && pwd -P)"
  if [[ -z "$shome" ]]; then
    shome="$HOME"
  fi

  set +f
  for a in $shome/.env.d/*; do
    if [[ ! -f "$a" ]]; then break; fi
    local name="${a##*/}"
    export "$name"="$(cat "$a")"
  done

  source "$shome/script/rc"
  source "$shome/.bashrc"
}

bash_main
