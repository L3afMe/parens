(import-macros {: btn} :macros)

(local awful (require :awful))
(local gears (require :gears))
(local vars  (require :misc.vars))

(root.buttons
  [(btn 3 (fn [] (mymainmenu:toggle)))
   (btn 4 awful.tag.vievprev)
   (btn 5 awful.tag.viewnext)])

(client.connect_signal
  "request::default_mousebindings"
  (fn []
    (awful.mouse.append_client_mousebindings 
      [(btn 1 (fn [c] (c:activate {:context :mouse_click})))
       (btn [vars.mod-key] 1 (fn [c] (c:activate {:context :mouse_click :action :mouse_move})))
       (btn [vars.mod-key] 3 (fn [c] (c:activate {:context :mouse_click :action :mouse_resize})))])))

(client.connect_signal "mouse::enter"
  (fn [c] (c:activate {:context "mouse_enter" :raise true})))
