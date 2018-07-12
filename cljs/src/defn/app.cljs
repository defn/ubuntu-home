#!/usr/bin/env plk

(ns defn.app)

(require '["vue" :as vue])

(defn -main [name]
  (println (str "Hello " name "!" vue)))

(set! *main-cli-fn* -main)
