#!/usr/bin/env plk

(ns defn.hello)

(defn -main [name]
  (println (str "Hello " name "!")))

(set! *main-cli-fn* -main)
