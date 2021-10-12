(import-macros {: btn : wgt : lyt : notify} :macros)

(local xres      (require :beautiful.xresources))
(local dpi       xres.apply_dpi)
(local awful     (require :awful))
(local ruled     (require :ruled))
(local wibox     (require :wibox))
(local beautiful (require :beautiful))

(fn create-buttons [client]
  [(btn 1 (fn [] (client:activate {:context :titlebar :action  :mouse_move})))
   (btn 3 (fn [] (client:activate {:context :titlebar :action  :mouse_resize})))])

(fn create-title-bar-text [client]
  (let [buttons (create-buttons client)]
    (local text
      (wibox.widget {:widget wibox.widget.textbox
                     :align  :center}))

    (text:connect_signal "mouse::enter"
      (fn [] (set text.markup client.name)))
    (text:connect_signal "mouse::leave"
      (fn [] (set text.markup "")))

    text))

(fn create-title-bar [client]
  (let [tb beautiful.title-bar]
    (awful.titlebar client
        {:size      (dpi tb.size)
         :bg_normal tb.bg-inactive
         :bg_focus  tb.bg-active
         :position  :top})))

(fn setup-title-bar [client]
  (let [title-bar (create-title-bar client)
        text      (create-title-bar-text client)
        buttons   (create-buttons client)]
    (title-bar:setup 
      {1 text
       :layout  wibox.layout.flex.horizontal
       :buttons buttons})))

(client.connect_signal "request::titlebars" setup-title-bar)

(ruled.client.connect_signal "request::rules"
  (fn []
    ;; Add title bars to normal windows and dialogs
    (ruled.client.append_rule
      {:id         :titlebars
       :rule_any   {:type [:normal :dialog]}
       :properties {:titlebars_enabled true}})))

