#!/usr/bin/env -S bb --classpath "../../lib"

(ns awesome
  (:require [helper :as h]
            [modulehelper :as mh]
            [clojure.java.io :as io]
            [clojure.string :as str]))

(def path-from-lib
  "../modules/awesome/")

(def module-dir
  (str (h/config-dir) "/awesome"))

(defn status []
  false)

(defn install []
  (mh/install-all-fnl
   {:dir (h/cur-dir)
    :pfl path-from-lib
    :mod-dir module-dir})
  ; TODO: Implement return codes (maybe)
  '(0 nil))

(defn uninstall []
  (let [out (slurp (h/cur-dir) ".cache")
        files (str/split out #"\n")]
    (dorun
      (for [file-path files]
        (let [file (io/file file-path)]
          (println "Removing " (subs file-path (count (module-dir))))
          (if (.exists file)
            (when-not (.delete file)
              (println "Error: Unable to delete file"))
            (println "Error: File doesn't exist")))))
    (println "Uninstalled Awesome config")

    (let [hash-file  (io/file (h/cur-dir) ".dir_hash")
          cache-file (io/file (h/cur-dir) ".cache")]
     (when (.isFile hash-file)
         (.delete hash-file))
     (when (.isFile cache-file)
       (.delete cache-file))))
  nil)

(mh/setup-cli
 {:name "Awesome"
  :deps ["awesome-git"]
  :status    awesome/status
  :install   awesome/install
  :uninstall awesome/uninstall})
