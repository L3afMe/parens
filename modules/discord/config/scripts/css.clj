(ns setup-theme
  (:require [clojure.string :as str]
            [clojure.java.io :as io]))

(defmacro to-str [arg]
  (if (and (or (symbol? arg) (keyword? arg))
           (not (or (contains? &env arg)
                    (some? (resolve arg)))))
    (name arg)
    arg))

(defmacro defmacros [names values func]
  `(do 
     ~@(for [name names] 
         `(defmacro ~name ~values ~func))))

(defmacro selector-generic [names fmt]
  `(do
     (defmacros ~names [key value] `(format ~~fmt (to-str ~value) (to-str ~key)))))

(defmacro selector-partial [names short-name type]
  `(do
     (defmacros ~names [key value] (str "[" (to-str key) ~type "=\"" (to-str value)"\"]"))
     (defmacro ~short-name [value] (str "[class" ~type "=\"" (to-str value) "\"]"))))

(defmacro define-modifiers [modifiers]
  `(do
     ~@(for [modifier modifiers]
         `(defmacro ~(first modifier) [value]
            `(str (to-str ~value) ":" (to-str ~~(second modifier)))))))

(defmacros [el element] [key] (str "[" key "]"))
(selector-partial [swh starts-with-or-hyphen] .| "|")
(selector-partial [sw starts-with  ] .sw "^")
(selector-partial [ew ends-with    ] .$  "$")
(selector-partial [eq equals       ] .=  "")
(selector-partial [cn contains     ] .*  "*")
(selector-partial [cw contains-word] .cw  "~")

(selector-generic [lang] "%s:lang(%s)")
(selector-generic [! css-not] "%s:not(%s)")
(selector-generic [nth  nth-child]      "%s:nth-child(%s)")
(selector-generic [nth$ nth-last-child] "%s:nth-last-child(%s)")
(selector-generic [ntht  nth-type nth-of-type]           "%s:nth-child(%s)")
(selector-generic [ntht$ nth-last-type nth-last-of-type] "%s:nth-child(%s)")

(define-modifiers [[hover "hover"]
                   [active "active"]
                   [after ":after"]
                   [before ":before"]
                   [checked "checked"]
                   [default "default"]
                   [disabled "disabled"]
                   [empty "empty"]
                   [enabled "enabled"]
                   [first-child "first-child"]
                   [first-letter ":first-letter"]
                   [first-line ":first-line"]
                   [first-of-type "first-of-type"]
                   [focus "focus"]
                   [focus-within "focus-within"]
                   [fullscreen "fullscreen"]
                   [hover "hover"]
                   [in-range "in-range"]
                   [indeterminate "indeterminate"]
                   [invalid "invalid"]
                   [last-child "last-child"]
                   [last-of-type "last-of-type"]
                   [link "link"]
                   [marker ":marker"]
                   [only-of-type "only-of-type"]
                   [only-child "only-child"]
                   [optional "optional"]
                   [out-of-range "out-of-range"]
                   [placeholder ":placeholder"]
                   [read-only "read-only"]
                   [read-write "read-write"]
                   [required "required"]
                   [target "target"]
                   [valid "valid"]
                   [visited "visited"]])

(str/join " " ["Hello," "World!"])

(defmacro cor [& values]
  `(str/join "," 
             (map 
               (fn [val] to-str val 
                 ~values))))

(defmacro cor-> [start & steps]
  `(println ~(to-str steps)))

(str/join "," 
          (map (fn [val] (to-str val)) (a (.| Test) a)))
