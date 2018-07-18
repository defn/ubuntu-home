function bash_main {
  local shome="$(cd -P -- "${BASH_SOURCE%/*}" 2>/dev/null  && pwd -P)"
  if [[ -z "$shome" ]]; then
    shome="$HOME"
  fi

  unset BUNDLER_ORIG_BUNDLE_GEMFILE GEM_HOME BUNDLE_GEMFILE RUBYOPT GEM_HOME 

  source "$shome/.bashrc"

  set +f
}

bash_main
