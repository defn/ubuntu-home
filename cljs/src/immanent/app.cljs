(ns immanent.app
  (:require [reagent.core :as r]))

(defonce click-count (r/atom 0))

(defn state-ful-with-atom []
  [:div {:on-click #(swap! click-count inc)}
   "I have been clicked " @click-count " times."])

(defn -main []
  (r/render [state-ful-with-atom]
            (.-body js/document)))

(enable-console-print!)
