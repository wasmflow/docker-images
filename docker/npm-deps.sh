#!/usr/bin/env bash

set -euo pipefail

install_npm_deps() {
  npm install -g apex-template prettier ts-node
}

setup_rcfiles() {
  source $HOME/.nvm/nvm.sh
}

setup_rcfiles

install_npm_deps
