(import-macros {: opts : exec : augroup : autocmd} "macros")

(opts o
      :splitbelow true
      :splitright true

      :timeoutlen 300
      :updatetime 300

      :termguicolors true

      :number true
      :relativenumber true
      :cursorline true
      
      :tabstop 2
      :softtabstop 2
      :shiftwidth 2
      :expandtab true

      :linebreak true
      :showbreak "↪"

      :wildmode "list:longest"

      :foldmethod "syntax"
      :foldlevelstart 99

      :scrolloff 5

      :mouse :nic
      :mousemodel :popup

      :fileformats :unix

      :inccommand :nosplit

      :history 500

      :pumheight 10

      :virtualedit :block

      :synmaxcol 200

      :signcolumn "auto:2")

(exec 
  "set noswapfile"
  "set noshowmode"
  "set confirm"
  "set wildignorecase"
  "set nojoinspaces"
  "set nostartofline"
  "set autowrite"
  "set undofile"
  "set visualbell"
  "set noerrorbells"
  "set shiftround"
  "set modeline"

  "set foldtext=getline(v:foldstart)"

  "colorscheme rose-pine-sepia")


