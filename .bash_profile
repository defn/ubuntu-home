function bash_main {
  local shome="$(cd -P -- "${BASH_SOURCE%/*}" 2>/dev/null  && pwd -P)"
  if [[ -z "$shome" ]]; then
    shome="$HOME"
  fi

	if [[ -z "${TMUX:-}" ]]; then
		if [[ -S "$SSH_AUTH_SOCK" ]]; then
			ln -nfs $SSH_AUTH_SOCK "$shome/.ssh/ssh_auth_sock"
		fi
  fi

  source "$shome/.bashrc"

  set +f
}

bash_main
