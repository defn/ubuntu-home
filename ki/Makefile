all:
	touch ../.ssh/authorized_keys
	$(MAKE) keys
	
keys: .ssh/authorized_keys .kitchen/docker_id_rsa.pub

.ssh/authorized_keys: ../.ssh/authorized_keys
	mkdir -p .ssh
	rsync -ia $< $@

.kitchen/docker_id_rsa:
	mkdir -p .kitchen
	ssh-keygen -f .kitchen/docker_id_rsa -N ""

.kitchen/docker_id_rsa.pub: ../.ssh/authorized_keys .kitchen/docker_id_rsa
	head -1 $< > $@

docker:
	$(MAKE)
	ki reset docker-ubuntu

virtualbox:
	ki reset virtualbox-ubuntu

virtualbox-docker:
	ki exec virtualbox-ubuntu -c 'ssh -A -o StrictHostKeyChecking=no ubuntu@localhost ki in reset docker-ubuntu'
