#!/usr/bin/env bash

set -euo pipefail

install_rust_deps() {
  rustup component add rustfmt clippy
  rustup target add wasm32-unknown-unknown wasm32-wasi
  cargo install tomlq cargo-deny
  cargo install --git https://github.com/vinodotdev/cross.git --branch darwin
}

install_node_deps() {
  echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME/.bashrc"
  echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$HOME/.bashrc"
  echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> "$HOME/.bashrc"


  source $HOME/.nvm/nvm.sh
  nvm install 16
  npm install -g @vinodotdev/codegen@2.0.0
}

install_node_deps

install_rust_deps

rm -rf $CARGO_HOME/git $CARGO_HOME/registry