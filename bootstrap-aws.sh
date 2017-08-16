#!/usr/bin/env bash

set -exfu
umask 0022

function main {
  local loader='sudo env DEBIAN_FRONTEND=noninteractive'
  local nm_branch="v20170617"
  local nm_remote="gh"
  local url_remote="https://github.com/imma/ubuntu"

  export DATA="/mnt/data"
  if [[ ! -d /mnt/data ]]; then
    $loader apt-get install -y nfs-common
    $loader mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 efs.adm.immanent.io:/ /mnt
  fi
  $loader ln -nfs /mnt/data /data

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
    ssh -A -o BatchMode=yes -o StrictHostKeyChecking=no ubuntu@localhost "$0"
    ;;
  *)
    main "$@"
    ;;
esac
