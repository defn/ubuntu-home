function bash_main {
  local shome="$(cd -P -- "${BASH_SOURCE%/*}" 2>/dev/null  && pwd -P)"
  if [[ -z "$shome" ]]; then
    shome="$HOME"
  fi

  unset BUNDLER_ORIG_BUNDLE_GEMFILE GEM_HOME BUNDLE_GEMFILE RUBYOPT

  source "$shome/.bashrc"

  if [[ -z "${TMUX:-}" ]]; then
    case "${CUE_SCHEME:-}" in
      slight|sdark)
        "${CUE_SCHEME}"
        ;;
    esac
  fi

  set +f
}

bash_main
