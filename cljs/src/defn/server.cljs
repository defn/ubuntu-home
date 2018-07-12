#!/usr/bin/env lumo

(ns defn.server)

(require '["aws-sdk" :as aws])
(require '["express" :as express])
(require '["http" :as http])

(def app (express))

(. app (get "/hello"
  (fn [req res] (. res (send "Hello defn")))))

(defn -main [& args]
  (doto (.createServer http #(app %1 %2))
    (.listen 3000)))

(set! *main-cli-fn* -main)
