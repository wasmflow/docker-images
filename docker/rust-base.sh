#!/usr/bin/env bash

set -euo pipefail

install_rust_deps() {
  rustup component add rustfmt clippy
  rustup target add wasm32-unknown-unknown wasm32-wasi
  cargo install tomlq cargo-deny
  cargo install --git https://github.com/vinodotdev/cross.git --branch darwin
}

setup_rcfiles() {
  echo 'PATH=/usr/local/cargo/bin:$PATH' >> "$HOME/.bashrc"
}

setup_rcfiles

install_rust_deps

rm -rf $CARGO_HOME/git $CARGO_HOME/registry