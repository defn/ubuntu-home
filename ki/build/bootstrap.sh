#!/usr/bin/env bash

function main {
	cd

	git clone git@github.com:imma/ubuntu
	mv ubuntu/.git .
	rm -rf ubuntu
	git reset --hard

	rsync -ia .gitconfig.template .gitconfig
	rsync -ia .ssh/config.template .ssh/config
	chmod 600 .ssh/config

	git submodule update --init

	cd work/ubuntu-config/
	source script/profile

	work/base/script/bootstrap
	work/jq/script/bootstrap
	work/block/script/cibuild

	cd work/block
	require

	cd
	require

	block sync
	make cache

	cd work/pkgsrc
	script/bootstrap
} 

main "$@"
