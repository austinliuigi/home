autoload -Uz add-zsh-hook


# ===================================================================
# AUTOMATICALLY ACTIVATE/DEACTIVATE PYTHON VIRTUAL ENVIRONMENTS
# - NOTE: We track the current venv directory ourselves instead of using
#         $VIRTUAL_ENV because the latter can be outdated if the directory
#         is renamed after tha venv is created.
# ===================================================================
VENV_DIR=".venv"
CURRENT_VENV_BASEDIR=""
auto_venv_hook() {
    if [[ -n $DISABLE_AUTO_VENV ]]; then
        return
    fi

    # deactivate if in venv that is not a parent
    if [[ -n "$CURRENT_VENV_BASEDIR" && (! "$PWD" =~ "$CURRENT_VENV_BASEDIR") ]]; then
        deactivate
        CURRENT_VENV_BASEDIR=""

    # activate if any parents have a venv
    elif [[ -z "$CURRENT_VENV_BASEDIR" ]]; then
      local dir="$PWD"
      while [[ "$dir" =~ "^$HOME" ]]; do
        # echo "$dir"
        if [[ -f "$dir/$VENV_DIR/bin/activate" ]]; then
          source "$dir/$VENV_DIR/bin/activate"
          CURRENT_VENV_BASEDIR="$dir"
          break
        fi
        dir="$(dirname $dir)"
      done
    fi
}

add-zsh-hook chpwd auto_venv_hook
auto_venv_hook
