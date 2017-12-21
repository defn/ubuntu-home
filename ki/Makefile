all:
	touch ../.ssh/authorized_keys
	$(MAKE) keys
	
keys: .ssh/authorized_keys .kitchen/docker_id_rsa.pub

.ssh/authorized_keys: ../.ssh/authorized_keys
	rsync -ia $< $@

.kitchen/docker_id_rsa:
	mkdir -p .kitchen
	ssh-keygen -f .kitchen/docker_id_rsa -N ""

.kitchen/docker_id_rsa.pub: .kitchen/docker_id_rsa ../.ssh/authorized_keys
	head -1 $< > $@
