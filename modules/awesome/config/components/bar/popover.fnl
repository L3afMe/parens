(import-macros {: btn : wgt : lyt : notify} :macros)

(local util      (require :util))
(local awful     (require :awful))
(local gears     (require :gears))
(local wibox     (require :wibox))
(local beautiful (require :beautiful))
(local xres      (require :beautiful.xresources))
(local dpi       xres.apply_dpi)

(local s (awful.screen.focused))

(local layout-box
    (awful.widget.layoutbox
        {:screen  s
          :buttons [(btn 1 (fn [] (awful.layout.inc  1)))
                    (btn 3 (fn [] (awful.layout.inc -1)))]}))
(set layout-box.forced_width  (dpi 20))
(set layout-box.forced_height (dpi 20))
(set layout-box.align         :center)
(set layout-box.valign        :center)

(local clock-box
  (wibox.widget
    {:widget wibox.widget.textbox
      :align  :center
      :font   beautiful.font-med}))
(gears.timer
  {:autostart true
    :call_now  true
    :timeout   60
    :callback
    (fn []
      (let [date (os.date "*t")
            hour (tostring (.. (if (< date.hour 10) "0" "") date.hour))
            mins (tostring (.. (if (< date.min  10) "0" "") date.min))
            time (string.format "<b>%s</b>:%s"
                                hour mins)]
        (clock-box:set_markup_silently time)))})

(local bb beautiful.bar.popover)
(local popover
  (lyt wibox.layout.align.horizontal
       {:expand :none}
       (wgt wibox.container.place
            {:halign :center}
            (wgt wibox.container.background
                 {:bg           bb.bg-color
                  :fg           bb.fg-color
                  :border_width bb.border-width
                  :border_color bb.border-color
                  :shape        bb.shape}
                 (wgt wibox.container.margin
                      {:margins (dpi 8)}
                      (lyt wibox.layout.fixed.horizontal
                           [layout-box
                            layout-box
                            (wgt wibox.container.margin
                                 {1 (wibox.widget.separator
                                      {:orientation   :vertical
                                       :forced_width  1
                                       :forced_height 20})
                                  :left 8
                                  :right 8}
                                 0)]
                           clock-box))))))

(local padding beautiful.bar.padding)

(fn margins [bubble]
  {:margins
   {:right padding.outer
    :bottom (+ padding.outer padding.inner bubble.height)}})

(fn placement [bubble]
  (fn [c] 
    (awful.placement.bottom_right c (margins bubble))))

(fn [bubble]
  (awful.popup 
    {:placement (placement bubble)
     :visible   false
     :ontop     true
     :type      :dock
     :bg        "#00000000"
     :widget    (lyt wibox.layout.align.vertical popover)}))

