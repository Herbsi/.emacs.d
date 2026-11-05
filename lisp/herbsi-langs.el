;;; herbsi-langs.el --- Languages -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


;;;; Tabs, indentation, and the TAB key

(use-feature emacs
  :demand t
  :hook ((git-commit-mode-hook prog-mode-hook) . display-fill-column-indicator-mode)
  :config
  (setq-default fill-column 88)
  (setopt tab-always-indent 'complete)
  (setopt tab-first-completion 'word-or-paren-or-punct) ; Emacs 27
  (setq-default tab-width 4)
  (setq-default indent-tabs-mode nil))


;;;; Disable 'electric' behaviour

(use-feature electric
  :hook (prog-mode-hook . electric-indent-local-mode)
  :config
  (electric-pair-mode -1)
  (electric-quote-mode -1)
  (electric-indent-mode -1))


;;; Parentheses (show-paren-mode)

(use-feature paren
  :config
  (show-paren-mode +1)
  (setopt show-paren-context-when-offscreen 'overlay) ; Emacs 29
  (setopt show-paren-delay 0.1)
  (setopt show-paren-style 'parenthesis)
  (setopt show-paren-when-point-in-periphery nil)
  (setopt show-paren-when-point-inside-paren nil))


;;;; Plain text (text-mode)

(use-feature text-mode
  :mode "\\`\\(README\\|CHANGELOG\\|COPYING\\|LICENSE\\)\\'"
  :hook (text-mode-hook . turn-on-auto-fill)
  :hook (text-mode-hook . (lambda () (setq fill-column 72)))
  :config
  (setopt adaptive-fill-mode t)
  (setopt colon-double-space nil)
  (setopt sentence-end-double-space t)
  (setopt sentence-end-without-period nil)
  (setopt use-hard-newlines nil))


;;;; Eldoc (Emacs live documentation feedback)

(use-feature eldoc
  :hook (prog-mode-hook . eldoc-mode)
  :config
  (setopt eldoc-message-function #'message)) ; don't use mode line for M-x `eval-expression', etc.


;;;; `hl-todo'

(use-package hl-todo
  :hook (prog-mode-hook . hl-todo-mode))


;;;; Handle performance for very long lines (so-long.el)

(use-feature so-long
  :config
  (global-so-long-mode +1))


;;;; Spellchecking (`jinx')

;; (use-package jinx
;;   :bind (("M-$" . jinx-correct)
;; 	     ("C-M-$" . jinx-languages))
;;  :hook ((text-mode-hook prog-mode-hook conf-mode-hook) . jinx-mode)
;;  :config
;;  (setopt jinx-languages "en_GB de_CH")
;;  (add-to-list 'jinx-exclude-faces
;;               '(typst-ts-mode font-lock-function-call-face font-lock-variable-name-face font-lock-variable-use-face font-lock-string-face)) ; TODO 2026-03-21 Unsure about `font-lock-string-face'
;;  (with-eval-after-load 'vertico-multiform
;;    (add-to-list 'vertico-multiform-categories
;;		         '(jinx grid (vertico-grid-annotate . 20) (vertico-count . 4))))
;;  )


;;;; Settings for code linting (`flymake')

(use-feature flymake
  :hook (prog-mode-hook . flymake-mode)
  :config
  (setopt flymake-fringe-indicator-position 'left-fringe)
  (setopt flymake-suppress-zero-counters t)
  (setopt flymake-no-changes-timeout 1.0)
  (setopt flymake-start-on-flymake-mode t)
  (setopt flymake-start-on-save-buffer t)
  (setopt flymake-wrap-around nil))


;;;; `outline' (`outline-mode' and `outline-minor-mode')

(use-feature outline
  :config
  (setopt outline-minor-mode-cycle t) ; emacs28
  (setopt outline-minor-mode-highlight nil) ; emacs28
  (setopt outline-minor-mode-use-buttons nil) ; emacs29 – bless you for the nil option!
  (setopt outline-minor-mode-use-margins nil)) ; as above


;;;; csv-mode

(use-package csv-mode
  :mode ("\\.csv\\'" . csv-mode))


;;;; lua-mode

(use-package lua-mode
  :mode "\\.lua\\'"
  :interpreter "lua"
  :config
  (setq lua-indent-level 4))


;;;; nix

(use-package nix-mode
  :mode "\\.nix\\'")

;;;; rust

(use-package rustic
  :mode ("\\.rs\\'" . rustic-mode)
  :config
  (setopt rustic-babel-format-src-block nil)
  (setopt rustic-format-trigger nil)
  (setopt rustic-lsp-client 'eglot))



(provide 'herbsi-langs)
;;; herbsi-langs.el ends here
