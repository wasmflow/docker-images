#!/usr/bin/env bash

set -euo pipefail

install_deps() {
    get_docker_key

    local dependencies=(
      lld
      docker-ce
      docker-ce-cli
      containerd.io
    )

    apt-get update
    for dep in "${dependencies[@]}"; do
        if ! dpkg -L "${dep}" >/dev/null 2>/dev/null; then
            apt-get install -qq --assume-yes --no-install-recommends "${dep}"
        fi
    done

    local purge_list=(
      curl
      imagemagick
    )

    apt-get update
    if (( ${#purge_list[@]} )); then
      apt-get purge --assume-yes --auto-remove "${purge_list[@]}"
    fi
}

get_docker_key() {
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  source /etc/os-release

  echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/debian \
  $VERSION_CODENAME stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
}

setup_rcfiles() {
  echo '[ -s "$HOME/.bashrc" ] && . "$HOME/.bashrc"' >> "$HOME/.bash_profile"
}

install_deps

setup_rcfiles

rm -rf /var/lib/apt/lists/*