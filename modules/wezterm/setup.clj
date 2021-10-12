#!/usr/bin/env -S bb --classpath "../../lib"

(ns wezterm
  (:require [helper :as h]
            [modulehelper :as mh]
            [clojure.java.io :as io]
            [clojure.string :as str]))

(def path-from-lib
  "../modules/wezterm/")

(def module-dir
  (str (h/config-dir) "/wezterm"))

(defn status []
  false)

(defn install []
  (mh/install-all-fnl
   {:dir (h/cur-dir)
    :pfl path-from-lib
    :mod-dir module-dir})
  '(0 nil))

(defn uninstall []
  (let [out (slurp ".cache")
        files (str/split out #"\n")]
    (dorun
      (for [file-path files]
        (let [file (io/file file-path)]
          (println "Removing " (subs file-path (count (module-dir))))
          (if (.exists file)
            (when-not (.delete file)
              (println "Error: Unable to delete file"))
            (println "Error: File doesn't exist")))))
    (println "Uninstalled Wezterm config")

    (let [hash-file  (io/file (h/cur-dir) ".dir_hash")
          cache-file (io/file (h/cur-dir) ".cache")]
     (when (.isFile hash-file)
         (.delete hash-file))
     (when (.isFile cache-file)
       (.delete cache-file))))
  nil)

(mh/setup-cli
 {:name "Wezterm"
  :deps ["wezterm"]
  :status    wezterm/status
  :install   wezterm/install
  :uninstall wezterm/uninstall})
