menu:
	@echo
	@echo "make app:   browser http://localhost:9500 + repl"
	@echo "make serve: browser http://localhost:8080"
	@echo "make cli:   script + repl"
	@echo "make run:   script"
	@echo

app: clojure/bin/clojure
	@clojure/bin/clojure -m figwheel.main -e '(ns immanent.app)' -b dev -r

public/main.js: src/immanent/app.cljs clojure/bin/clojure
	@clojure/bin/clojure -m cljs.main -O advanced -o public/main.js -c immanent.app

cli: clojure/bin/clojure
	@clojure/bin/clojure -m figwheel.main -t node -e '(ns immanent.cli)' -b cli --repl

run: immanent.js
	@node immanent.js

immanent.js: src/immanent/cli.cljs clojure/bin/clojure
	@clojure/bin/clojure -m cljs.main -t node -O none -o immanent.js -c immanent.cli

serve: public/main.js
	yarn http-server -a 127.0.0.1 --gzip public

clojure/bin/clojure:
	curl -O https://download.clojure.org/install/linux-install-1.9.0.381.sh
	chmod +x linux-install-1.9.0.381.sh
	./linux-install-1.9.0.381.sh -p clojure
	rm -f linux-install-1.9.0.381.sh
	yarn install
