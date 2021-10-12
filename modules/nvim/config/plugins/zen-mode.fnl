(import-macros {: bind : key} :macros)

(bind [{:prefix :<Leader>} (key :z ":ZenMode<CR>" "Toggle Zen Mode")])

(let [zm (require :zen-mode)]
  (zm.setup
    {:window
     {:backdrop 1
      :width    100
      :options
      {:relativenumber false
       :number         false
       :list           false
       :cursorline     false
       :cursorcolumn   false
       :signcolumn     :no
       :foldcolumn     :0}}
     :plugins
     {:options
      {:enabled true
       :ruler   false
       :showcmd false}
      :twilight {:enabled true}
      :gitsigns {:enabled false}}}))
