(let [wk (require :which-key)]
  (wk.setup 
    {:plugins
     {:marks true
      :registers true
      :spelling
      {:enabled true
       :suggestions 25}}
     :triggers [:<Leader>]
     :triggers_blacklist
     {:i [:j :k :v]
      :n [:j :k :v]}}))

