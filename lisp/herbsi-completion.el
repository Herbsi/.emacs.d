;;; herbsi-completion.el --- Completion -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;; Minibuffer configurations

(use-feature minibuffer
  :config
  ;; A list of known completion categories:
  ;;
  ;; - `bookmark'
  ;; - `buffer'
  ;; - `charset'
  ;; - `coding-system'
  ;; - `color'
  ;; - `command' (e.g. `M-x')
  ;; - `customize-group'
  ;; - `environment-variable'
  ;; - `expression'
  ;; - `face'
  ;; - `file'
  ;; - `function' (the `describe-function' command bound to `C-h f')
  ;; - `info-menu'
  ;; - `imenu'
  ;; - `input-method'
  ;; - `kill-ring'
  ;; - `library'
  ;; - `minor-mode'
  ;; - `multi-category'
  ;; - `package'
  ;; - `project-file'
  ;; - `symbol' (the `describe-symbol' command bound to `C-h o')
  ;; - `theme'
  ;; - `unicode-name' (the `insert-char' command bound to `C-x 8 RET')
  ;; - `variable' (the `describe-variable' command bound to `C-h v')
  ;; - `consult-grep'
  ;; - `consult-isearch'
  ;; - `consult-kmacro'
  ;; - `consult-location'
  ;; - `embark-keybinding'
  ;;
  (setq completion-category-overrides
        '((file (styles . (basic partial-completion)))
          (bookmark (styles . (basic substring)))
          (library (styles . (basic substring)))
          (embark-keybinding (styles . (basic substring)))
          (imenu (styles . (basic substring orderless)))
          (consult-location (styles . (basic substring orderless)))
          (kill-ring (styles . (emacs22 orderless)))
          (eglot (styles . (emacs22 substring orderless)))))

  (setq completion-styles '(basic substring orderless)) ; use `setq' because of warning
  (setopt completion-category-defaults nil))


(setopt read-extended-command-predicate #'command-completion-default-include-p)
(setopt completion-ignore-case t) ; Ignore letter casing
(setopt read-buffer-completion-ignore-case t)
(setopt read-file-name-completion-ignore-case t)
(setq-default case-fold-search t) ; For general regexp


;; Recursive minibuffers
(use-feature mb-depth
  :config
  (minibuffer-depth-indicate-mode +1)
  (setopt enable-recursive-minibuffers t)
  (setopt read-minibuffer-restore-windows nil)) ; Emacs 28


(use-feature minibuf-eldef
  :config
  (minibuffer-electric-default-mode +1)
  (setopt minibuffer-default-prompt-format " [%s]")) ; Emacs 29


(use-feature rfn-eshadow
  :hook (minibuffer-setup-hook . cursor-intangible-mode)
  :config
  ;; Not everything here comes from rfn-eshadow.el, but this is fine.

  (setopt resize-mini-windows 'grow-only)
  (setopt read-answer-short t) ; also check `use-short-answers' for Emacs28
  (setopt echo-keystrokes 0.25)

  ;; Do not allow the cursor to move inside the minibuffer prompt.  I
  ;; got this from the documentation of Daniel Mendler's Vertico
  ;; package: <https://github.com/minad/vertico>.
  (setopt minibuffer-prompt-properties
          '(read-only t cursor-intangible t face minibuffer-prompt))

  ;; Add prompt indicator to `completing-read-multiple'.  We display
  ;; [`completing-read-multiple': <separator>], e.g.,
  ;; [`completing-read-multiple': ,] if the separator is a comma.  This
  ;; is adapted from the README of the `vertico' package by Daniel
  ;; Mendler.  I made some small tweaks to propertize the segments of
  ;; the prompt.
  (defun crm-indicator (args)
    (cons (format "[`completing-read-multiple': %s]  %s"
                  (propertize
                   (replace-regexp-in-string
                    "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                    crm-separator)
                   'face 'error)
                  (car args))
          (cdr args)))

  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  (file-name-shadow-mode 1))


;;;; savehist.el

;; Persist history over Emacs restarts. Vertico sorts by history position.

(use-feature savehist
  :config
  (setopt history-delete-duplicates t)
  (setopt history-length 999)
  (setopt savehist-file (expand-file-name "savehist" herbsi-state-dir))
  (setopt savehist-save-minibuffer-history t)
  (add-to-list 'savehist-additional-variables 'kill-ring)
  (add-to-list 'savehist-additional-variables 'compile-history)
  (savehist-mode +1))


;;;; `dabbrev'

(use-feature dabbrev
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  :config
  (setopt dabbrev-abbrev-char-regexp "\\sw\\|\\s_")
  (setopt dabbrev-abbrev-skip-leading-regexp "[$*/=~']")
  (setopt dabbrev-backward-only nil)
  (setopt dabbrev-case-distinction 'case-replace)
  (setopt dabbrev-case-fold-search nil)
  (setopt dabbrev-case-replace 'case-replace)
  (setopt dabbrev-check-other-buffers t)
  (setopt dabbrev-eliminate-newlines t)
  (setopt dabbrev-ignored-buffer-modes '(archive-mode image-mode docview-mode pdf-view-mode))
  (setopt dabbrev-upcase-means-case-search t)
  (add-to-list 'dabbrev-ignored-buffer-modes 'authinfo-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode)
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\.\\(?:pdf\\|jpe?g\\|png\\)\\'"))


;;;; `abbrev'

(use-feature abbrev
  :hook ((text-mode-hook prog-mode-hook git-commit-mode-hook) . abbrev-mode)
  :config
  (setopt abbrev-file-name (expand-file-name "abbrevs" herbsi-state-dir))
  (setopt only-global-abbrevs nil))


;;;; snippets --- My elves type for me, so I don't have to

(use-package tempel
  :demand t
  :bind (("M-+" . tempel-complete)
         ("M-*" . tempel-insert))
  :init
  ;; Try exact template expansion before other Capfs.
  (defun herbsi-tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-expand completion-at-point-functions)))

  (add-hook 'conf-mode-hook #'herbsi-tempel-setup-capf)
  (add-hook 'prog-mode-hook #'herbsi-tempel-setup-capf)
  (add-hook 'text-mode-hook #'herbsi-tempel-setup-capf)
  :config
  (defun herbsi-tempel-private-templates ()
    "Return decrypted private templates for the current buffer."
    (when-let ((data (herbsi-age-read "templates")))
      (tempel--filter-templates (tempel--file-prepare data))))

  (add-hook 'tempel-template-sources #'herbsi-tempel-private-templates))


