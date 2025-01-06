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

;; (set-selected-frame-dark)

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
(setq make-backup-files nil)        ;; no annyoing "[filename]~"-files
(setq frame-resize-pixelwise t)     ;; avoid awkward borders around window when maximizing/tiling
(setq warning-minimum-level :error) ;; prevent annoying *Warnings*-Buffer popping up
(setq create-lockfiles nil)


;; Set default window size under X:
;; (when (window-system)
;;   (set-frame-size (selected-frame) 80 37)) ;; 82 39

;; Repos:
(require 'package)
(setq package-check-signature nil)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/")
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;; evil ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package evil
  :ensure t
  :init
  (setq-default evil-cross-lines t)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-redo)

  ;; Command to write and kill buffer (:wbd, "write buffer & delete")
  (evil-define-command evil-write-and-kill-buffer (path)
    "Save and kill buffer."
    :repeat nil
    :move-point nil
    (interactive "<f>")
    (if (zerop (length path))
        (save-buffer)
      (write-file path))
    (kill-buffer (current-buffer)))
  
  (evil-ex-define-cmd "wbd[elete]" 'evil-write-and-kill-buffer))

;; ESS/R ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package ess
  :ensure t
  :init
  ;; syntax highlighting
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
  
  :hook
  ((ess-mode . my-ess-mode-hook)
   (inferior-ess-mode . fix-changing-font-colors))
  
  :config
  ;; ESS mode customizations
  (defun my-ess-mode-hook ()
    ;; Custom key bindings for pipe and assignment like in RStudio
    (define-key ess-mode-map (kbd "C-S-m") "|> ")
    (define-key inferior-ess-mode-map (kbd "C-S-m") "|> ")
    (define-key ess-mode-map (kbd "M--") #'ess-insert-assign)
    (define-key inferior-ess-mode-map (kbd "M--") #'ess-insert-assign)
    (setq ess-style 'RStudio) ;; same indentation & style guide as RStudio
    (setq ess-indent-with-fancy-comments nil) ;; who thought this was a good idea
    ;; Highlighting for anonymous function syntax
    (font-lock-add-keywords nil
                            '(("\\(\\w+\\):\\{2,3\\}" . font-lock-function-name-face)
                              ("\\\\" . font-lock-keyword-face)))
    ;; Ensure `company-R-library` is in ESS backends (I'm not sure this part is working)
    (make-local-variable 'company-backends)
    (cl-delete-if (lambda (x) (and (eq (car-safe x) 'company-R-args)))
                  company-backends)
    (push (list 'company-R-args 'company-R-objects 'company-R-library :separate)
          company-backends))
  
  (defun fix-changing-font-colors ()
    "Fix issue where font colors change after printing tibbles or rlang tracebacks."
    (setq-local ansi-color-for-comint-mode 'filter))
  (setq ess-use-company t))

;; C++ stuff ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package lsp-mode
  :ensure t
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq lsp-completion-enable-additional-text-edit nil)
  (setq ccls-initialization-options
       '(:clang (:extraArgs ["-I/usr/include/c++/14"
                             "-I/usr/include/x86_64-linux-gnu/c++/14"
                             "-I/usr/include"]
                :resourceDir "/usr/lib/clang/19/include"))))
(use-package lsp-ui
  :commands lsp-ui-mode
  :ensure t)
(use-package ccls
  :ensure t
  :config
  (setq ccls-executable "ccls")
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))
(use-package flycheck
  :ensure t)
(use-package yasnippet
  :ensure t
  :config (yas-global-mode))
(use-package which-key
  :ensure t
  :config (which-key-mode))
(use-package helm-lsp
  :ensure t)
(use-package helm
  :ensure t
  :config (helm-mode))
(use-package lsp-treemacs
  :ensure t)

;; Compile single source file with F9
(defun code-compile()
  (interactive)
  (unless (file-exists-p "Makefile")
    (set (make-local-variable 'compile-command)
	 (let ((file (file-name-nondirectory buffer-file-name)))
	   (format "%s -o %s %s"
		   (if (equal (file-name-extension file) "cpp") "g++" "gcc")
		   (file-name-sans-extension file)
		   file)))
    (compile compile-command)))
(global-set-key [f9] 'code-compile)

;; Markdown ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package markdown-mode
  :ensure t
  :init
  (setq markdown-fontify-code-blocks-natively t) ;; highlight ("fontify") code chunks
  
  :hook
  (markdown-mode . my-markdown-mode-hook)

  :config
  ;; use visual line mode in markdown to make navigating big chunks of text easier
  (setq evil-respect-visual-line-mode t)
  (define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
  (define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
  (define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)

  (defun my-markdown-mode-hook ()
    "Enable visual-line-mode in markdown."
    (visual-line-mode 1)))

;; Dashboard ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package dashboard
  :ensure t
  :init
  ;; show dashboard on startup
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*"))
        dashboard-startup-banner "~/.emacs.d/ue-dark.png"
        dashboard-center-content t
        dashboard-items '((recents . 5)))

  :config
  (dashboard-setup-startup-hook))

;; Sidebar ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package dired-sidebar
  :ensure t
  :init
  ;; Load 'all-the-icons' if in a graphical display
  (when (display-graphic-p)
    (use-package all-the-icons
      :ensure t))

  :hook
  (dired-mode . all-the-icons-dired-mode)

  :config
  ;; Configure dired listing switches to hide hidden files but keep navigation
  (setq dired-listing-switches "-laD --group-directories-first --ignore=\.[[:alnum:]]*"))

(defun sidebar ()
  "Toggle the dired sidebar."
  (interactive)
  (dired-sidebar-toggle-sidebar))

;; Doom modeline
;; (use-package doom-modeline
;;   :ensure t
;;   :config
;;   (doom-modeline-mode 1))
