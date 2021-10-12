(ns modulehelper
  (:require [clojure.tools.cli :refer [parse-opts]]
            [babashka.process :as p]
            [clojure.java.io :as io]
            [clojure.string :as str]
            [helper :as h]))

(def cli-options
  [["-h" "--help"]
   ["-s" "--status"]
   ["-i" "--install"]
   ["-u" "--uninstall"]
   ["-d" "--dependencies"]])

(defn get-help [details opts]
  (str (:name details) " Configuration Manager\n"
       "\n"
       "USAGE\n"
       "  ./setup.clj [OPTIONS]\n"
       "\n"
       "OPTIONS\n"
       (:summary opts)))

(defmacro fmt-status [details]
  `(format "%s Install Status: %s"
    (:name ~details)
    (case ((:status ~details))
      nil   "Not installed"
      true  "Installed"
      false "Outdated")))

(defmacro fmt-deps [details]
  `(format "%s Dependencies:\n%s"
    (:name ~details)
    (str/join "\n" (:deps ~details))))

(defmacro setup-cli [details]
  (let [opts (parse-opts *command-line-args* cli-options)
        args (:options opts)
        help (get-help details opts)]
    (cond
      (not= nil (:help         args)) `(println ~help)
      (not= nil (:status       args)) `(println (fmt-status ~details))
      (not= nil (:install      args)) `((:install ~details))
      (not= nil (:uninstall    args)) `((:uninstall ~details))
      (not= nil (:dependencies args)) `(println (fmt-deps ~details))
      :else details)))

(defn get-file-details [file path]
  (let [name        (.getName file)
        config-path (.getAbsolutePath path)
        fnl-path    (.getAbsolutePath file)

        trim-count  (+ (count config-path) 1)
        out-path    (subs fnl-path trim-count (count fnl-path))
        trim-count  (+ -4 (count out-path))
        lua-path    (str (subs out-path 0 trim-count) ".lua")]
                         
    {:name name
     :fnl-path fnl-path
     :lua-path lua-path
     :out-path out-path}))

(defn -find-fnl-files [path orig]
  (->> (.listFiles path)
       (map (fn [file]
              (if (.isDirectory file)
                (-find-fnl-files  file orig)
                (get-file-details file orig))))
       (filter #(not= (:out-path %) "macros.fnl"))
       (flatten)))

(defn find-fnl-files [path]
  (-find-fnl-files path path))

(defmacro get-hash []
  `(subs (-> (p/process
              ["find" "./config"
                "-type" "f"
                "-exec" "cat" "{}" ";"])
            (p/process ["sha1sum"])
            :out slurp)
        0 40))

(defn install-file [file ctx]
  (println (str "Compiling " (:lua-path file) "..."))
  (let [cmd ["lua" "../../../lib/fennel" "--compile" (:fnl-path file)]
        lua-code (h/execute-cmd (str (:pfl ctx) "config") cmd)
        lua-file (io/file (:mod-dir ctx) (:lua-path file))
        lua-path (.getAbsolutePath lua-file)]
    (when (.exists lua-file)
      (.delete lua-file))
    (.mkdirs (io/file (.getParent lua-file)))
    (.createNewFile lua-file)
    (with-open
      [writer (io/writer lua-path)]
      (.write writer lua-code))
    lua-path))

(defn copy-file [file ctx]
  (println (str "Copying " (:out-path file) "..."))
  (let [fnl-file (io/file (:fnl-path file))
        out-file (io/file (:mod-dir ctx) (:out-path file))
        out-path (.getAbsolutePath out-file)]
    (when (.exists out-file)
      (.delete out-file))
    (.mkdirs (io/file (.getParent out-file)))
    (io/copy fnl-file out-file)
    out-path))

(defn install-all-fnl [ctx]
  (let [config    (io/file (:dir ctx) "config")
        fnl-files (find-fnl-files config)
        out       (map #(if (.endsWith (:fnl-path %) ".fnl")
                          (install-file % ctx)
                          (copy-file % ctx)) fnl-files)
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
      (.write writer (get-hash)))))

