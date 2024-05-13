(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("gnu" . "http://elpa.gnu.org/packages/")))

(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(setq gc-cons-threshold (eval-when-compile (* 1024 1024 100)))
(run-with-idle-timer 2 t (lambda () (garbage-collect)))

(load-theme 'modus-operandi)
(set-frame-font "Berkeley Mono 12" nil t)

(setq vc-follow-symlinks t
      inhibit-startup-message t
      display-fill-column-indicator-column 80
      ring-bell-function 'ignore
      read-process-output-max (* 1024 1024))

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(pixel-scroll-precision-mode 1)
(column-number-mode 1)
(setopt use-short-answers t)

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
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-icon nil)
  (doom-modeline-mode 1)
  :hook (after-init . doom-modeline-mode))

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
  (global-set-key (kbd "C-c g x") #'crux-view-url))

(use-package projectile
  :ensure t
  :bind ("s-p" . projectile-command-map)
  :config
  (projectile-mode +1))

(use-package smartparens
  :ensure t
  ;; :hook ((prog-mode text-mode markdown-mode) . smartparens-strict-mode)
  :bind (:map smartparens-mode-map
	 ("C-M-f" . sp-forward-sexp)
	 ("C-M-b" . sp-backward-sexp)

	 ("C-M-d" . sp-down-sexp)
	 ("C-M-a" . sp-backward-down-sexp)
	 ("C-S-d" . sp-beginning-of-sexp)
	 ("C-S-a" . sp-end-of-sexp)

	 ("C-M-e" . sp-up-sexp)
	 ("C-M-u" . sp-backward-up-sexp)
	 ("C-M-t" . sp-transpose-sexp)

	 ("C-M-n" . sp-forward-hybrid-sexp)
	 ("C-M-p" . sp-backward-hybrid-sexp)

	 ("C-M-k" . sp-kill-sexp)
	 ("C-M-w" . sp-copy-sexp)

	 ("M-<delete>" . sp-unwrap-sexp)
	 ("M-<backspace>" . sp-backward-unwrap-sexp)

	 ("C-<right>" . sp-forward-slurp-sexp)
	 ("C-<left>" . sp-forward-barf-sexp)
	 ("C-M-<left>" . sp-backward-slurp-sexp)
	 ("C-M-<right>" . sp-backward-barf-sexp)

	 ("M-D" . sp-splice-sexp)
	 ("C-M-<delete>" . sp-splice-sexp-killing-forward)
	 ("C-M-<backspace>" . sp-splice-sexp-killing-backward)
	 ("C-S-<backspace>" . sp-splice-sexp-killing-around)

	 ("C-]" . sp-select-next-thing-exchange)
	 ("C-<left_bracket>" . sp-select-previous-thing)
	 ("C-M-]" . sp-select-next-thing)

	 ("M-F" . sp-forward-symbol)
	 ("M-B" . sp-backward-symbol)

	 ("C-\"" . sp-change-inner)
	 ("M-i" . sp-change-enclosing)

	 ("s-(" . sp-wrap-round)
	 ("s-[" . sp-wrap-square)
	 ("s-{" . sp-wrap-curly))
  :config
  (require 'smartparens-config)
  (smartparens-global-strict-mode 1))

;; LSP
(use-package lsp-mode
  :ensure t
  :bind
  ("s-l" . lsp)
  ("C-c f" . lsp-format-buffer)
  ("C-c r" . lsp-format-region)
  :hook
  ((c-mode
    clojure-mode
    go-mode)
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

(use-package clojure-mode
  :ensure t)

(use-package cider
  :ensure t
  :init
  (setq cider-enrich-classpath t
	cider-repl-pop-to-buffer-on-connect nil
	clojure-toplevel-inside-comment-form t)
  :hook (clojure-mode . cider))

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

(use-package go-mode
  :ensure t
  :hook
  (go-mode . lsp-go-install-save-hooks)
  (go-mode . subword-mode))

(use-package company
  :ensure t
  :init (setq company-idle-delay 0.2)
  :hook
  (prog-mode . company-mode))

(use-package yasnippet
  :ensure t
  :hook
  (prog-mode . yas-minor-mode))

(setq backup-by-copying t
      backup-directory-alist
      '(("." . "~/.cache/emacsbackups"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(crux doom-modeline projectile direnv yasnippet company flycheck lsp-ui lsp-mode cider clojure-mode orderless smartparens which-key vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
