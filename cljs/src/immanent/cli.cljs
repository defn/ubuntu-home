(ns immanent.cli)

(defn square [x]
  (* x x))

(defn -main [& args]
  (-> args first js/parseInt square prn))

(set! *main-cli-fn* -main)
