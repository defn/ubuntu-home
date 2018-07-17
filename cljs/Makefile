app: clojure/bin/clojure
	clojure/bin/clojure -m figwheel.main -b dev -r

cli: clojure/bin/clj
	@clojure/bin/clj -m cljs.main -re node -m immanent.cli 5

compile: immanent.js
	@node immanent.js 5

recompile:
	rm -f immanent.js
	$(MAKE) compile

immanent.js: src/immanent/cli.cljs
	clojure/bin/clj -m cljs.main -t node -O simple -o immanent.js -c immanent.cli

pc: clojure/bin/clojure
	clojure/bin/clojure -m figwheel.main -pc

clojure/bin/clojure:
	curl -O https://download.clojure.org/install/linux-install-1.9.0.381.sh
	chmod +x linux-install-1.9.0.381.sh
	./linux-install-1.9.0.381.sh -p clojure
	rm -f linux-install-1.9.0.381.sh

