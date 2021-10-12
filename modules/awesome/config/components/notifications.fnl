(local awful   (require :awful))
(local ruled   (require :ruled))
(local naughty (require :naughty))

(ruled.notification.connect_signal "request::rules"
  (fn []
    ;; All notifications will match this rule.
    (ruled.notification.append_rule
      {:rule {}
       :properties {:screen awful.screen.preferred
                    :implicit_timeout 15}})))

(naughty.connect_signal "request::display"
  (fn [n]
    (local s (awful.screen.focused))
    (naughty.layout.box {:notification n})))
