(import-macros {: binds : binds2} :macros)

(local awful (require :awful))
(local vars  (require :misc.vars))
(local beautiful (require :beautiful))
(local naughty   (require :naughty))

(binds ;; Launcher Binds
  [{:description "Screenshot the whole screen" :group :Launcher
    :mods [vars.mod-key :Control] :key :3
    :action (fn [] (awful.spawn vars.screenshot_full))}
   {:description "Screenshot a section"        :group :Launcher
    :mods [vars.mod-key :Control] :key :4
    :action (fn [] (awful.spawn vars.screenshot_section))}
   {:description "Launch launcher"             :group :Launcher
    :mods [vars.mod-key] :key :d
    :action (fn [] (awful.spawn vars.launcher))}
   {:description "Launch terminal"             :group :Launcher
    :mods [vars.mod-key] :key :Return
    :action (fn [] (awful.spawn vars.terminal))}])
(binds ;; Awesome Binds
  [{:description "Toggle bar bubble"           :group :Awesome
    :mods [vars.mod-key :Shift] :key :a
    :action (fn []
              (let [screen  (awful.screen.focused)
                    bubble  screen.bar-bubble
                    popover screen.bar-popover]
                (set bubble.visible (not bubble.visible))
                (set popover.visible false)))}
   {:description "Restart Awesome"             :group :Awesome
    :mods [vars.mod-key :Shift] :key :r
    :action awesome.restart}
   {:description "Quit Awesome"                :group :Awesome
    :mods [vars.mod-key :Shift] :key :e
    :action awesome.quit}])
(binds ;; Layout Binds
  [{:description "Swap client with next"       :group :Layout
    :mods [vars.mod-key :Shift] :key :j
    :action (fn [] (awful.client.swap.byidx  1))}
   {:description "Swap client with previous"   :group :Layout
    :mods [vars.mod-key :Shift] :key :k
    :action (fn [] (awful.client.swap.byidx -1))}
   {:description "Increase master width"       :group :Layout
    :mods [vars.mod-key] :key :l
    :action (fn [] (awful.tag.incmwfact  0.05))}
   {:description "Decrease master width"       :group :Layout
    :mods [vars.mod-key] :key :h
    :action (fn [] (awful.tag.incmwfact -0.05))}
   {:description "Select next layout"          :group :Layout
    :mods [vars.mod-key] :key :space
    :action (fn [] (awful.layout.inc  1))}
   {:description "Select previous layout"      :group :Layout
    :mods [vars.mod-key :Shift] :key :space
    :action (fn [] (awful.layout.inc -1))}]) 
(binds ;; Focus Binds
  [{:description "Focus next window"           :group :Focus
    :mods [vars.mod-key] :key :j
    :action (fn [] (awful.client.focus.byidx  1))}
   {:description "Focus previous window"       :group :Focus
    :mods [vars.mod-key] :key :k
    :action (fn [] (awful.client.focus.byidx -1))}
   {:description "Focus next screen"           :group :Focus
    :mods [vars.mod-key :Control] :key :j
    :action (fn [] (awful.screen.focus_relative  1))}
   {:description "Focus previous screen"       :group :Focus
    :mods [vars.mod-key :Control] :key :k
    :action (fn [] (awful.screen.focus_relative -1))}])
(binds ;; Tag Binds
  [{:description "View previous tag"           :group :tag
    :mods [vars.mod-key] :key :Left
    :action awful.tag.viewprev}
   {:description "View next tag"               :group :tag
    :mods [vars.mod-key] :key :Right
    :action awful.tag.viewnext}
   {:description "View tag"                    :group :Tag
    :mods [vars.mod-key] :keygroup :numrow
    :action (fn [idx]
              (let [screen (awful.screen.focused) tag (. screen.tags idx)]
                (when tag (tag:view_only))))}
   {:description "Move client to tag"          :group :Tag
    :mods [vars.mod-key :Shift] :keygroup :numrow
    :action (fn [idx]
              (when client.focus (local tag (. client.focus.screen.tags idx))
                (when tag (client.focus:move_to_tag tag))))}])
(binds ;; Client Binds
  [{:description "Toggle fullscreen"           :group :Client
    :mods [vars.mod-key] :key :f
    :action (fn [c]
              (set c.fullscreen (not c.fullscreen))
              (c:raise))}
   {:description "Close client"                :group :Client
    :mods [vars.mod-key :Shift] :key :c
    :action (fn [c] (c:kill))}
   {:description "Toggle floating"             :group :Client
    :mods [vars.mod-key :Control] :key :space
    :action awful.client.floating.toggle}])
