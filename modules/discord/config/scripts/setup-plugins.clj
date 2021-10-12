#!/usr/bin/env bb

(ns setup-plugins
  (:require [clojure.java.io :as io]
            [clojure.string :as str]
            [clojure.java.shell :as shell]))

(def plugins 
  [:mr-miner1/better-settings
   :Oocrop/multi-uploads
   :E-boi/ShowConnections
   :12944qwerty/copy-server-icon
   :12944qwerty/showAllMessageButtons   ; Test
   :1XC1XC/powercord-compiler
   :VenPlugs/grammar-nazi               ; Test
   :E-boi/NSFW-tags
   :VenPlugs/Unindent
   :VenPlugs/PersistFavourites
   :E-boi/github-in-discord
   :RazerMoon/muteNewGuild
   :notsapinho/powercord-mute-folder
   :Killerjet101/remind-me
   :jaimeadf/who-reacted
   :BenSegal855/webhook-tag
   :Litleck/DM-Typing-Indicator
   :A-Trash-Coder/Quick-Channel-Mute
   :A-Trash-Coder/Quick-Bot-Invite
   :griefmodz/smart-typers
   :griefmodz/scrollable-autocomplete
   :powercord-community/badges-everywhere
   :powercord-community/channel-typing
   :Oocrop/local-nicknames
   :A-Trash-Coder/Link-Preview-Utility
   :NurMarvin/guild-profile
   :Twizzer/relationship-notifier])

(defn print-no-dir []
  (println "Error install Powercord plugins:")
  (println "  POWERCORD_DIR environment variable is not set.")
  (println)
  (println "How to set (POSIX shell: Bash, zsh, etc):")
  (println "  export POWERCORD_DIR=\"<dir here>\""))

(defn invalid? [dir-str]
  (let [root-dir (io/file dir-str)
        plugin-dir (io/file dir-str "src/Powercord/plugins")]
    (not (and (.exists root-dir)
              (.exists plugin-dir))))) ; Potentially add more clauses

(defn print-invalid-dir []
  (println "Error install Powercord plugins:")
  (println "  POWERCORD_DIR environment variable is set to an invalid location")
  (println "Please fix this and rerun."))

(defn load-plugin [dir plugin]
  (let [repo (str/join "" (rest (str plugin)))
        plugin-name (last (str/split repo #"/"))]
    (println "Cloning" plugin-name)
    (let [response (shell/sh "git" "clone"
                    (str "https://github.com/" repo)
                    (format "%s/src/Powercord/plugins/%s" dir plugin-name))
          code (:exit response)]
      (if (zero? code)
        (println "Clone successful")
        (do 
          (println "Clone failed:")
          (println (:err response))))
      code)))

(defn install-plugins [pc-dir]
  (->> plugins
       (filter #(not (.exists (io/file 
                                pc-dir "src/Powercord/plugins"
                                (last (str/split (name %) #"/"))))))
       (map #(load-plugin pc-dir %))))

(let [pc-dir (System/getenv "POWERCORD_DIR")]
  (cond
    (nil? pc-dir)     (print-no-dir)
    (invalid? pc-dir) (print-invalid-dir)
    :else             (install-plugins pc-dir))) 