(use-package uuidgen
  :config
  (setopt uuidgen-suppress-network-info-warnings t))


;;;; orderless.el

(use-package orderless
  :config
  (setopt orderless-matching-styles '(orderless-literal orderless-prefixes orderless-regexp))
  (setopt orderless-component-separator "[ &]"))


;;;; Corfu (in-buffer completion popup)

(use-package corfu
  :ensure (:files (:defaults "extensions/*"))
  ;; TODO bind `corfu'
  :demand t
  :config
  (global-corfu-mode +1)
  (setopt corfu-preview-current nil)
  (setopt corfu-separator ?\s) ; Orderless field separator
  (setopt corfu-min-width 20)

  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p vertico--input)
                (eq (current-local-map) read-passwd-map))
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1))


;; Corfu Extensions

(use-feature corfu-history
  :after (savehist corfu)
  :hook (corfu-mode-hook . corfu-history-mode)
  :config
  (add-to-list 'savehist-additional-variables 'corfu-history))


(use-feature corfu-popupinfo
  :after (corfu)
  :hook (corfu-mode-hook . corfu-popupinfo-mode)
  :config
  (setopt corfu-popupinfo-delay '(1.25 . 0.5)))


;;;; Enhanced completion-at-point (cape.el)

(use-package cape
  :after (corfu)
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev t)
  (add-to-list 'completion-at-point-functions #'cape-file t)
  (add-to-list 'completion-at-point-functions #'cape-keyword t)
  (add-to-list 'completion-at-point-functions #'cape-dict t)
  :config
  ;; Enhances speed on large projects, for which many buffers may be open.
  (setopt text-mode-ispell-word-completion nil)
  (setopt cape-dabbrev-check-other-buffers t))


;;; Enhanced minibuffer commands (consult.el)

(use-package consult
  :bind (([remap bookmark-jump] . consult-bookmark)
         ([remap goto-line] . consult-line)
         ([remap imenu] . consult-imenu)
         ([remap Info-search] . consult-info)
         ([remap locate] . consult-locate)
         ([remap load-theme] . consult-theme)
         ([remap man] . consult-man)
         ([remap project-switch-to-buffer] . consult-project-buffer)
         ([remap switch-to-buffer] . consult-buffer)
         ([remap switch-to-buffer-other-window] . consult-buffer-other-window)
         ([remap switch-to-buffer-other-frame] . consult-buffer-other-frame)
         ([remap recentf-open-files] . consult-recent-file)
         ([remap yank-pop] . consult-yank-pop))
  :config
  (setopt consult-narrow-key "<")
  (setopt consult-line-numbers-widen t)
  (setopt consult-async-min-input 3)
  (setopt consult-async-refresh-delay  0.15)
  (setopt consult-async-input-throttle 0.2)
  (setopt consult-async-input-debounce 0.1)
  (add-to-list 'consult-mode-histories '(vc-git-log-edit-mode . log-edit-comment-ring))

  ;; Disable preview
  (setopt consult-preview-excluded-buffers "\\`.*")
  (setopt consult-preview-excluded-files '("\\`.*"))

  (with-eval-after-load 'pulsar
    (setopt consult-after-jump-hook nil) ; reset it to avoid conflicts
    (dolist (fn '(pulsar-recenter-top pulsar-reveal-entry))
      (add-hook 'consult-after-jump-hook fn))))


;;;; Consult extensions

(use-feature consult-imenu
  :after (consult imenu)
  :hook (prog-mode-hook . (lambda () (setq-local imenu-sort-function #'imenu--sort-by-name)))
  :config
  (setq-default imenu-auto-rescan t))


(use-feature consult-org
  :after (consult))


;;;; Extended minibuffer actions and more (embark.el)

(use-package embark
  :defer 1
  :bind (([remap describe-bindings] . embark-bindings)
         ("C-;" . embark-act))
  :config
  (setopt which-key-use-C-h-commands nil)
  (setopt prefix-help-command #'embark-prefix-help-command)

  (keymap-set minibuffer-local-map "C-;" #'embark-act)
  (keymap-set minibuffer-local-map "C-c C-;" #'embark-export)
  (keymap-set minibuffer-local-map "C-c C-l" #'embark-collect))


(use-package embark-consult
  :after (embark consult))


;;;; Detailed completion annotations (marginalia.el)

(use-package marginalia
  :bind (:map minibuffer-local-map ("M-A" . marginalia-cycle))
  :defer 1
  :config
  (marginalia-mode +1)
  (setopt marginalia-max-relative-age 0)) ; absolute time


;;;; Vertical completion layout (vertico.el)

(use-package vertico
  :ensure (:files (:defaults "extensions/*"))
  :demand t
  :config
  (vertico-mode +1)
  
  ;; Different scroll margin
  (setopt vertico-scroll-margin 0)

  ;; Show more candidates
  (setopt vertico-count 5)

  ;; Don't grow or shrink the Vertico minibuffer
  (setopt vertico-resize nil)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setopt vertico-cycle t)

  (setopt vertico-sort-function #'vertico-sort-history-length-alpha)
  ;; Sort directories before files
  (defun sort-directories-first (files)
    (setq files (vertico-sort-alpha files))
    (nconc (seq-filter (lambda (x) (string-suffix-p "/" x)) files)
           (seq-remove (lambda (x) (string-suffix-p "/" x)) files))))


;; Vertico extensions

(use-feature vertico-directory
  :after (vertico)
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names: when you are in a sub-directory and use,
  ;; say, `find-file' to go to your home '~/' or root '/', Vertico will
  ;; clear the old path to keep only your current input.  Requires
  ;; `file-name-shadow-mode', enabled earlier in this file.
  :hook (rfn-eshadow-update-overlay-hook . vertico-directory-tidy))


(use-feature vertico-multiform
  :after (vertico)
  :config
  (setq vertico-multiform-categories '((file grid (vertico-sort-function . sort-directories-first))
                                       (consult-grep buffer)))
  (setq vertico-multiform-commands '((consult-imenu buffer indexed)
                                     (consult-outline buffer ,(lambda (_) (text-scale-set -1)))))
  ;; Enable vertico-multiform
  (vertico-multiform-mode +1))



(provide 'herbsi-completion)
;;; herbsi-completion.el ends here


