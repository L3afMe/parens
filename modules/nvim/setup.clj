#!/usr/bin/env -S bb --classpath "../../lib"

(ns nvim
  (:require [helper :as h]
            [modulehelper :as mh]
            [clojure.java.io :as io]
            [clojure.string :as str]))

(def path-from-lib
  "../modules/nvim/")

(def module-dir
  (str (h/config-dir) "/nvim"))

(defn status []
  false)

(defn install-all-fnl [ctx]
  (let [fnl-files (-> ctx
                      (:dir)
                      (io/file "config")
                      (mh/find-fnl-files))
        fnl-files (map (fn [file]
                         (if (= (:lua-path file) "init.lua")
                           file
                           (update file :lua-path #(str "lua/" %))))
                       fnl-files)
        out       (map #(if (.endsWith (:fnl-path %) ".fnl")
                          (mh/install-file % ctx)
                          (mh/copy-file % ctx)) fnl-files)
        out-file  (io/file "./.cache")
        out-path  (.getAbsolutePath out-file)
        out-data  (str/join "\n" out)
        hash-file (io/file "./.dir_hash")
        hash-path (.getAbsolutePath hash-file)]

    (when (and (.isFile out-file)
               (not (.delete out-file)))
      (println "Unable to delete './.cache'"))

    (with-open [writer (io/writer out-path)]
      (.write writer out-data))

    (when (and (.isFile hash-file)
               (not (.delete hash-file)))
      (println "Unable to delete './.dir_hash'"))

    (with-open [writer (io/writer hash-path)]
      (.write writer (mh/get-hash)))))

(defn install []
  (install-all-fnl
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

    (let [hash-file  (io/file (h/cur-dir) ".dir_hash")
          cache-file (io/file (h/cur-dir) ".cache")]
     (when (.isFile hash-file)
         (.delete hash-file))
     (when (.isFile cache-file)
       (.delete cache-file))))
  nil)

(mh/setup-cli
 {:name "Neovim"
  :deps ["nvim"]
  :status    nvim/status
  :install   nvim/install
  :uninstall nvim/uninstall})

