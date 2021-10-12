(ns test-ns)

(defmacro to-str [arg]
  (if (and (or (symbol? arg) (keyword? arg))
           (not (or (contains? &env arg)
                    (some? (resolve arg)))))
    (name arg)
    arg))

(defmacro map-to-str1 [& args]
  (to-str (first args)))

(defmacro map-to-str2 [& args]
  (map (fn [t] (to-str t)) args))

(def a "hi")
(println (map-to-str1 a))
(println (map-to-str2 a))
