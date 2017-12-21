all:
	touch ../.ssh/authorized_keys
	$(MAKE) keys
	
keys: .ssh/authorized_keys .kitchen/docker_id_rsa.pub

.ssh/authorized_keys: ../.ssh/authorized_keys
	rsync -ia $< $@

.kitchen/docker_id_rsa.pub: ../.ssh/authorized_keys
	mkdir -p .kitchen
	head -1 $< > $@
