(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			 ("gnu" . "http://elpa.gnu.org/packages/")))

(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(require 'use-package-ensure)
;; (setq use-package-always-ensure t)

(use-package emacs
  :ensure t
  :config
  (run-with-idle-timer 2 t (lambda () (garbage-collect)))

  (cl-ecase system-type
    (darwin (set-frame-font "Berkeley Mono 14" nil t))
    (gnu/linux (set-frame-font "Berkeley Mono 10" nil t)))

  (setq-default line-spacing 0.2)

  (menu-bar-mode 1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (pixel-scroll-precision-mode 1)
  (column-number-mode 1)
  (global-display-line-numbers-mode 1)
  (setopt use-short-answers t)

  (add-hook 'before-save-hook 'delete-trailing-whitespace)

  :custom
  (gc-cons-threshold (eval-when-compile (* 1024 1024 100)))
  (tab-always-indent t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (vc-follow-symlinks t)
  (inhibit-startup-message t)
  (display-fill-column-indicator-column 80)
  (ring-bell-function 'ignore)
  (read-process-output-max (* 1024 1024)))

(use-package modus-themes
  :ensure t
  :demand t
  :if (display-graphic-p)
  :config
  (modus-themes-load-theme 'modus-operandi))

(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package savehist
  :ensure t
  :init
  (savehist-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-icon nil)
  (doom-modeline-mode 1)
  :hook (after-init . doom-modeline-mode))

(use-package eat
  :ensure t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package direnv
  :ensure t
  :config
  (direnv-mode))

(use-package crux
  :ensure t
  :config
  (global-set-key [remap move-beginning-of-line] #'crux-move-beginning-of-line)
  (global-set-key [(super return)] #'crux-smart-open-line-above)
  (global-set-key (kbd "C-<return>") #'crux-smart-open-line)
  (global-set-key (kbd "C-c g x") #'crux-view-url)
  (global-set-key (kbd "C-x w t") #'crux-transpose-windows))

(use-package projectile
  :ensure t
  :bind ("s-p" . projectile-command-map)
  :init
  (projectile-mode +1))

(use-package smartparens
  :ensure t
  :bind (:map smartparens-mode-map
	 ("C-M-<space>" . sp-mark-sexp)
	 ("C-M-a" . sp-beginning-of-sexp)
	 ("C-M-e" . sp-end-of-sexp)

	 ("C-<down>" . sp-down-sexp)
	 ("C-<up>" . sp-up-sexp)
	 ("M-<down>" . sp-backward-down-sexp)
	 ("M-<up>" . sp-backward-up-sexp)

	 ("C-S-n" . sp-next-sexp)
	 ("C-S-p" . sp-backward-sexp)

	 ("C-M-f" . sp-forward-sexp)
	 ("C-M-b" . sp-backward-sexp)

	 ("C-S-f" . sp-forward-symbol)
	 ("C-S-b" . sp-backward-symbol)

	 ("C-<right>" . sp-forward-slurp-sexp)
	 ("C-<left>" . sp-forward-barf-sexp)
	 ("M-<left>" . sp-backward-slurp-sexp)
	 ("M-<right>" . sp-backward-barf-sexp)

	 ("C-M-k" . sp-kill-sexp)
	 ("C-M-<backspace>" . sp-backward-kill-sexp)
	 ("C-S-k" . sp-kill-hybrid-sexp)

	 ("M-<backspace>" . backward-kill-word)
	 ("C-<backspace>" . sp-backward-kill-word)
	 ([remap sp-backward-kill-word] . backward-kill-word)
	 ("M-d" . sp-kill-word)

	 ("C-M-t" . sp-transpose-sexp)
	 ("C-x C-t" . sp-transpose-hybrid-sexp)
	 ("C-M-w" . sp-copy-sexp)
	 ("C-M-d" . sp-delete-sexp)

	 ("M-[" . sp-join-sexp)
	 ("M-]" . sp-raise-sexp)

	 ("C-M-i" . sp-change-inner)
	 ("M-i" . sp-change-enclosing)

	 ("C-c (" . sp-wrap-round)
	 ("C-c [" . sp-wrap-square)
	 ("C-c {" . sp-wrap-curly))
  :init
  (require 'smartparens-config)
  (smartparens-global-strict-mode 1))

(use-package ligature
  :ensure t
  ;; :load-path "path-to-ligature-repo"
  :config
  (ligature-set-ligatures
   'prog-mode
   '(; Group A
     ".." ".=" "..." "..<" "::" ":::" ":=" "::=" ";;" ";;;" "??" "???"
     ".?" "?." ":?" "?:" "?=" "**" "***" "/*" "*/" "/**"
     ; Group B
     "<-" "->" "-<" ">-" "<--" "-->" "<<-" "->>" "-<<" ">>-" "<-<" ">->"
     "<-|" "|->" "-|" "|-" "||-" "<!--" "<#--" "<=" "=>" ">=" "<==" "==>"
     "<<=" "=>>" "=<<" ">>=" "<=<" ">=>" "<=|" "|=>" "<=>" "<==>" "||="
     "|=" "//=" "/="
     ; Group C
     "<<" ">>" "<<<" ">>>" "<>" "<$" "$>" "<$>" "<+" "+>" "<+>" "<:" ":<"
     "<:<" ">:" ":>" "<~" "~>" "<~>" "<<~" "<~~" "~~>" "~~" "<|" "|>"
     "<|>" "<||" "||>" "<|||" "|||>" "</" "/>" "</>" "<*" "*>" "<*>" ":?>"
     ; Group D
     "#(" "#{" "#[" "]#" "#!" "#?" "#=" "#_" "#_(" "##" "###" "####"
     ; Group E
     "[|" "|]" "[<" ">]" "{!!" "!!}" "{|" "|}" "{{" "}}" "{{--" "--}}"
     "{!--" "//" "///" "!!"
     ; Group F
     "www" "@_" "&&" "&&&" "&=" "~@" "++" "+++" "/\\" "\\/" "_|_" "||"
     ; Group G
     "=:" "=:=" "=!=" "==" "===" "=/=" "=~" "~-" "^=" "__" "!=" "!==" "-~"
     "--" "---"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

;; LSP
(use-package lsp-mode
  :ensure t
  :config
  (bind-keys ("s-l" . lsp))
  (bind-keys :prefix-map mjhika/lsp-format
	     :prefix "C-c f"
	     ("f" . lsp-format-buffer)
	     ("r" . lsp-format-region))
  (setq lsp-completion-provider :none)
  :hook
  ((c-mode
    clojure-mode
    go-mode
    zig-mode)
   . lsp-deferred)
  (lsp-mode . lsp-enable-which-key-integration)
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook
  (lsp-mode . lsp-ui-mode))

(use-package flycheck
  :ensure t
  :hook
  (lsp-mode . flycheck-mode))

(use-package emacs-lisp-mode
  :ensure nil
  :bind
  ("C-c C-c" . eval-defun)
  ("C-c C-e" . eval-last-sexp)
  ("C-c C-k" . elisp-eval-region-or-buffer))

(use-package clojure-mode
  :ensure t
  :hook (clojure-mode . subword-mode))

(use-package cider
  :ensure t
  :init
  (setq cider-enrich-classpath t
	cider-repl-pop-to-buffer-on-connect nil
	clojure-toplevel-inside-comment-form t
	cider-preferred-build-tool 'clojure-cli
	cider-repl-use-pretty-printing t
	cider-enable-flex-completion t)
  (defun mjhika/cider-comp ()
    (setq-local lsp-completion-enable nil))
  :config
  (bind-keys :prefix-map mjhika/cider-format
	     :prefix "C-c f"
	     ("f" . cider-format-buffer)
	     ("r" . cider-format-region)
	     ("d" . cider-format-defun))
  :hook ((clojure-mode . cider-mode)
	 (cider-mode . mjhika/cider-comp)))

(use-package clj-refactor
  :ensure t
  :after cider
  :hook (clojure-mode . (lambda ()
			  (interactive)
			  (clj-refactor-mode 1)
			  (yas-minor-mode 1)
			  (cljr-add-keybindings-with-prefix "C-c C-a"))))

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

(use-package go-mode
  :ensure t
  :hook
  (go-mode . lsp-go-install-save-hooks)
  (go-mode . subword-mode))

(use-package zig-mode
  :ensure t)

(use-package powershell
  :ensure t)

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-preselect 'directory)
  (corfu-popupinfo-delay 0.5)
  :bind
  (:map corfu-map
	("RET" . nil)
	("TAB" . indent-for-tab-command)
	("C-y" . corfu-complete))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode 1))

(use-package yasnippet
  :ensure t
  :hook
  (prog-mode . yas-minor-mode))

(use-package magit
  :ensure t)

(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.cache/emacs/backups"))
      auto-save-file-name-transforms '((".*" "~/.cache/emacs/autosaves/\\1" t))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(make-directory "~/.cache/emacs/autosaves" t)

(defun mjhika/open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))

(defun pull-next-line()
  (interactive)
  (move-end-of-line 1)
  (kill-line)
  (just-one-space))

(bind-keys* :prefix-map mjhika/toggles-prefix
	    :prefix "s-t"
	    ("t s" . smartparens-strict-mode)
	    ("t t" . modus-themes-toggle))

(bind-keys* ("s-f" . mjhika/open-init-file)
	    ("C-x C-b" . ibuffer)
	    ("C-j" . pull-next-line))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(powershell magit corfu-popupinfo-mode corfu eat ligature clj-refactor emacs-lisp-mode elisp-mode crux doom-modeline projectile direnv yasnippet flycheck lsp-ui lsp-mode cider clojure-mode orderless smartparens which-key vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
