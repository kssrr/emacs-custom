;; Set the title bar of the current
;; frame to dark
(defun set-selected-frame-dark (&rest _)
  (call-process-shell-command "xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT \"dark\" -id \"$(xdotool getactivewindow)\""))

(set-selected-frame-dark)
