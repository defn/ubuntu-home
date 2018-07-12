#!/usr/bin/env lumo

(ns defn.hello)

(require '["aws-sdk" :as aws])

(defn -main [name]
  (println (str "Hello " name "!")))

(set! *main-cli-fn* -main)
