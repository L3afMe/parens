(import-macros {: bind : group : key} :macros)

(bind
  [{:prefix :<Leader>}
   (group
     :q :Persistence
     (key :l ":lua require('persistence').load({ last = true })<cr>" "Restore the last session")
     (key :s ":lua require('persistence').load()<cr>" "Restore session for the current directory")
     (key :d ":lua require('persistence').stop()<cr>" "Stop Persistence"))])

(let [p (require :persistence)]
  (p.setup {}))
