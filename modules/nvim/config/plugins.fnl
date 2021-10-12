(import-macros {: opts : bind : key} "macros")

(macro packer-use [...]
  `(let [pkgs# [,...]
         packer# (require :packer)]
     (packer#.startup
       (fn []
         (for [i# 1 (length pkgs#)]
           (let [name# (. pkgs# i#)
                 opts# (. pkgs# (+ i# 1))]
              (when (not= "table" (type name#))
                (if (= "table" (type opts#))
                  (do (tset opts# 1 name#)
                      (use opts#))
                  (use [name#]))))))
       {:config {:compile_path (.. (vim.fn.stdpath "config") "/lua/packer_compiled.lua")}})))

(packer-use 
  ;; Manages plugs or something.
  :wbthomason/packer.nvim

  ;; Vim game pog.
  :ThePrimeagen/vim-be-good
  {:cmd [:VimBeGood]}

  ;; Speedy loading.
  :lewis6991/impatient.nvim
  {:config #(require :impatient)}

  ;; :e? Who needs that?
  :nvim-telescope/telescope.nvim 
  {:config #(require :plugins.telescope)
   :requires [[:nvim-lua/popup.nvim]
              [:nvim-lua/plenary.nvim]]}

  ;; View packer
  :nvim-telescope/telescope-packer.nvim

  ;; For those of us without the best memory.
  :folke/which-key.nvim
  {:config #(require :plugins.which-key)}

  ;; LSP
  :neovim/nvim-lspconfig
  {:config #(require :plugins.lsp)
   :requires [[:jose-elias-alvarez/null-ls.nvim]]}

  ;; Display all LSP diagnostics.
  :folke/trouble.nvim
  {:config #(require :plugins.trouble)
   :requires [[:folke/lsp-colors.nvim]
              [:kyazdani42/nvim-web-devicons]]}

  ;; LSP code actions
  :weilbith/nvim-code-action-menu
  {:config #(bind [{:prefix :<Leader>} 
                   (key "n" "<Cmd>CodeActionMenu<CR>" "Open code actions menu")])
   :event  :BufWinEnter}

  ;; Display startup time
  :henriquehbr/nvim-startup.lua
  {:config #(. (require :nvim-startup) :setup)}

  ;; Imagine having to recompile to test code.
  :Olical/conjure

  :nvim-treesitter/nvim-treesitter
  {:config #(require :plugins.treesitter)
   :run ":TSUpdate"}

  :nvim-treesitter/playground
  {:run ":TSInstall query"}

  ;; Who needs to write code when you have autocomplete?
  :ms-jpq/coq_nvim
  {:config #(require :plugins.coq)
   :branch :coq
   :event  :BufWinEnter
   :run ":COQdeps"
   :requires [{1 :ms-jpq/coq.artifacts
               :branch :artifacts}
              {1 :ms-jpq/coq.thirdparty
               :branch :3p}]}

  ;; Persistence
  :folke/persistence.nvim
  {:config #(require :plugins.persistence)
   :event :BufReadPre
   :module :persistence}

  ;; Peace and quiet
  :folke/twilight.nvim
  {:config #(require :plugins.zen-mode)}

  ;; Peace and quiet (Part 2)
  :folke/zen-mode.nvim
  {:config #(require :plugins.zen-mode)}

  ;; Git integration
  :lewis6991/gitsigns.nvim
  {:config #(require :plugins.gitsigns)
   :event :BufWinEnter
   :requires [[:tpope/vim-fugitive]]}

  ;; bar bar black sheep
  :romgrk/barbar.nvim
  {:config #(require :plugins.barbar)}

  ; Fennel
  :bakpakin/fennel.vim

  ; Clojure
  :clojure-vim/clojure.vim

  :eraserhd/parinfer-rust 
  {:ft [:clojure :fennel :hy]
   :run "cargo build --release"}

  ; Swift
  :aciidb0mb3r/SwiftDoc.vim  {:ft :swift}
  :keith/swift.vim           {:ft :swift}
  :lilyball/vim-swift        {:ft :swift}

  ;; File Editing
  :tpope/vim-commentary {:cmd [:Commentary]}
  :907th/vim-auto-save
  {:config #(opts g :auto_save 1)
   :event :VimEnter}

  ;; Misc
  :nacro90/numb.nvim
  {:config #(. (require :numb) :setup)}
  :karb94/neoscroll.nvim
  {:config #(. (require :neoscroll) :setup)}
  :andymass/vim-matchup
  {:event :VimEnter}
   ;:config #(require plugin.matchup)}
  :jiangmiao/auto-pairs 
  {:event :VimEnter}
  :machakann/vim-sandwich
  {:event :VimEnter}
  :skywind3000/asyncrun.vim
  {:event :VimEnter}
  :gennaro-tedesco/nvim-peekup
  {:event :VimEnter}
  :folke/todo-comments.nvim
  {:config #(require :plugins.todo)
   :requires [[:nvim-lua/plenary.nvim]]}

  ;;UI
  ; Clear highlight automatically
  :romainl/vim-cool
  {:event :VimEnter}

  ; Rainbow parentheses
  :luochen1990/rainbow
  {:config #(require :plugins.rainbow)}

  ; Preview colors
  :ap/vim-css-color
  {:config #(vim.cmd 
              "au FileType lua    call css_color#init('hex', 'none', 'luaString,luaComment,luaString2')
               au FileType fennel call css_color#init('hex', 'none', 'fennelString,FennelKeyword')")}

  ; Colorschemes
  :L3afMe/rose-pine-sepia-nvim)

