(local wezterm (require :wezterm))

{; Font config
 :font (wezterm.font_with_fallback
         ["Comic Code Ligatures"
          "TabulamoreScript-Regular"
          "FiraCode Nerd Font"
          "scientifica"
          "Pico8"])
          
 :font_size 10
 :font_shaper :Harfbuzz

 ; Padding 
 :window_padding
 {:left 35
  :right 35
  :top 35
  :bottom 35}

 ; Tab bar config 
 :hide_tab_bar_if_only_one_tab true

 ; Misc config 
 :front_end :OpenGL
 :window_close_confirmation :NeverPrompt}

