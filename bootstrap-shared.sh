#!/usr/bin/env bash

set -exfu
umask 0022

function main {
  local loader='sudo env DEBIAN_FRONTEND=noninteractive'
  local nm_branch="v20170617"
  local nm_remote="gh"
  local url_remote="https://github.com/imma/ubuntu"

  export DATA="/data"

  ssh -o StrictHostKeyChecking=no git@github.com true 2>/dev/null || true

  if [[ ! -d .git || -f .bootstrapping ]]; then
    touch .bootstrapping
    ssh -o StrictHostKeyChecking=no git@github.com true 2>/dev/null || true

    tar xvfz ${DATA}/cache/git/ubuntu-v20170616.tar.gz
    git reset --hard
    rsync -ia .gitconfig.template .gitconfig

    git remote add "${nm_remote}" "${url_remote}" 2>/dev/null || true
    git remote set-url "${nm_remote}" "${url_remote}"
    rm -f .ssh/config
    git fetch "${nm_remote}"
    git branch -D "${nm_remote}/$nm_branch" || true
    git branch --set-upstream-to "${nm_remote}/$nm_branch"
    git reset --hard "${nm_remote}/${nm_branch}"
    git checkout "${nm_branch}" 
    git submodule update --init || git submodule foreach 'git reset --hard; git clean -ffd'
    git submodule update --init

    $loader apt-get install -y awscli
    $loader dpkg --configure -a
    $loader apt-get update
    $loader apt-get install -y make python build-essential aptitude
    $loader aptitude hold grub-legacy-ec2 docker-ce lxd
    $loader apt-get upgrade -y

    rm -f .bootstrapping
  fi

  work/base/script/bootstrap
  work/jq/script/bootstrap
  work/block/script/cibuild

  set +x
  source work/block/script/profile ~
  set -x

  make cache

  set +x
  require
  set -x

  git reset --hard
  chmod 700 .gnupg
  chmod 600 .ssh/config

  git fetch
  git reset --hard
  git clean -ffd
  block sync
  block bootstrap
  sync
}

case "$(id -u -n)" in
  root)
    umask 022

    cat > /etc/sudoers.d/90-cloud-init-users <<____EOF
    # Created by cloud-init v. 0.7.9 on Fri, 21 Jul 2017 08:42:58 +0000
    # User rules for ubuntu
    ubuntu ALL=(ALL) NOPASSWD:ALL
    vagrant ALL=(ALL) NOPASSWD:ALL
____EOF

    found_vagrant=
    if [[ "$(id -u vagrant 2>/dev/null)" == "1000" ]]; then
      userdel -f vagrant || true
      found_vagrant=1
    fi

    if ! id -u -n ubuntu; then
      useradd -m -s /bin/bash ubuntu
    fi

    if ! [[ -d ~ubuntu/.git ]]; then
      rsync -ia /tmp/home/.git/. ~ubuntu/.git2/
      chown -R ubuntu:ubuntu ~ubuntu
    fi

    mkdir -p ~ubuntu/.ssh
    rsync -ia /tmp/home/.ssh/authorized_keys ~ubuntu/.ssh/
    chown -R ubuntu:ubuntu ~ubuntu/.ssh
    install -d -o ubuntu -g ubuntu /data /data/cache /data/git

    if [[ -n "$found_vagrant" ]]; then
      useradd -s /bin/bash vagrant || true
      chown -R vagrant:vagrant ~vagrant /tmp/kitchen
    fi

    ssh -A -o BatchMode=yes -o StrictHostKeyChecking=no ubuntu@localhost "$0"
    ;;
  *)
    main "$@"
    ;;
esac
