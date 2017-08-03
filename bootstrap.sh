#!/usr/bin/env bash

set -exfu
umask 0022

function main {
  if ! test -d .git; then
    ssh -o StrictHostKeyChecking=no git@github.com true 2>/dev/null || true
  fi

  local loader='sudo env DEBIAN_FRONTEND=noninteractive'
  local nm_branch="v20170617"
  local nm_remote="gh"
  local url_remote="https://github.com/imma/ubuntu"

  git reset --hard
  rsync -ia .gitconfig.template .gitconfig

  git remote add "${nm_remote}" "${url_remote}" 2>/dev/null || true
  git remote set-url "${nm_remote}" "${url_remote}"
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

  work/base/script/bootstrap
  work/jq/script/bootstrap
  work/block/script/cibuild
  source work/block/script/profile ~
  make cache
  require

  chmod 700 .gnupg
  chmod 600 .ssh/config

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
____EOF

    if ! id -u -n ubuntu; then
      useradd -m -s /bin/bash ubuntu
    fi

    if ! [[ -d ~ubuntu/.git ]]; then
      rsync -ia /tmp/home/.git/. ~ubuntu/.git/
      chown -R ubuntu:ubuntu ~ubuntu
    fi

    mkdir -p ~ubuntu/.ssh
    rsync -ia /tmp/home/.ssh/authorized_keys ~ubuntu/.ssh/
    chown -R ubuntu:ubuntu ~ubuntu/.ssh

    ssh -A -o BatchMode=yes -o StrictHostKeyChecking=no ubuntu@localhost "$0"
    ;;
  *)
    main "$@"
    ;;
esac
