(import-macros {: bind : group : key} :macros)

(bind
  [{:prefix :<Leader>}
   (group
     :g :Git
     (group
       :r :Reset
       (key :r "<Cmd>lua require\"gitsigns\".reset_hunk()<CR>"         "Reset hunk")
       (key :b "<Cmd>lua require\"gitsigns\".reset_buffer()<CR>"       "Reset buffer")
       (key :i "<Cmd>lua require\"gitsigns\".reset_buffer_index()<CR>" "Reset buffer index"))
     (group
       :a :Stage
       (key :a "<Cmd>lua require\"gitsigns\".stage_hunk()<CR>"    "Stage hunk")
       (key :b "<Cmd>lua require\"gitsigns\".stage_buffer()<CR>"  "Stage buffer"))
     (key :u "<Cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>" "Undo stage hunk")
     (key :v "<Cmd>lua require\"gitsigns\".preview_hunk()<CR>"    "Preview hunk")
     (key :t "<Cmd>Gitsigns toggle_current_line_blame<CR>"        "Toggle blame")
     (key :c "<Cmd>Git commit<CR>"                                "Commit files")
     (key :p "<Cmd>Git push<CR>"                                  "Push commits"))])

(let [gs (require :gitsigns)]
  (gs.setup 
    {:signcolumn true
     :signs
     {:add          {:text " "}
      :change       {:text " "}
      :delete       {:text " "}
      :topdelete    {:text " "}
      :changedelete {:text " "}}
     :keymaps []}))
