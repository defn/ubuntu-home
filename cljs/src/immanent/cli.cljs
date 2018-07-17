(ns immanent.cli)

(def aws (js/require "aws-sdk"))

(defn -main [& args]
  (.listBuckets (new aws.S3 {:apiVersion "2006-03-01"}) (fn [err data] (prn data))))

(set! *main-cli-fn* -main)
