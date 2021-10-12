(let [cmp (require :cmp)

      cmp-srcs   [{:name :nvim_lsp}
                  {:name :conjure}
                  {:name :buffer}
                  {:name :ultisnips}]

      menu-items {:path     "path"
                  :buffer   "buff"
                  :conjure  "conj"
                  :nvim_lsp "lsp"}

      cmp-format (fn [entry item]
                   (set item.menu (or (. menu-items entry.source.name) ""))
                   item)

      cmp-mappings {:<C-d> (cmp.mapping.scroll_docs -4)
                    :<C-f> (cmp.mapping.scroll_docs 4)
                    :<C-Space> (cmp.mapping.complete)
                    :<C-e> (cmp.mapping.close)
                    :<CR> (cmp.mapping.confirm {:select true})}]

  (cmp.setup {:formatting {:format cmp-format}
              :mapping cmp-mappings 
              :sources cmp-srcs}))

