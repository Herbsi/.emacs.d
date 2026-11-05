;;; herbsi-evil.el --- Yet another modal editing on Emacs -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-package evil
  :demand t
  :init
  (setopt evil-default-state 'emacs
          evil-respect-visual-line-mode t
          evil-want-C-g-bindings nil
          evil-want-C-i-jump nil
          evil-want-C-u-delete nil
          evil-want-C-u-scroll t  ; moved the universal arg to <leader> u
          evil-want-C-w-delete t
          evil-want-C-w-in-emacs-state nil
          evil-want-Y-yank-to-eol t
          evil-want-abbrev-expand-on-insert-exit nil
          evil-want-fine-undo t
          evil-want-integration t
          evil-want-keybinding nil)
  :hook (git-commit-mode-hook . (lambda () (evil-insert-state)))
  :hook (after-change-major-mode-hook . (lambda () (setopt evil-shift-width tab-width)))
  :config
  (setopt evil-ex-search-vim-style-regexp t
          evil-ex-visual-char-range t  ; column range for ex commands
          evil-mode-line-format 'before
          ;; more vim-like behaviour
          evil-symbol-word-search t
          evil-normal-state-cursor 'box
          evil-emacs-state-cursor  'box
          evil-insert-state-cursor 'bar
          evil-visual-state-cursor 'hollow
          ;; Only do highlighting in selected window so that Emacs has less work
          ;; to do highlighting them all.
          evil-ex-interactive-search-highlight 'selected-window
          evil-kbd-macro-suppress-motion-error t
          evil-undo-system 'undo-fu)

  (evil-select-search-module 'evil-search-module 'evil-search)

  (evil-mode 1)

  (setopt evil-visual-update-x-selection-p nil)

  (setopt evil-split-window-below t
          evil-vsplit-window-right t)

  ;;;; Set initial states
  (dolist (mode '(text-mode prog-mode))
    (evil-set-initial-state mode 'normal))


  ;;;; Keybindings
  (evil-set-leader '(normal visual motion) (kbd "SPC"))
  (evil-set-leader '(insert replace operator emacs) (kbd "M-SPC"))

  ;;;;; submaps
  (defvar-keymap herbsi-leader-buffer-map
    "b" 'switch-to-buffer
    "i" 'ibuffer
    "k" 'kill-current-buffer
    "K" 'kill-buffer
    "m" 'bookmark-set
    "l" 'consult-bookmark
    "n" 'next-buffer
    "p" 'previous-buffer)

  (defvar-keymap herbsi-leader-code-map
    "f" 'apheleia-format-buffer)

  (defvar-keymap herbsi-leader-eval-map
    "b" 'eval-buffer
    "e" 'eval-last-sexp
    "f" 'eval-defun
    "r" 'eval-region)

  (defvar-keymap herbsi-leader-file-map
    "f" 'find-file
    "r" 'recentf
    "s" 'save-buffer
    "S" 'save-some-buffers)

  (defvar-keymap herbsi-leader-insert-map
    "c" 'insert-char
    "s" 'tempel-insert)

  (defvar-keymap herbsi-leader-notes-map
    "n" 'denote)

  (defvar-keymap herbsi-leader-search-map
    "o" 'consult-outline)

  ;;;;; leader tree
  (defvar-keymap herbsi-leader-map
    "u" 'universal-argument
    "," 'switch-to-buffer
    "." 'find-file
    ";" 'eval-expression
    ":" 'execute-extended-command
    "RET" 'consult-bookmark
    "A" 'org-agenda
    "a" 'embark-act
    "j" 'dired-jump
    "x" 'org-capture
    "/" 'consult-ripgrep
    "h" help-map
    "p" project-prefix-map
    "w" evil-window-map
    "b" herbsi-leader-buffer-map
    "c" herbsi-leader-code-map
    "e" herbsi-leader-eval-map
    "f" herbsi-leader-file-map
    "i" herbsi-leader-insert-map
    "n" herbsi-leader-notes-map
    "s" herbsi-leader-search-map)

  ;; The whole tree lives under <leader>; one binding does it all.
  (evil-define-key 'normal 'global (kbd "<leader>") herbsi-leader-map)

  ;;;;; insert
  (evil-define-key 'insert 'global (kbd "C-SPC") 'completion-at-point)

  ;;;;; which-key
  (which-key-add-keymap-based-replacements herbsi-leader-map
    "b" "buffers"
    "c" "code"
    "e" "eval"
    "f" "files"
    "h" "help"
    "i" "insert"
    "p" "project"
    "s" "search"
    "w" "window"))


;;; Packages

(use-package evil-args
  :after evil
  :config
  ;; Bind evil-args text objects.
  (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
  (define-key evil-outer-text-objects-map "a" 'evil-outer-arg))


(use-package evil-easymotion
  :demand t
  :config
  ;; Use evil-search backend, instead of isearch.  The :bind value is
  ;; built with `list' so use-package's keyword scanner does not
  ;; mistake it for a use-package :bind (which byte-compiles as a
  ;; malformed function).
  (evilem-make-motion evilem-motion-search-next #'evil-ex-search-next
                      :bind (list '(evil-ex-search-highlight-all nil)))
  (evilem-make-motion evilem-motion-search-previous #'evil-ex-search-previous
                      :bind (list '(evil-ex-search-highlight-all nil)))
  (evilem-make-motion evilem-motion-search-word-forward #'evil-ex-search-word-forward
                      :bind (list '(evil-ex-search-highlight-all nil)))
  (evilem-make-motion evilem-motion-search-word-backward #'evil-ex-search-word-backward
                      :bind (list '(evil-ex-search-highlight-all nil)))

  (with-eval-after-load 'evil
    (keymap-set evil-motion-state-map "g s" evilem-map))

  (bind-keys :map evilem-map
             ("/" . evil-avy-goto-char-timer)
             ("s" . evil-avy-goto-char-2)
             ("SPC" . (lambda () (interactive) (let ((current-prefix-arg t)) (evil-avy-goto-char-timer))))))


(use-package evil-embrace
  :commands (embrace-add-pair embrace-add-pair-regexp)
  :hook (LaTeX-mode-hook . embrace-LaTeX-mode-hook)
  :init
  (with-eval-after-load 'evil-surround
    (evil-embrace-enable-evil-surround-integration))
  :config
  (setopt evil-embrace-show-help-p nil))


(use-package evil-escape
  :demand t
  :init
  (setopt evil-escape-excluded-states '(normal visual multiedit emacs motion)
          evil-escape-key-sequence "jk"
          evil-escape-delay 0.15)
  (evil-define-key* '(insert replace visual operator) 'global "\C-g" #'evil-escape)
  :config
  ;; `evil-escape' in the minibuffer is more disruptive than helpful.
  (add-hook 'evil-escape-inhibit-functions
            (lambda ()
              (and (minibufferp) (evil-normal-state-p))))

  (evil-escape-mode +1))


(use-package evil-goggles
  :demand t
  :init
  (setopt evil-goggles-enable-paste nil)
  :config
  (evil-goggles-mode +1)
  (evil-goggles-use-diff-faces)
  (setopt evil-goggles-duration 0.15))


(use-package evil-indent-plus
  :after evil
  :config
  (define-key evil-inner-text-objects-map "i" 'evil-indent-plus-i-indent)
  (define-key evil-outer-text-objects-map "i" 'evil-indent-plus-a-indent)
  (define-key evil-inner-text-objects-map "I" 'evil-indent-plus-i-indent-up)
  (define-key evil-outer-text-objects-map "I" 'evil-indent-plus-a-indent-up)
  (define-key evil-inner-text-objects-map "J" 'evil-indent-plus-i-indent-up-down)
  (define-key evil-outer-text-objects-map "J" 'evil-indent-plus-a-indent-up-down))


(use-package evil-lion
  :demand t
  :config
  (evil-lion-mode +1))


(use-package evil-nerd-commenter
  :commands (evilnc-comment-operator evilnc-inner-comment evilnc-outer-commenter)
  :bind ([remap comment-line] . evilnc-comment-or-uncomment-lines)
  :init
  (with-eval-after-load 'evil
    (keymap-set evil-normal-state-map "g c" #'evilnc-comment-operator)
    (keymap-set evil-visual-state-map "g c" #'evilnc-comment-operator)))


(use-package evil-owl
  :demand t
  :config
  (evil-owl-mode +1)
  (setopt evil-owl-max-string-length 100)
  (setopt evil-owl-idle-delay 0.3)
  (setopt evil-owl-local-mark-format " %m: [l: %-5l, c: %-5c]\n    %s")
  (setopt evil-owl-global-mark-format " %m: [l: %-5l, c: %-5c] %b\n    %s")
  (add-to-list 'display-buffer-alist
               '("*evil-owl*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.3))))


(use-package evil-snipe
  :demand t
  :config
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1)
  (setq evil-snipe-smart-case t
        evil-snipe-scope 'line
        evil-snipe-repeat-scope 'visible
        evil-snipe-char-fold t))


(use-package evil-surround
  :demand t
  :config
  (global-evil-surround-mode +1)
  (with-eval-after-load 'evil
    (keymap-set evil-visual-state-map "S" #'evil-surround-region)
    (keymap-set evil-operator-state-map "s" #'evil-surround-edit)
    (keymap-set evil-operator-state-map "o" #'evil-Surround-edit)))


(use-package evil-textobj-anyblock
  :after evil
  :config
  (setq evil-textobj-anyblock-blocks
        '(("(" . ")")
          ("{" . "}")
          ("\\[" . "\\]")
          ("<" . ">"))))


(use-package evil-textobj-tree-sitter
  :after evil
  :config
  (define-key evil-outer-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.outer"))
  (define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner"))

  ;; Goto start of next function
  (define-key evil-normal-state-map
              (kbd "]f")
              (lambda ()
                (interactive)
                (evil-textobj-tree-sitter-goto-textobj "function.outer")))

  ;; Goto start of previous function
  (define-key evil-normal-state-map
              (kbd "[f")
              (lambda ()
                (interactive)
                (evil-textobj-tree-sitter-goto-textobj "function.outer" t)))

  ;; Goto end of next function
  (define-key evil-normal-state-map
              (kbd "]F")
              (lambda ()
                (interactive)
                (evil-textobj-tree-sitter-goto-textobj "function.outer" nil t)))

  ;; Goto end of previous function
  (define-key evil-normal-state-map
              (kbd "[F")
              (lambda ()
                (interactive)
                (evil-textobj-tree-sitter-goto-textobj "function.outer" t t))))


(use-package evil-visualstar
  :after evil
  :config
  (evil-define-key* 'visual 'global
    "*" #'evil-visualstar/begin-search-forward
    "#" #'evil-visualstar/begin-search-backward))



(provide 'herbsi-evil)
;;; herbsi-evil.el ends here
