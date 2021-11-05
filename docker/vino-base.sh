#!/usr/bin/env bash

set -euo pipefail

install_rust_deps() {
  rustup component add rustfmt clippy
  rustup target add wasm32-unknown-unknown wasm32-wasi
  cargo install tomlq cargo-deny
  cargo install --git https://github.com/vinodotdev/cross.git --branch darwin
}

install_node_deps() {
  nvm install 16

  npm install -g @vinodotdev/codegen@2.0.0
}

setup_rcfiles() {
  echo '[ -s "$HOME/.bashrc" ] && . "$HOME/.bashrc"' >> "$HOME/.bash_profile"

  echo 'PATH=/usr/local/cargo/bin:$PATH' >> "$HOME/.bashrc"
  echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME/.bashrc"
  echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$HOME/.bashrc"
  echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> "$HOME/.bashrc"

  source $HOME/.nvm/nvm.sh
}

setup_rcfiles

install_node_deps

install_rust_deps

rm -rf $CARGO_HOME/git $CARGO_HOME/registry