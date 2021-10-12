(import-macros {: opts} "macros")

(let [sign vim.fn.sign_define]
  (sign "LspDiagnosticsSignError" {:text ""})
  (sign "LspDiagnosticsSignWarning" {:text ""})
  (sign "LspDiagnosticsSignInformation" {:text ""})
  (sign "LspDiagnosticsSignHint" {:text ""}))

(let [nl (require :null-ls)
      b nl.builtins
      d b.diagnostics]
  (nl.config
    {:sources
     [d.write_good
      d.shellcheck
      b.code_actions.gitsigns]}))

(let [lsp (require :lspconfig)]
  (lsp.null-ls.setup {}))

