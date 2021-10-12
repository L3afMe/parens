(fn map [func col]
  (let [out {}]
    (each [idx value (ipairs col)]
      (tset out idx (func value)))
    out))

{
  :bind (fn [mods key action]
           `{:mods ,(table.concat (map (fn [value] (tostring value)) mods) "|")
             :key ,key
             :action ,action})} 
          

