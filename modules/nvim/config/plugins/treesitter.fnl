(import-macros {: bind : group : key} :macros)

(bind
  [{:prefix :<Leader>}
   (group
     :c :Highlighting
     (key :c "<Cmd>TSHighlightCapturesUnderCursor<CR>" "Get highlight group"))])

(let [ts (require "nvim-treesitter.configs")]
  (ts.setup
    {:ensure_installed "maintained"
    
     :highlight
     {:enable true}

     :matchup
     {:enable true}
     
     :playground
     {:enable true}
     
     :query_linter
     {:enable true
      :use_virtual_text true}}))
