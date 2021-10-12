(local gears      (require :gears))
(local xresources (require :beautiful.xresources))

(let [gears (require :gears)
      config_dir (gears.filesystem.get_configuration_dir)
      theme_dir (.. config_dir "misc/theme/")]
  {:font     "Comic Code Ligatures 10"
   :font-med "Comic Code Ligatures 12"

   :bg-normal :#F5E9DA
   :bg-darker :#EDD7BD

   :fg-normal :#575279
   :fg-darder :#232136
 
   :transparent :#00000000

   :title-bar
   {; Title bar settings
    :bg-inactive :#569F84
    :bg-active   :#907AA9
  
    :size 32}

   :bar 
   {:padding
    {:outer 20
     :inner 10}

    :bubble
    {:fg-color :#575279
     :bg-color :#F5E9DA

     :border-color :#EDD7BD
     :border-width 4

     :shape (fn [cr w h]
              (gears.shape.rounded_rect cr w h 0))}

    :popover
    {:fg-color :#575279
     :bg-color :#F5E9DA

     :border-color :#EDD7BD
     :border-width 4

     :shape (fn [cr w h]
              (gears.shape.rounded_rect cr w h 0))}}})
 
  ; :layout_fairh      (.. themes_path "fairhw.png")
  ; :layout_fairv      (.. themes_path "fairvw.png")
  ; :layout_floating   (.. themes_path "floatingw.png")
  ; :layout_magnifier  (.. themes_path "magnifierw.png")
  ; :layout_max        (.. themes_path "maxw.png")
  ; :layout_fullscreen (.. themes_path "fullscreenw.png")
  ; :layout_tilebottom (.. themes_path "tilebottomw.png")
  ; :layout_tileleft   (.. themes_path "tileleftw.png")
  ; :layout_tile       (.. themes_path "tilew.png")
  ; :layout_tiletop    (.. themes_path "tiletopw.png")
  ; :layout_spiral     (.. themes_path "spiralw.png")
  ; :layout_dwindle    (.. themes_path "dwindlew.png")
  ; :layout_cornernw   (.. themes_path "cornernww.png")
  ; :layout_cornerne   (.. themes_path "cornernew.png")
  ; :layout_cornersw   (.. themes_path "cornersww.png")
  ; :layout_cornerse   (.. themes_path "cornersew.png"))

