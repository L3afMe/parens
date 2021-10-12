(import-macros {: bind : group : key} :macros)

(bind
  [{:prefix :<Leader>}
   (group 
     :f :Telescope
     (key :f "<cmd>Telescope find_files<CR>" "Fuzzy find files")
     (key :g "<cmd>Telescope live_grep<CR>"  "Grep all files")
     (key :r "<cmd>Telescope oldfiles<CR>"   "Open recent file")
     (key :p "<cmd>lua require('telescope').extensions.packer.plugins(opts)<CR>" "View plugin README's")
     (key :t "<cmd>TodoTelescope<CR>" "View TODOs"))])

(let [ts (require :telescope)]
  (ts.setup {})) 
