(import-macros {: bind : group : key : opts} :macros)

(bind
  [{:prefix :<Leader>}
   (group
     :b :Buffer
     (key :h "<Cmd>BufferPrevious<CR>" "Go to previous buffer")
     (key :l "<Cmd>BufferNext<CR>"     "Go to next buffer")
     (key :j "<Cmd>BufferMovePrevious<CR>" "Move to previous buffer")
     (key :k "<Cmd>BufferMoveNext<CR>"     "Move to next buffer")
     (key :p "<Cmd>BufferPin<CR>" "Pin/unpin buffer")
     (key :<Space> "<Cmd>BufferPick<CR>" "Pick buffer")
     (key :1 "<Cmd>BufferGoto 1" "Go to buffer 1")
     (key :2 "<Cmd>BufferGoto 2" "Go to buffer 2")
     (key :3 "<Cmd>BufferGoto 3" "Go to buffer 3")
     (key :4 "<Cmd>BufferGoto 4" "Go to buffer 4")
     (key :5 "<Cmd>BufferGoto 5" "Go to buffer 5")
     (key :6 "<Cmd>BufferGoto 6" "Go to buffer 6")
     (key :7 "<Cmd>BufferGoto 7" "Go to buffer 7")
     (key :8 "<Cmd>BufferGoto 8" "Go to buffer 8")
     (key :8 "<Cmd>BufferLast"   "Go to buffer 9")
     (group 
       :d "Close Buffer"
       (key :d "<Cmd>BufferClose<CR>" "Close current buffer")
       (key :c "<Cmd>BufferCloseAllButCurrent<CR>" "Close all but current")
       (key :p "<Cmd>BufferCloseAllButPinned<CR>" "Close all but pinned")
       (key :h "<Cmd>BufferCloseBuffersLeft<CR>" "Close all left buffers")
       (key :l "<Cmd>BufferCloseBuffersRight<CR>" "Close all right buffers"))
     (group
       :o "Buffer Ordering"
       (key :b "<Cmd>BufferOrderByBufferNumber<CR>" "Sort by number")
       (key :d "<Cmd>BufferOrderByDirectory<CR>" "Sort by directory")
       (key :l "<Cmd>BufferOrderByLanguage<CR>" "Sort by language")
       (key :w "<Cmd>BufferOrderByWindowNumber<CR>" "Sort by window number")))])

(opts g
  :bufferline
  {:animation true
   :auto_hide false
   :tagpages  true
   :closable  true

   :maximum_padding 2
   :maximum_length 30
  
   :icons false

   :icon_close_tab ""
   :icon_close_tab_modified ""
   :icon_pinned ""})
