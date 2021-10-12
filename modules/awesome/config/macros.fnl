; All functions in here won't be accessible after compilation
(fn map [func col]
  (let [out {}]
    (each [idx value (ipairs col)]
      (tset out idx (func value)))
    out))

(fn map2 [exe items]
  (let [out {}]
    (each [idx val (ipairs items)]
      (tset out idx (exe val)))
    out))

(fn join [...]
  (let [out []
        tbls [...]]
    (each [_ tbl (ipairs tbls)]
      (each [key value (pairs tbl)]
        (if (= (type key) :number) ; This is so hacky
          (table.insert out value)
          (tset out key value))))
    out))

(fn dump [parent]
  (if (= "table" (type parent))
    (do
      (var output "{ ")
      (each [_key value (pairs parent)]
        (var key _key)
        (when (not= "number" (type _key))
          (set key (.. "'" _key "'")))
        (set output (.. output "[" key "] = " (dump value) ", ")))
      (.. output "} "))
    (tostring parent)))

{:notify (fn [message opts]
             `((. (require :naughty) :notification)
               ,(join {:message message} opts)))

 :dpb-notify (fn [message opts]
              `((. (require :naughty) :notification)
                ,(join {:message (dump message)} opts)))

 :lyt (fn [layout args content]
        (join
          {:layout layout}
          (if (= content nil)
            [args] ; When args is content so it needs to be wrapped
            args)  ; Args is wrapped so just return args
          (if (and (not= content nil) ; When args is content
                   (not= content 0)) ; When explicitly no content
            [content]
            [])))

 :wgt (fn [widget args content]
        (join
          {:widget widget}
          (if (= content nil)
            [args] ; When args is content so it needs to be wrapped
            args)  ; Args is wrapped so just return args
          (if (and (not= content nil) ; When args is content
                   (not= content 0)) ; When explicitly no content
            [content]
            [])))

 :btn (fn [arg1 arg2 arg3]
        (if (= arg3 nil)
          `(awful.button {} ,arg1 ,arg2)
          `(awful.button ,arg1 ,arg2 ,arg3)))

 :binds (fn [...]
          (let [binds ...]
            `(awful.keyboard.append_global_keybindings
               ,(map (fn
                       [bind]
                       `(awful.key
                          {:modifiers   ,bind.mods
                           :keygroup    ,bind.keygroup
                           :key         ,bind.key
                           :description ,bind.description
                           :group       ,bind.group
                           :on_press    ,bind.action}))
                     binds))))
 :binds2 (fn [...]
          (let [ binds ...]
            `(gears.table.join
               ,(map2 (fn [bind]
                       `(awful.key 
                          ,(. bind 1)
                          ,(. bind 2)
                          ,(. bind 3)))
                     binds))))}

