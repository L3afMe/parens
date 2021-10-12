
(let [vfn vim.fn
      execute vim.api.nvim_command
      path (string.format "%s/site/pack/packer/start/packer.nvim" (vfn.stdpath :data))]
  (when (< 0 (vfn.empty (vfn.glob path)))
    (execute (.. "!git clone https://github.com/wbthomason/packer.nvim " path)))
  (execute "packadd packer.nvim"))

(fn loadModules [...]
  (each [_ value (ipairs [...])]
    (let [config (.. (vim.fn.stdpath "config") "/")
          (ok? _) (pcall require value)]
      (if (not ok?)
        (print (string.format "Failed to load module '%s'" value))))))

(loadModules
  :plugins
  :core/autocmd
  :core/keymap
  :core/options)

