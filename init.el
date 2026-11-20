;;; init.el --- Personal configuration -*- lexical-binding: t; -*-
;;; Encoding
(set-language-environment "UTF-8")

;;; Packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

;; Keep Customize's auto-generated code out of this file.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;; Store Emacs backup and auto-save files in the global config directory
(setq backup-directory-alist `(("." . ,(locate-user-emacs-file "backups/")))
      auto-save-file-name-transforms `((".*" ,(locate-user-emacs-file "auto-save/") t))
      create-lockfiles nil)

;;; Server
(require 'server)
(unless (server-running-p)
  (server-start))

;;; Appearance
(add-to-list 'default-frame-alist '(font . "FiraCode Nerd Font-14"))

(use-package ef-themes
  :config
  (load-theme 'ef-owl t))

(use-package nerd-icons)

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

;;; Editing
(use-package evil
  :config
  (evil-mode 1))

;;; Completion
(use-package vertico
  :init
  (vertico-mode))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package corfu
  :init
  (global-corfu-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package emacs
  :ensure nil
  :hook (minibuffer-setup . cursor-intangible-mode) ; makes the prompt property below work
  :custom
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  (tab-always-indent 'complete)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package which-key
  :init
  (which-key-mode))

;;; Tree-sitter (C / C++)
;; Install grammars once with: M-x treesit-install-language-grammar RET c / cpp
(use-package treesit
  :ensure nil
  :custom
  (treesit-font-lock-level 4)
  :init
  (setq treesit-language-source-alist
        '((c   "https://github.com/tree-sitter/tree-sitter-c")
          (cpp "https://github.com/tree-sitter/tree-sitter-cpp")))
  ;; Use the *-ts-mode variants; .c/.cpp/.h etc. keep working via the
  ;; default auto-mode-alist entries.
  (dolist (entry '((c-mode        . c-ts-mode)
                   (c++-mode      . c++-ts-mode)
                   (c-or-c++-mode . c-or-c++-ts-mode)))
    (add-to-list 'major-mode-remap-alist entry)))

;;; GLSL
(use-package glsl-mode
  :mode ("\\.glsl\\'" "\\.vert\\'" "\\.frag\\'" "\\.geom\\'"
         "\\.tesc\\'" "\\.tese\\'" "\\.comp\\'" "\\.vs\\'"
	 "\\.fs\\'"))

;;; LSP
;; Performance tuning recommended by lsp-mode
;; (setq gc-cons-threshold (* 100 1024 1024)
;;       read-process-output-max (* 1024 1024))
;; 
;; (use-package lsp-mode
;;   :init
;;   (setq lsp-keymap-prefix "C-c l")
;;   :hook ((c-ts-mode   . lsp-deferred)
;;          (c++-ts-mode . lsp-deferred)
;;          (lsp-mode    . lsp-enable-which-key-integration))
;;   :custom
;;   (lsp-completion-provider :none) ; completion is handled by corfu + orderless
;;   (lsp-clients-clangd-executable (when (eq system-type 'windows-nt) "C:/Program Files/LLVM/bin/clangd.exe"))
;;   (lsp-clients-clangd-args '("--background-index"
;;                              "--clang-tidy"
;;                              "--header-insertion=iwyu"
;;                              "--completion-style=detailed"
;;                              "--compile-commands-dir=build"))
;;   :config
;;   (add-hook 'lsp-completion-mode-hook
;;             (lambda ()
;;               (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
;;                     '(orderless)))))
;; 
;; (use-package lsp-ui
;;   :commands lsp-ui-mode
;;   :custom
;;   (lsp-ui-doc-position 'at-point))
;; 
;; (use-package lsp-treemacs
;;   :after lsp-mode
;;   :commands lsp-treemacs-errors-list)
