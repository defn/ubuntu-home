app:
	clojure/bin/clojure -m figwheel.main -b dev -ro '{:launch-browser false}' -r

pc:
	cclojure/bin/clojure -m figwheel.main -pc -ro '{:launch-browser false}'

install:
	curl -O https://download.clojure.org/install/linux-install-1.9.0.381.sh
	chmod +x linux-install-1.9.0.381.sh
	./linux-install-1.9.0.381.sh -p clojure
	rm -f linux-install-1.9.0.381.sh

