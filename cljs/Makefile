app: clojure/bin/clojure
	clojure/bin/clojure -m figwheel.main -b dev -r

cli: clojure/bin/clj
	@clojure/bin/clojure -m figwheel.main -t node -e '(ns immanent.cli)' -b cli --repl

run: immanent.js
	@node immanent.js

immanent.js: src/immanent/cli.cljs clojure/bin/clojure
	clojure/bin/clojure -m cljs.main -t node -O none -o immanent.js -c immanent.cli

clojure/bin/clojure:
	curl -O https://download.clojure.org/install/linux-install-1.9.0.381.sh
	chmod +x linux-install-1.9.0.381.sh
	./linux-install-1.9.0.381.sh -p clojure
	rm -f linux-install-1.9.0.381.sh
	yarn install
