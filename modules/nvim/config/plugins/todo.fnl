(import-macros {: bind : group : key} :macros)

(bind
  [{:prefix :<Leader>}
   (group 
     :h :Todo
     (key :t "<Cmd>:TodoTelescope<CR>" "View TODOs in Telescope")
     (key :r "<Cmd>:TodoTrouble<CR>"   "View TODOs in Trouble"))])

(let [todo (require :todo-comments)]
  (todo.setup {}))
