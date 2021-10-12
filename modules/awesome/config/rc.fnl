;-*-Lisp-*-

(import-macros {: binds : btn} :macros)

(pcall require :luarocks.loader)
(require :awful.autofocus)

(let [naughty (require :naughty)]
  (naughty.connect_signal 
    "request::display_error"
    (fn [message startup?]
      (let [ending (if startup? " during start-up" "")
            title  (.. "Oops, an error happened" ending "!")]
        (naughty.notification
          {:urgency :critical}
          :title   title
          :message message)))))

(let [beautiful (require :beautiful)
      gears     (require :gears)]
  (beautiful.init
    (.. (gears.filesystem.get_configuration_dir) "misc/theme.lua")))

;; UI Components
(require :components.bar)
(require :components.titlebar)
(require :components.context-menu)
(require :components.notifications)

;; Binds
(require :misc.binds.mouse)
(require :misc.binds.keyboard)

;; Misc
(require :misc)

