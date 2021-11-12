#!/usr/bin/env bash

set -euo pipefail

install_node_deps() {
  nvm install $NODE_VERSION
}

setup_rcfiles() {
  echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME/.bashrc"
  echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$HOME/.bashrc"
  echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> "$HOME/.bashrc"

  source $HOME/.nvm/nvm.sh
}

setup_rcfiles

install_node_deps
