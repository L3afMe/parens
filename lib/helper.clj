(ns helper
  (:require [clojure.java.io :as io]
            [babashka.process :as p])
  (:import [java.lang ProcessBuilder$Redirect]))

(defmacro cur-dir []
  (-> *file*
      (io/file)
      (.getParent)))

(defn config-dir []
  (let [home       (System/getenv "HOME")
        xdg-config (System/getenv "XDG_CONFIG_HOME")]
    (or xdg-config
        (str home "/.config"))))

(defn filter-modules [file]
  (let [setup-file (io/file file "setup.clj")]
    (and (.exists setup-file)
         (.isFile setup-file))))

(defn map-module [file]
  (let [name (.getName file)
        path (format "modules/%s/setup.clj" name)]
    {:enabled false 
     :module (load-file path)}))

(defn restore [module restore?]
  (if restore?
    (let [data    (:module module)
          status  ((:status data))
          enabled (not= nil status)]
      (update module :enabled (fn [_] enabled)))
    module))

(defn get-modules [restore?]
  (let [file (io/file (cur-dir) "../modules")
        children (.listFiles file)]
    (->> children
         (filter filter-modules)
         (map map-module)
         (map #(restore % restore?)))))

(defn execute-cmd [dir args]
  (let [proc (-> (ProcessBuilder. ^java.util.List args)
                 (.redirectInput ProcessBuilder$Redirect/INHERIT)
                 (.redirectError ProcessBuilder$Redirect/INHERIT)
                 (.directory (io/file (cur-dir) dir))
                 (.start))

        string-out (let [sw (java.io.StringWriter.)]
                     (with-open [w (io/reader (.getInputStream proc))]
                       (io/copy w sw))
                     (str sw))
        exit-code (.waitFor proc)]
    (when-not (zero? exit-code)
      (println "Command exited with non zero error code:" exit-code)
      (System/exit exit-code))
    string-out))

