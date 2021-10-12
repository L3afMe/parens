(import-macros {: bind : group : key : opts} :macros)

; Use space as leader and comma as local leader
(opts g
      :mapleader " "
      :maplocalleader ",") 

(bind
  [{:mode :x}; Persistent identation
   (key :< :<gv "Decrease indent")
   (key :> :>gv "Increase indent")]

  [{:prefix :<Leader>}
   ; Tab handling
   (group
     :t :Tab
     (key :l :<cmd>tabnext<CR>     "Switch to next tab")
     (key :h :<cmd>tabprevious<CR> "Switch to previous tab")
     (key :t :<cmd>tabnew<CR>      "Open new tab")
     (key :d :<cmd>tabclose<CR>    "Close current tab"))

   ; Create new line without moving cursor
   (group
     :o "New line"
     (key :k "printf('m`%sO<ESC>``', v:count1)" "Create new line above cursor" {:expr true})
     (key :j "printf('m`%so<ESC>``', v:count1)" "Create new line below cursor" {:expr true}))

   (key :a :zA "(Un)fold recursively")]

   ; Ease of access
  [{:mode :x} (key ";" ":" "Open prompt")
   (key :H :^ "Go to first character")
   (key :L :$ "Go to last character")]
  [{:mode :n} (key ";" ":" "Open prompt")
   (key :H :^ "Go to first character")
   (key :L :$ "Go to last character")

   ; Move current line
   (key :<M-k> :<cmd>move--<CR> "Move line up")
   (key :<M-j> :<cmd>move+<CR>  "Move line down")]

  ; Smarter j/l
  [{}
   (key :j :gj "Move down display line")
   (key :k :gk "Move up display line")]

  ; Replace in selection or all text
  [{}         (key :<C-H> ::%s/ "Replace in buffer")]
  [{:mode :x} (key :<C-H> ::s/  "Replace in selection")]

  [{:mode :i}; Decrease indent in insert mode
   (key :<S-Tab> :<Esc><<i "Decrease indent")]
  [{:mode :v}; Copy to system clipboard
   (key :<Leader>y "\"+y")])

