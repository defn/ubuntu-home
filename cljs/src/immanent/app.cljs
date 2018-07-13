(ns immanent.app)

(enable-console-print!)

(defn -main []
  (new js/Vue (clj->js { :el "#app" :data { :message "Hello Vue!" } })))
