#!/usr/bin/env bb

(ns setup-rewrite
  "Setup L3af's configuration"
  (:require [clojure.tools.cli :refer [parse-opts]]
            [clojure.string :as str]
            [helper :as h]))

;; CLI Options
(def cli-options
  [["-h" "--help" "display this menu"]
   ["-r" "--restore" "enable installed modules"]
   ["-q" "--quick-install" "start install without prompt"]])

(def opts
  (parse-opts *command-line-args* cli-options))

(def args
  (:options opts))

(defn print-help []
  (println "L3af's Lithp Configuration Manager")
  (println)
  (println "USAGE")
  (println "  bb setup.clj [OPTIONS]")
  (println)
  (println "OPTIONS")
  (println (:summary opts))
  (println))

;; Modules
(defn update-module [module input-value]
  (let [enabled (:enabled module)]
    (if (= (str/lower-case (:name (:module module))) 
           (str/lower-case input-value))
      (not enabled)
      enabled)))

;; Interactive Toggle Modules
(defn get-input [modules]
  (print "    > ")
  (flush)
  (let [input-value (read-line)]
    {:continue? (not= input-value "")
     :modules (map #(update % :enabled (fn [_] (update-module % input-value))) modules)}))

(defn install-modules [modules]
  (let [filtered (filter #(:enabled %) modules)]
    (doseq [module filtered]
      (let [module  (:module module)
            name    (:name module)
            install (:install module)]
        (println "Installing" name)
        (let [res  (install)
              code (first res)
              msg  (second res)]
          (if (not= 0 code)
            (do
              (println "Error installing configuration.")
              (println "  Response code:" code)
              (println "  Reason:" msg))
            (println "Successfully installed" name)))))
    (when (= 0 (count filtered))
      (println "No modules selected."))))

(defn update-options [modules]
  (println)
  (doseq [module modules]
    (let [name (-> module
                   (:module)
                   (:name))
          enabled (if (:enabled module) "true" "false")]
      (println (format " - %s: %s" name enabled))))

  (let [result (get-input modules)]
    (if (:continue? result)
      (update-options (:modules result))
      (install-modules (:modules result))))
  
  nil)      

(defn start [modules]
  (println)
  (println "     L3af's 100% Lithp Configuration")
  (println)
  (println "             Enabled modules:")
  (println " Enter a module name to toggle it on or off")
  (println "     Leave the value blank to continue")
  (update-options modules))

(let [modules (h/get-modules (:restore args))]
  (if (not= nil (:quick-install args))
    (install-modules modules)
    (start modules)))
