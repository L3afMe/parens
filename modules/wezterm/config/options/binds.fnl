(import-macros {: bind} :macros)

(local wezterm (require :wezterm))
 
{:disable_default_key_bindings true
 :keys [;Select left tab
        (bind [CTRL SHIFT] :H
              (wezterm.action
                {:ActivateTabRelative -1}))

         ; Select right tab
        (bind [CTRL SHIFT] :L
              (wezterm.action
                {:ActivateTabRelative 1}))

         ; New tab
        (bind [CTRL SHIFT] :T
              (wezterm.action
                {:SpawnTab :CurrentPaneDomain}))

         ; Clone tab
        (bind [CTRL SHIFT] :W
              (wezterm.action 
                {:CloseCurrentTab 
                 {:confirm false}}))

         ; Activate copy mode
        (bind [CTRL] :X
              :ActivateCopyMode)

         ; Paste clipboard
        (bind [CTRL SHIFT] :V
              (wezterm.action
                {:PasteFrom :Clipboard}))

         ; Copy to clipboard
        (bind [CTRL SHIFT] :C
              (wezterm.action
                {:CopyTo :ClipboardAndPrimarySelection}))]}
