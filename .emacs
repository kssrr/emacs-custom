(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(electric-pair-mode 1)
(setq electric-pair-preserve-balance nil)

;; Repos:
(require 'package)
(setq package-check-signature nil)
;; Add any repositories here
(add-to-list 'package-archives
	     '("MELPA" .
	       "https://melpa.org/packages/"))
(package-initialize)

(custom-set-variables
 '(custom-enabled-themes '(atom-one-dark))
 '(custom-safe-themes
   '("171d1ae90e46978eb9c342be6658d937a83aaa45997b1d7af7657546cae5985b" default))
 '(ess-R-font-lock-keywords
   '((ess-R-fl-keyword:keywords . t)
     (ess-R-fl-keyword:constants . t)
     (ess-R-fl-keyword:modifiers . t)
     (ess-R-fl-keyword:fun-defs)
     (ess-R-fl-keyword:assign-ops . t)
     (ess-R-fl-keyword:%op% . t)
     (ess-fl-keyword:fun-calls)
     (ess-fl-keyword:numbers)
     (ess-fl-keyword:operators)
     (ess-fl-keyword:delimiters)
     (ess-fl-keyword:=)
     (ess-R-fl-keyword:F&T)))
 '(global-display-line-numbers-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(one-themes doom-themes dracula-theme github-modern-theme github-theme atom-one-dark-theme undo-tree haskell-mode zenburn-theme evil ess markdown-mode))
 '(tool-bar-mode nil))
(custom-set-faces
 '(default ((t (:family "Inconsolata" :foundry "CYRE" :slant normal :weight normal :height 181 :width normal)))))

;; evil ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(require 'evil)
(evil-mode 1)
(setq-default evil-cross-lines t)

;; Make a shortcut (:wbd) equivalent to M-x k:
(evil-define-command evil-write-and-kill-buffer (path)
  "Save and kill buffer."
  :repeat nil
  :move-point nil
  (interactive "<f>")
  (if (zerop (length path))
      (save-buffer)
    (write-file path))
  (kill-buffer (current-buffer)))
(evil-ex-define-cmd "wbd[elete]" 'evil-write-and-kill-buffer)
;; ...so :wbd should behave like default Emacs' C-x s C-x k
;; Think of :wbd as "Write Buffer & Delete"

;; ESS/R ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; ESS mode bindings:
(defun my-ess-mode-hook ()
  (define-key ess-mode-map (kbd "C-S-m") "|> ")
  (define-key inferior-ess-mode-map (kbd "C-S-m") "|> ")
  (define-key ess-mode-map (kbd "M--") #'ess-insert-assign)
  (define-key inferior-ess-mode-map (kbd "M--") #'ess-insert-assign)
  (cl-pushnew "|>" ess-R-assign-ops :test 'string=)
  (cl-pushnew "::" ess-R-assign-ops :test 'string=)
  (setq ess-style 'Rstudio)
  (setq ess-indent-with-fancy-comments nil))

(add-hook 'ess-mode-hook 'my-ess-mode-hook)

;; There is an issue in ESS where after printing tibbles or rlang
;; error tracebacks, the font color inside the window running the R
;; process changes colors. Avoiding this:
(defun fix-changing-font-colors ()
  (setq-local ansi-color-for-comint-mode 'filter))

(add-hook 'inferior-ess-mode-hook 'fix-changing-font-colors)

;; Markdown ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Markdown mode hook:
(with-eval-after-load 'markdown-mode
  (setq evil-respect-visual-line-mode t)
  (define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
  (define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
  (define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line))
