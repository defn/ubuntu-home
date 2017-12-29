docker:
	$(MAKE)
	ki reset docker-ubuntu

virtualbox:
	ki reset virtualbox-ubuntu

virtualbox-docker:
	ki exec virtualbox-ubuntu -c 'ssh -A -o StrictHostKeyChecking=no ubuntu@localhost ki reset docker-ubuntu'
