(ns setup-theme
  (:require [clojure.string :as str]
            [clojure.java.io :as io]))

(defmacro test-eq [arg1 arg2]
  `(let [value1 ~arg1
         value2 ~arg2]
    (when (not= value1 value2)
      (println "TEST FAILED: Line" ~(:line (meta &form)))
      (println "Expected:" value2)
      (println "Got:     " value1)
      (System/exit 1))
    (= value1 value2)))

(defn parse-step [[test ret-value] g value]
  `(if (and (nil? ~g) (->> ~value ~test)) ~ret-value ~g))

(defmacro cond$->>
  [value & clauses]
  (let [default (last clauses)
        clauses (butlast clauses)
        g       (gensym)
        steps   (map #(parse-step % g value)
                     (partition 2 clauses))]
    `(let [;; Initialize return value
           ~g nil
           ;; Run each step, setting g to the return value after each step
           ~@(interleave (repeat g) steps)]
       ;; If g is not nil, return g, else return default value
       (if (nil? ~g)
          ~default ~g))))

(defn prs [value]
  (cond$->> value
       (instance? clojure.lang.Keyword) (name value)
                                        (str value)))

(declare handle-rule)
(declare handle-rules)

(defn selector-partial [type values]
  (if (= (count values) 2)
    (str "[" (prs (nth values 0)) "" type "\"" (prs (nth values 1)) "\"]")
    (str (prs (nth values 0))
         "[" (prs (nth values 1)) "" type "\"" (prs (nth values 2)) "\"]")))

(defn selector-generic [selector values]
  (format selector (or (handle-rule (second values)) "") (handle-rule (first values))))

(defn wrap-value 
  "Wrap a value in a Vector if not already a Vector"
  [value]
  (println value (type value))
  (if (instance? clojure.lang.PersistentVector value)
    value [value]))

(defn handle-threaded-or [thread-first? values]
  (let [value (wrap-value (first values))
        steps (->> (rest values)
                (map #(concat value (wrap-value %)))
                (map handle-rules)
                (str/join ","))]
    (println steps)
    (handle-rules steps)))

(defn handle-complex-rule [rule]
  (let [key (first rule)
        values (rest rule)]
    (case key
      (   :el  :element) (str "[" (prs (first values) "]"))
      (:= :eq  :equals) (selector-partial "=" values)
      (:.=) (selector-partial "=" ["class" (first values)]) 
      (:#=) (selector-partial "=" ["id" (first values)])    
      (   :sw  :starts-with) (selector-partial "^=" values)
      (:.sw) (selector-partial "^=" ["class" (first values)])
      (:#sw) (selector-partial "^=" ["id" (first values)])
      (:| :swh :starts-with-or-hyphen) (selector-partial "|=" values)
      (:.|) (selector-partial "|=" ["class" (first values)])
      (:#|) (selector-partial "|=" ["id" (first values)])
      (:$ :ew  :ends-with) (selector-partial "$=" values)
      (:.$) (selector-partial "$=" ["class" (first values)])
      (:#$) (selector-partial "$=" ["id" (first values)])
      (:* :cn  :contains) (selector-partial "*=" values)
      (:.*) (selector-partial "*=" ["class" (first values)])
      (:#*) (selector-partial "*=" ["id" (first values)])
      (:not) (selector-generic "%s:not(%s)" values)
      (:lang) (selector-generic "%s:lang(%s)" values)
      (:nth-c :nth-child) (selector-generic "%s:nth-child(%s)" values)
      (:nth-lc :nth-last-child) (selector-generic "%s:nth-last-child(%s)" values)
      (:nth-t :nth-type :nth-of-type) (selector-generic "%s:nth-of-type(%s)" values)
      (:nth-lt :nth-last-type :nth-last-of-type) (selector-generic "%s:nth-last-of-type(%s)" values)
      (:active ::after ::before :checked :default :disabled :empty :enabled
       :first-child ::first-letter ::first-line :first-of-type :focus
       :focus-within :fullscreen :hover :in-range :indeterminate :invalid
       :last-child :last-of-type :link ::marker :only-of-type :only-child 
       :optional :out-of-range ::placeholder :read-only :read-write :required
       :target :valid :visited) (str (handle-rule (first values)) (str key))
      (:or) (str/join "," (map #(handle-rules %) values))
      (:or->> :or->) (handle-threaded-or (= key :or->) values)

      ;; Some syntactical sugar for Discord themes
      (:lbl) (selector-partial "=" ["aria-label" (first values)])
      (do
        (println "UKNOWN RULE:" key)
        (str rule)))))

(defn handle-rule [rule]
  (cond$->> rule
       (instance? clojure.lang.PersistentVector) (handle-complex-rule rule)
       (instance? clojure.lang.Keyword)          (name rule)
                                                 (str rule)))

(defn handle-rules [rules]
  (->> rules
       (map handle-rule)
       (str/join ">")))

(defn handle-values [imp? values]
  (->> values
      (map (fn [[key value]] 
            (str (prs key) ":" (prs value) (when imp? " !important"))))
      (str/join ";")
      (format "%s;")))

(defn css-i [& rules]
  (str/join ""
    (map
      (fn [rule]
        (let [rules  (handle-rules  (butlast rule))
              values (handle-values true (last rule))]
          (str rules "{" values "}")))
      rules)))

(defn css [& rules]
  (str/join ""
    (map
      (fn [rule]
        (let [rules  (handle-rules  (butlast rule))
              values (handle-values false (last rule))]
          (str rules "{" values "}")))
      rules)))

(test-eq
  (css [[:hover [:eq :nav :aria-label "Servers sidebar"]]
        {:width "70px"}])
  "nav[aria-label=\"Servers sidebar\"]:hover{width:70px;}")
(test-eq
  (css [[:eq :nav :aria-label "Servers sidebar"]
        {:width :10px
         :transition "width 0.5s"}])
  "nav[aria-label=\"Servers sidebar\"]{width:10px;transition:width 0.5s;}")
(test-eq
  (css [[:hover [:eq :nav :aria-label "Servers sidebar"]]
        {:width "70px"}]
       [[:eq :nav :aria-label "Servers sidebar"]
        {:width :10px
         :transition "width 0.5s"}])
  (str "nav[aria-label=\"Servers sidebar\"]:hover{"
         "width:70px;"
       "}"
       "nav[aria-label=\"Servers sidebar\"]{"
         "width:10px;"
         "transition:width 0.5s;"
       "}"))
(test-eq 
  (css [[:or
          [[:active :a]]
          [:p [:hover :a]]
          [[:hover :p] [:hover :a]]]
        {:color "Red"}])
  "a:active,p>a:hover,p:hover>a:hover{color:Red;}")
(test-eq 
  (css [[:or->> [:.| "test-class"]
          :a
          [:b]]
        {:color "Red"}])
  "a>[class|=\"test-class\"],b>[class|=\"test-class\"]{color:Red;}")
(test-eq 
  (css [[:or->> [:.| "test-class"]
          :a
          [:b]]
        {:color "Red"}])
  "[class|=\"test-class\"]>a,[class|=\"test-class\"]>a{color:Red;}")

(def colors
  {:foreground :#575279
   :foreground-light :#57527980
   :background :#F5E9DA
   :overlay    :#EDD7BD})

(def misc
  (css 
    [;; Remove the gift button
     [:lbl "Send a gift"]
     {:display :none}]))

(def user-popout
  (css-i
    ;; COLORING
    [;; Add border to popout and background color
     [:.| "userPopout"]
     {:background-color (:background colors)
      :border-radius :12px
      :border-style :solid
      :border-width :4px
      :border-color (:overlay colors)}]
    [;; Set footer and body background color
     [:or
       [[:.| "userPopout"] [:.| "body"] [:.| "bodyInnerWrapper"]]
       [[:.| "userPopout"] [:.| "footer"]]]
     {:background-color (:background colors)}]
    [;; Set default header color and bottom border
     [:.| "userPopout"] [:.| "headerNormal"] [:.| "banner"]
     {:width :100%
      :background-color   (:background colors)
      :border-bottom-width :4px
      :border-color       (:overlay colors)
      :border-style        :solid}]

    ;; HEADER
    [;; Extend header
     [:or
      [[:.| "userPopout"] [:.| "headerNormal"]]
      [[:.| "userPopout"] [:.| "headerNormal"] [:.| "banner"]]]
     {:height :96px}]
    [;; Add border to avatar
     [:.| "userPopout"] [:.| "avatarWrapperNormal"] [:.| "avatar"] :svg :foreignObject :div :img
     {:border-radius :12px
      :border-color (:overlay colors)
      :border-width :4px
      :border-style :solid}]
    [;; Disable avatar masks
     [:or
      [[:.| "userPopout"] [:.| "avatarWrapperNormal"] [:.| "avatarHint"] :foreignObject]
      [[:.| "userPopout"] [:.| "avatarWrapperNormal"] [:.| "avatar"] :svg :foreignObject]]
     {:mask :none
      :top 0 
      :left 0}]
    [;; Fix avatar hint
     [:.| "userPopout"] [:.| "avatarWrapperNormal"] [:.| "avatarHint"]
     {:top 0
      :left 0}]
    [;; Disable avatar border container
     [:.| "userPopout"] [:.| "avatarWrapperNormal"] [:.| "avatar"]
     {:visibility :hidden
      :border-width 0}]
    [;; Reenable avatar
     [:.| "userPopout"] [:.| "avatarWrapperNormal"] [:.| "avatar"] :*
     {:visibility :visible}]
    [;; Avatar container size
     [:or
      [[:.| "userPopout"] [:.| "avatarWrapperNormal"] [:.| "avatarHint"]]
      [[:.| "userPopout"] [:.| "avatarWrapperNormal"] [:.| "avatar"] :svg :foreignObject]]
     {:width  :75px
      :height :75px
      :overflow :visible}]
    [;; Avatar size
     [:or
      [[:.| "userPopout"] [:.| "avatarWrapperNormal"] [:.| "avatar"] 
          :svg :foreignObject :div]
      [[:.| "userPopout"] [:.| "avatarWrapperNormal"] [:.| "avatar"] 
          :svg :foreignObject :div :img]]
     {:width  :65px
      :height :65px}]
    [;; Avatar size
     [:or
      [[:.| "userPopout"] [:.| "avatarWrapperNormal"] [:.| "avatar"] 
          :svg :rect]]
     {:width  :65px
      :height :65px}]))

(def server-toolbar
  (css
    [;; Hide Update button
     (:.| "toolbar") (:lbl "Update ready!")
     {:display "none"}]
    [;; Hide Help button
     [:.| "toolbar"]
     [:eq :href "https://support.discord.com"]
     [:lbl "Help"]
     {:display "none"}]
    [;; Small search bar
     [:.| "toolbar"]
     [:.| "search"]
     [:sw "class" "search"]
     [:.| "searchBar"]
     {:width "75px"
      :transition "width 0.5s"}]
    [;; Expand searchbar on active
     [:.| "toolbar"]
     [:.| "search"]
     [:.* "open"]
     [:.| "searchBar"]
     {:width "240px"}]))

(def server-members
  (css
    [[:.| "membersWrap"]
     {:margin-right "-235px"
      :transition "transform 0.35s"
      :z-index 10}]
    [[:or->> [:.| "membersWrap"]
        [:hover]
        [:focus]
        [:focus-within]]
     {:transform "translatex(-235px)"}]
    [[:.| "membersWrap"] [:.| "members"]
     {:background-color "var(--background-primary)"
      :transition "background-color 0.2s"
      :max-width  :200vw}]
    [[:.| "membersWrap"] [:.| "members"]
     {:background "none !important"}]
    [[:or 
      [[:hover        [:.| "membersWrap"]] [:.| "members"]]
      [[:focus-within [:.| "membersWrap"]] [:.| "members"]]]
     {:background-color "var(--background-secondary)"}]
    [[:.| "membersWrap"] [:.| "membersGroup"]
     {:margin-right  :auto
      :width         :55px
      :text-overflow :clip
      :direction     :rtl
      :word-spacing  :1000px}]
    [[:or 
      [[:hover        [:.| "membersWrap"]] [:.| "membersGroup"]]
      [[:focus-within [:.| "membersWrap"]] [:.| "membersGroup"]]]
     {:width  :100%
      :margin 0
      :direction     :ltr
      :word-spacing  :unset
      :text-overflow :ellipsis}]
    [[:.| "membersWrap"] [:.| "members"] [:.| "content"]
     {:filter "opacity(0)"
      :transition "filter 0.2s"}]
    [[:or
      [[:hover        [:.| "membersWrap"]] [:.| "membersGroup"]]
      [[:focus-within [:.| "membersWrap"]] [:.| "membersGroup"]]
      [[:hover        [:.| "membersWrap"]] [:.| "members"] [:.| "content"]]
      [[:focus-within [:.| "membersWrap"]] [:.| "members"] [:.| "content"]]]
     {:filter "opacity(1)"}]))

(def server-sidebar
  (css 
    [;; Smaller server icons
     :.wrapper-25eVIn
     {:width  32
      :height 32}]
    [;; Smaller server icons
     :.wrapper-25eVIn :svg
     {:width  32
      :height 32}]
    ;; Expand on hover
    [[:eq :nav :aria-label "Servers sidebar"]
     {:z-index 10
      :width  :10px
      :transition "width 0.5s"}]
    [[:hover [:eq :nav :aria-label "Servers sidebar"]]
     {:width "70px"}]))

(def components
  [misc
   server-members
   server-sidebar
   server-toolbar
   user-popout])

(def manifest
  "{
    \"name\": \"L3af's Clojure Theme\",
    \"description\": \"CSS, but written in Clojure\",
    \"version\": \"1.0.0\",
    \"author\": \"L3af\",
    \"theme\": \"gen.css\",
    \"license\": \"MIT\"
}")

(let [pc-dir (System/getenv "POWERCORD_DIR")
      theme-dir (io/file pc-dir "src/Powercord/themes/L3af")
      manifest-file (io/file pc-dir "src/Powercord/themes/L3af/powercord_manifest.json")
      theme-file (io/file pc-dir "src/Powercord/themes/L3af/gen.css")]
  (when (and (not (.isDirectory theme-dir))
             (not (.mkdir theme-dir)))
    (println "Error creating theme directory"))

  (when (not (.isFile manifest-file))
    (with-open [writer (io/writer (.getAbsolutePath manifest-file))]
      (.write writer manifest)
      (println "Wrote manifest file")))
  
  (when (and (.exists theme-file)
             (not (.delete theme-file)))
    (println "Error deleting old theme file"))
  
  (with-open [writer (io/writer (.getAbsolutePath theme-file))]
    (.write writer (str/join "\n" components))
    (println "Written CSS to theme.")))

(do 
  (setup-theme/defmacros 
    [cw contains-word]
    [clojure.core/key setup-theme/value] 
    (clojure.core/str [ clojure.core/key])) 
  (clojure.core/defmacro .cw 
    [setup-theme/value] 
    (clojure.core/str "[class" "~" "=\"" setup-theme/value "\"]")))

(do 
  (setup-theme/defmacros 
    [! css-not] 
    [clojure.core/key setup-theme/value] 
    (clojure.core/str [ clojure.core/key])) 
  (clojure.core/defmacro ! 
    [clojure.core/key setup-theme/value] 
    (clojure.core/str "[class" clojure.core/key "=\"" setup-theme/value "\"]")))
