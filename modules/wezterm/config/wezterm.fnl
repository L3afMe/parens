(local wezterm (require :wezterm))

(fn merge [...]
  (let [list [...]
        out {}]
      (each [_ tbl (ipairs list)]
        (each [idx val (pairs tbl)]
            (tset out idx val)))
      out))

(merge (require :options.binds)
       (require :options.colors)
       (require :options.theme))

