(local awful     (require :awful))
(local gears     (require :gears))
(local beautiful (require :beautiful))

(tag.connect_signal "request::default_layouts"
  (fn [] 
    (awful.layout.append_default_layouts
      (let [l awful.layout.suit]
        [l.floating
         l.tile
         l.spiral.dwindle]))))

(screen.connect_signal "request::wallpaper"
  (fn [s]
    (when beautiful.wallpaper
      (local wallpaper beautiful.wallpaper)
      (gears.wallpaper.maximized
        (if (= (type wallpaper) :function)
          (wallpaper s)
          wallpaper)
        s true))))


