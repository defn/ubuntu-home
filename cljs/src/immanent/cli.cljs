(ns immanent.cli
  (:require [cljs.pprint :as pp]))

(def aws (js/require "aws-sdk"))
(def express (js/require "express"))

(defonce buckets {})

(defonce app (express))

(defn -main [& args]
  (.get app "/" (fn [req res] (.send res (str buckets))))
  (.listen app 3000 (fn [] (prn "listening on port 3000")))
  (.listBuckets (new aws.S3 {:apiVersion "2006-03-01"}) (fn [err data] (set! buckets (js->clj data)))))

(set! *main-cli-fn* -main)
