#!/usr/bin/env bash

set -euo pipefail

setup_env() {
  mkdir -p $HOME/.dev-common
  echo '[ -s "$HOME/.bashrc" ] && . "$HOME/.bashrc"' >> "$HOME/.bash_profile"

  echo >> "$HOME/.bashrc" <<'eof'
export DEV_COMMON="/home/$HOME/dev-common"
export PATH="$DEV_COMMON/bin:$PATH"
source $DEV_COMMON/aliases.bashrc
eof
}

setup_env
