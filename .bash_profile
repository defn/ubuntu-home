function home_profile {
  local shome="$(cd -P -- "${BASH_SOURCE%/*}" && pwd -P)"

  local check_ssh_agent=1

  if ssh-add -l >/dev/null 2>&1; then
    check_ssh_agent=
  else
    case "$?" in
      1)
        check_ssh_agent=1
        ;;
    esac
  fi

  if [[ -n "$check_ssh_agent" && -f "$shome/.ssh-agent" ]]; then
    source "$shome/.ssh-agent" >/dev/null
  fi

  source "$shome/.bashrc"
}

home_profile
