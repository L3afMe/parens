(global lunacolors (require :lunacolors))
(global bait       (require :bait))
(global commander  (require :commander))
; (global delta      (require :delta))
(global fs         (require :fs))

(print (lunacolors.format
         (.. "Welcome {cyan}" hilbish.user
             "{reset} to {magenta}Hilbish{reset},\n"
             "the nice lil shell for {blue}Lua{reset} fanatics!\n")))

; ;; Requires `delta` to be installed
; (delta.init)

(commander.register "ver"
  (fn [] (print hilbish.ver)))

(commander.register "ev"
  (fn []
    (var text "")
    (var done? false)
    (while (not done?)
      (let [input (io.read)]
        (if (= nil input)
          (set done? true)
          (set text (.. text "\n" input)))))

    ; loadstring was replaced with load in Lua 5.2
    (local (ok err) (pcall (fn [] ((loadstring text)))))
    (if (not ok)
      (do 
        (print err)
        1)
      0)))

;; Aliases
(alias "cls" "clear")
(alias "gcd" "git checkout dev")
(alias "gcm" "git checkout master")

; ;; Petals
; (global petals (require :petals))
; (petals.init)

;; GPG
(os.execute "tty >/tmp/tty 2>&1")
(with-open [f (io.open "/tmp/tty")]
  (var tty (f:read "*all"))
  (set tty (tty:gsub "\n" ""))
  (os.setenv "GPG_TTY" tty)
  (os.execute "gpgconf --launch gpg-agent"))

;; Cargo
(appendPath "~/.cargo/bin")

;; Setup Volta
(let [voltaHome (.. (os.getenv :HOME) "/.volta")]
  (os.setenv "VOLTA_HOME" voltaHome)
  (appendPath (.. voltaHome "/bin")))

; ;; Setup jump (https://github.com/gsamokovarov/jump)
; (bait.catch "cd"
;   (fn [] (os.execute "jump chdir")))

(commander.register "j"
  (fn [args]
    (let [dir (first args)
          cmd (.. "jump cd " dir)]
      (with-open [file (io.popen cmd)]
        (local expdir (file:read "*all"))
        (fs.cd expdir)
        (bait.throw "cd" expdir)))
    
    0))

;; Default Prompt
(fn doPrompt [fail]
  (let [color (if fail "{red}" "{green}")
        text (.. "{blue}%u {cyan}%d " color "∆ ")
        formatted (lunacolors.format text)]
    (prompt formatted)))

(doPrompt false)

(bait.catch "command.exit"
  (fn [code] (doPrompt (not= 0 code))))

