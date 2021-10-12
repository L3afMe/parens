(local awful         (require :awful))
(local menubar       (require :menubar))
(local beautiful     (require :beautiful))
(local hotkeys_popup (require :awful.hotkeys_popup))
(require :awful.hotkeys_popup.keys)

(local myawesomemenu
  [["hotkeys"     (fn [] (hotkeys_popup.show_help nil (awful.screen.focused)))]
   ["manual"      (string.format "%s -e man awesome" terminal)]
   ["edit config" (string.format "%s %s" editor-cmd awesome.conffile)]
   ["restart"     awesome.restart]
   ["quit"        (fn [] (awesome.quit))]])

(global mymainmenu
  (awful.menu
    {:items [["awesome"       myawesomemenu beautiful.awesome_icon]
             ["open terminal" terminal]]}))

(global mylauncher
  (awful.widget.launcher
    {:image beautiful.awesome_icon
     :menu  mymainmenu}))

(set menubar.utils.terminal terminal)

