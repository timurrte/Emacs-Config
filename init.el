;; -*- lexical-binding: t; -*-
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

(require 'server)
(unless (server-running-p)
  (server-start))

(add-to-list 'default-frame-alist '(font . "FiraCode Nerd Font 14"))

(use-package nerd-icons)

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package vertico
  :init
  (vertico-mode))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package corfu
  :init
  (global-corfu-mode)
  )

(use-package emacs
  :ensure nil
  :custom
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  (tab-always-indent 'complete)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

;; Performance tuning required by lsp-mode
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024))

(use-package which-key
  :init
  (which-key-mode))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
         (c-ts-mode . lsp-deferred)
         (c++-ts-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :custom
  (lsp-completion-provider :none)
  (lsp-clients-clangd-args '("--background-index"
                             "--clang-tidy"
                             "--header-insertion=iwyu"
                             "--completion-style=detailed"
                             "--compile-commands-dir=build"))
  :config
  (add-hook 'lsp-completion-mode-hook
            (lambda ()
              (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
                    '(orderless)))))
(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-show-diagnostics t))
(use-package lsp-treemacs
  :after (lsp-mode treemacs)
  :commands lsp-treemacs-errors-list)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("b89b6d95670712b8742f4391416483a29d4315323a218600590160e132c70ec8"
     default))
 '(package-selected-packages
   '(corfu ef-themes evil nerd-icons nerd-icons-dired orderless
	   tree-sitter treemacs vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package ef-themes
  :config
  (load-theme 'ef-owl t))

(evil-mode)

;; Tree-sitter configuration for C and C++
(use-package treesit
  :ensure nil
  :mode (("\\.cpp\\'" . c++-ts-mode)
         ("\\.hpp\\'" . c++-ts-mode)
         ("\\.cc\\'"  . c++-ts-mode)
         ("\\.hh\\'"  . c++-ts-mode)
         ("\\.cxx\\'" . c++-ts-mode)
         ("\\.hxx\\'" . c++-ts-mode)
         ("\\.c\\'"   . c-ts-mode))
  :custom
  (treesit-font-lock-level 4) ; Maximum syntax highlighting detail (1-4)
  :init
  ;; Register grammar repositories
  (setq treesit-language-source-alist
        '((c   "https://github.com/tree-sitter/tree-sitter-c")
          (cpp "https://github.com/tree-sitter/tree-sitter-cpp")))
  ;; Remap standard C/C++ modes to their Tree-sitter equivalents
  (setq major-mode-remap-alist
        '((c-mode          . c-ts-mode)
          (c++-mode        . c++-ts-mode)
          (c-or-c++-mode   . c-or-c++-ts-mode))))
