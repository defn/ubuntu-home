(ns immanent.cli)

(def aws (js/require "aws-sdk"))

(defn square [x]
  (* x x))

(defn -main [& args]
  (-> args first js/parseInt square prn)
  (prn aws))

(set! *main-cli-fn* -main)
