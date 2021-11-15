#!/usr/bin/env bash

set -euo pipefail

install_npm_deps() {
  npm install -g @vinodotdev/codegen
  # git clone -b dev https://github.com/vinodotdev/codegen.git
  # cd codegen && npm install && npm run build && rm -rf node_modules && NODE_ENV=production npm install && npm install -g .
}

setup_rcfiles() {
  source $HOME/.nvm/nvm.sh
}

setup_rcfiles

install_npm_deps
