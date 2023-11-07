;;      ,----.         ___    ,---.       _,.----.    ,-,--.  
;;   ,-.--` , \ .-._ .'=.'\ .--.'  \    .' .' -   \ ,-.'-  _\ 
;;  |==|-  _.-`/==/ \|==|  |\==\-/\ \  /==/  ,  ,-'/==/_ ,_.' 
;;  |==|   `.-.|==|,|  / - |/==/-|_\ | |==|-   |  .\==\  \    
;; /==/_ ,    /|==|  \/  , |\==\,   - \|==|_   `-' \\==\ -\   
;; |==|    .-' |==|- ,   _ |/==/ -   ,||==|   _  , |_\==\ ,\  
;; |==|_  ,`-._|==| _ /\   /==/-  /\ - \==\.       /==/\/ _ | 
;; /==/ ,     //==/  / / , |==\ _.\=\.-'`-.`.___.-'\==\ - , / 
;; `--`-----`` `--`./  `--` `--`                    `--`---'  

;; General stuff ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Request dark title bar (works for GTK only):
(defun set-selected-frame-dark ()
  (interactive)
  (call-process-shell-command "xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT \"dark\" -id \"$(xdotool getactivewindow)\""))

(set-selected-frame-dark)

;; Put custom-set-variables into custom-file
;; so they don't clutter .emacs:
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Some general settings:
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(scroll-bar-mode -1)
(electric-pair-mode 1)
(setq inhibit-x-resources 1)
(setq make-backup-files nil) ;; no annyoing "[filename]~"-files

;; Set default window size under X:
(when (window-system)
  (set-frame-size (selected-frame) 80 37))

;; Repos:
(require 'package)
(setq package-check-signature nil)
;; Add any repositories here
(add-to-list 'package-archives
	     '("MELPA" .
	       "https://melpa.org/packages/"))
(package-initialize)

;; evil ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(require 'evil)
(evil-mode 1)
(setq-default evil-cross-lines t)
(evil-set-undo-system 'undo-redo)

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

; Syntax highlighting:
(setq ess-R-font-lock-keywords
 '((ess-R-fl-keyword:keywords . t)
   (ess-R-fl-keyword:constants . t)
   (ess-R-fl-keyword:modifiers . t)
   (ess-R-fl-keyword:fun-defs)
   (ess-R-fl-keyword:assign-ops . t)
   (ess-R-fl-keyword:%op% . t)
   (ess-fl-keyword:fun-calls)
   (ess-fl-keyword:numbers . t)
   (ess-fl-keyword:operators . t)
   (ess-fl-keyword:delimiters . t)
   (ess-fl-keyword:=)
   (ess-R-fl-keyword:F&T)))

;; ESS mode bindings:
(defun my-ess-mode-hook ()
  ;; custom key bindings for pipe and assignment like in RStudio:
  (define-key ess-mode-map (kbd "C-S-m") "|> ")
  (define-key inferior-ess-mode-map (kbd "C-S-m") "|> ")
  (define-key ess-mode-map (kbd "M--") #'ess-insert-assign)
  (define-key inferior-ess-mode-map (kbd "M--") #'ess-insert-assign)
  ;; Indentation guide:
  (setq ess-style 'RStudio)
  (setq ess-indent-with-fancy-comments nil)
  ;; Add custom keywords for highligthing:
  (font-lock-add-keywords nil
    '(("\\(\\w+\\):\\{2,3\\}" . font-lock-function-name-face) 
      ("\\\\" . font-lock-keyword-face)))
  ;; Ensure company-R-library is in ESS backends:
  (make-local-variable 'company-backends)
  (cl-delete-if (lambda (x) (and (eq (car-safe x) 'company-R-args))) company-backends)
  (push (list 'company-R-args 'company-R-objects 'company-R-library :separate)
    company-backends))

(add-hook 'ess-mode-hook 'my-ess-mode-hook)

(with-eval-after-load 'ess
  (setq ess-use-company t))

;; There is an issue in ESS where after printing tibbles or rlang
;; error tracebacks, the font color inside the window running the R
;; process changes colors. Avoiding this:
(defun fix-changing-font-colors ()
  (setq-local ansi-color-for-comint-mode 'filter))

(add-hook 'inferior-ess-mode-hook 'fix-changing-font-colors)

;; Markdown ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Use visual lines in markdown-mode:
(with-eval-after-load 'markdown-mode
  (setq evil-respect-visual-line-mode t)
  (define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
  (define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
  (define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line))

(setq markdown-fontify-code-blocks-natively t)

;; Dashboard
(require 'dashboard)
(dashboard-setup-startup-hook)
(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
(setq dashboard-startup-banner "~/.emacs.d/banner.txt")
(setq dashboard-center-content t)
(setq dashboard-items '((recents . 5)))

