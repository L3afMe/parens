
(fn parse_bind_opts [args]
  (let [modes (tostring (table.remove args 1))
        opts { :noremap true}
        argOpts args]
    (each [_ opt (ipairs argOpts)]
      (if (= opt :remap)
        (tset opts :noremap false)
        (tset opts opt true)))
    (values modes opts)))

{:opts (fn [opt ...]
         `(let [options# [,...]]
            (for [i# 1 (length options#) 2]
              (let [key# (. options# i#)
                    value# (. options# (+ i# 1))]
                (tset (. vim ,(tostring opt)) key# value#)))))

 :exec (fn [...]
         `(each [_# cmd# (ipairs [,...])]
            (vim.cmd cmd#)))

 :key (fn [...]
        (let [input [...]
              key  (. input 1)
              cmd  (. input 2)
              desc (. input 3)
              opts (or (. input 4) [])]
          (tset opts 1 cmd)
          (tset opts 2 desc)
          {key opts}))

 :group (fn [...]
          `(let [args# [,...]
                 key#  (table.remove args# 1)
                 name# (table.remove args# 1)
                 out#  []]
            (var out# [])
            (tset out# :name name#)
            (for [i# 1 (length args#)]
              (let [tbl# (. args# i#)]
                (each [key# val# (pairs tbl#)]
                  (tset out# key# val#))))
            {key# out#}))

 :bind (fn [...]
         `(let [args# [,...]]
            (let [wk# (require :which-key)]
              (for [j# 1 (length args#)]
                (let [group# (. args# j#)
                      opts#  (table.remove group# 1)]
                  (for [k# 1 (length group#)]
                    (wk#.register (. group# k#) opts#)))))))

 :augroup (fn [name ...]
            `(do
               (vim.cmd ,(.. "augroup " (tostring name)))
               (vim.cmd "autocmd!")
               ,(list `do ...)
               (vim.cmd "augroup END")))

 :autocmd (fn [...]
            `(vim.cmd ,(.. "autocmd " (table.concat [...] " "))))}

