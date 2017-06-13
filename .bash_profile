function home_profile {
  local shome="$(cd -P -- "${BASH_SOURCE%/*}" && pwd -P)"

  set +f
  for a in $shome/.env.d/*; do
    if [[ ! -f "$a" ]]; then break; fi
    local name="${a##*/}"
    export "$(printf '%s' "$name")"="$(printf '%q' "$(cat "$a")")"
  done

  source "$shome/.bashrc"
}

home_profile
