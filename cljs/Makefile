server:
	clj -m cljs.main -re node -m defn.server

app:
	clj -m cljs.main -re node -m defn.app $(USER)

test:
	http :3000/hello

install:
	yarn install
