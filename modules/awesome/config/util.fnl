{
 :map (fn [func col]
        (let [out {}]
          (each [idx value (ipairs col)]
            (tset out idx (func value)))
          out))
 
 :range (fn range [len]
          (local val [])
          (for [_ 1 len 1]
            (table.insert val {}))
          val)}
  

