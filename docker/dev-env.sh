#!/usr/bin/env bash

set -euo pipefail

setup_env() {
  echo '[ -s "$HOME/.bashrc" ] && . "$HOME/.bashrc"' >> "$HOME/.bash_profile"

  cat <<-'eof' >> "$HOME/.bashrc"
export DEV_COMMON="/home/$HOME/dev-common"
export PATH="$DEV_COMMON/bin:$PATH"

eof

  ln -s ~/dev-common/.bash_aliases ~/
}

setup_env
