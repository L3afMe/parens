(import-macros {: btn : wgt : lyt : notify} :macros)

(local util      (require :util))
(local awful     (require :awful))
(local gears     (require :gears))
(local wibox     (require :wibox))
(local beautiful (require :beautiful))
(local xres      (require :beautiful.xresources))
(local dpi       xres.apply_dpi)
(local naughty   (require :naughty))

(screen.connect_signal "request::desktop_decoration"
  (fn [s]
    (awful.tag ["1" "2" "3" "4" "5" "6" "7" "8" "9"] s 
               (. awful.layout.layouts 1))

    (local padding beautiful.bar.padding)

    (local bar-bubble
         (awful.popup 
           {:placement (fn [c]
                         (awful.placement.bottom_right c
                           {:margins
                            {:bottom padding.outer
                             :right  padding.outer}}))
            :visible   true
            :ontop     true
            :type      :dock
            :bg        "#00000000"
            :widget    (lyt wibox.layout.align.vertical
                            (require :components.bar.bubble))}))
    (set s.bar-bubble bar-bubble)

    (local popover-fn   (require "components.bar.popover"))
    (local popover      (popover-fn s.bar-bubble))
    (set   s.bar-popover popover)
    
    (var timer 
      (gears.timer.new
        {:timeout     1
         :call_now    false
         :autostart   false
         :single_shot true
         :callback (fn [] (set popover.visible false))}))

    (fn set-visible []
      (when timer.started (timer:stop))
      (set popover.visible true))


    ; Mouse enter either bubble or popover
    (bar-bubble:connect_signal "mouse::enter" set-visible)
    (popover:connect_signal    "mouse::enter" set-visible)

    ; Mouse leave either bubble or popover
    (fn set-not-visible [] (timer:again))
    (bar-bubble:connect_signal "mouse::leave" set-not-visible)
    (popover:connect_signal    "mouse::leave" set-not-visible)

    nil))

