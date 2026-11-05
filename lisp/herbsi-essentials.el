;;; herbsi-essentials.el --- Essential configurations -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;;; General settings

(use-feature emacs
  :config
  (column-number-mode +1)
  (setopt backward-delete-char-untabify-method 'hungry)
  (setopt blink-matching-paren nil)
  (setopt confirm-kill-processes nil)
  (setopt delete-pair-blink-delay 0.1)
  (setopt epa-keys-select-method 'minibuffer)
  (setopt eval-expression-print-length nil)
  (setopt find-library-include-other-files nil)
  (setopt help-window-keep-selected t)
  (setopt help-window-select t)
  (setopt kill-do-not-save-duplicates t)
  (setopt mode-require-final-newline 'visit-save)
  (setopt next-error-recenter '(4)) ; center of the window
  (setopt remote-file-name-inhibit-auto-save t)
  (setopt remote-file-name-inhibit-delete-by-moving-to-trash t)
  (setopt save-interprogram-paste-before-kill t)
  (setopt scroll-error-top-bottom t)
  (setopt tramp-connection-timeout (* 60 10))
  (setopt tramp-persistency-file-name (expand-file-name "tramp" herbsi-state-dir))
  (setopt truncate-partial-width-windows nil)
  (setopt trusted-content '("~/Git/"))
  (setq-default buffer-file-coding-system 'utf-8-unix))


;;;; Comments

(use-feature emacs
  :config
  (setopt comment-empty-lines t)
  (setopt comment-fill-column nil)
  (setopt comment-multi-line t)
  (setopt comment-style 'multi-line)
  (setq-default comment-column 0))


;;;; recentf

(use-feature recentf
  :config
  (recentf-mode +1)
  (setopt recentf-auto-cleanup 'never)
  (setopt recentf-save-file (expand-file-name "recentf" herbsi-state-dir))
  (setopt recentf-exclude `("/tmp/" "/ssh:" ,(concat package-user-dir "/.*-autoloads\\.el\\'")))
  (setopt recentf-filename-handlers nil)
  (setopt recentf-initialize-file-name-history nil)
  (setopt recentf-keep nil)
  (setopt recentf-max-menu-items 25)
  (setopt recentf-max-saved-items 512)
  (setopt recentf-save-file-modes nil)
  (setopt recentf-show-file-shortcuts-flag nil))


;;;; Mouse & scrolling

(use-feature mouse
  :config
  (setopt focus-follows-mouse t)
  (setopt mouse-autoselect-window t)
  (setq-default scroll-preserve-screen-position t))


;;;; Built-in bookmarking framework (bookmark.el)

(use-feature bookmark
  :hook (bookmark-bmenu-mode-hook . hl-line-mode)
  :config
  (setopt bookmark-default-file (expand-file-name "bookmarks" herbsi-state-dir))
  (setopt bookmark-fringe-mark nil) ; Emacs 29 to hide bookmark fringe icon
  (setopt bookmark-save-flag 1)) ; See: http://yummymelon.com/devnull/surprise-and-emacs-defaults.html)


;;;; Registers (registers.el)

(use-feature register
  :config
  (setopt register-preview-delay 0.8)
  (setopt register-preview-function #'register-preview-default)
  (with-eval-after-load 'savehist
    (add-to-list 'savehist-additional-variables 'register-alist)))


;;;; Auto revert mode

(use-feature autorevert
  :config
  (global-auto-revert-mode +1)
  (setopt auto-revert-verbose t))


;;;; Delete selection

(use-feature delsel
  :config
  (delete-selection-mode +1))


;;;; Tooltips (tooltip-mode)

(use-feature tooltip
  :config
  (tooltip-mode +1)
  (setopt tooltip-delay 0.5)
  (setopt tooltip-short-delay 0.5)
  (setopt x-gtk-use-system-tooltips nil)
  (setopt tooltip-frame-parameters '((name . "tooltip")
                                     (internal-border-width . 10)
                                     (border-width . 0)
                                     (no-special-glyphs . t))))


;;; Emacs server (allow emacsclient to connect to running session)

(use-feature server
  :defer 1
  :config
  ;; `server-ensure-secure-dir' rejects world-accessible auth dirs.
  (let ((auth-dir (expand-file-name "server/" user-emacs-directory)))
    (make-directory auth-dir 'parents)
    (set-file-modes auth-dir #o700))
  (setopt server-client-instructions nil)
  (setopt server-use-tcp t)
  (unless (server-running-p)
    (server-start)))


;;;; Mark ring and kill ring

(use-feature emacs
  :config
  (setopt kill-ring-max 1000)
  (setopt mark-ring-max 999)
  (setopt set-mark-command-repeat-pop t))


;;;; undo

(use-package undo-fu
  :demand t
  :config
  ;; Increase undo history limits to reduce likelihood of data loss
  (setopt undo-limit 400000)           ; 400kb (default is 160kb)
  (setopt undo-strong-limit 3000000)   ; 3mb   (default is 240kb)
  (setopt undo-outer-limit 48000000)   ; 48mb  (default is 24mb)
  (setopt undo-fu-allow-undo-in-region t)

  (define-minor-mode undo-fu-mode
    "Enables `undo-fu' for the current session."
    :keymap (let ((map (make-sparse-keymap)))
              (define-key map [remap undo] #'undo-fu-only-undo)
              (define-key map [remap redo] #'undo-fu-only-redo)
              (define-key map (kbd "C-_")     #'undo-fu-only-undo)
              (define-key map (kbd "M-_")     #'undo-fu-only-redo)
              (define-key map (kbd "C-M-_")   #'undo-fu-only-redo-all)
              (define-key map (kbd "C-x r u") #'undo-fu-session-save)
              (define-key map (kbd "C-x r U") #'undo-fu-session-recover)
              map)
    :init-value nil
    :global t)

  (undo-fu-mode +1))


(use-package undo-fu-session
  :hook (undo-fu-mode-hook . global-undo-fu-session-mode)
  :config
  (setopt undo-fu-session-directory (expand-file-name "undo-fu-session/" herbsi-state-dir))
  (setopt undo-fu-session-incompatible-files '("\\.gpg$" "/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))

  (when (executable-find "zstd")
    ;; There are other algorithms available, but zstd is the fastest, and speed
    ;; is our priority within Emacs
    (setq undo-fu-session-compression 'zst)))


(use-package vundo
  :defer 1
  :config
  (setopt vundo-glyph-alist vundo-unicode-symbols
          vundo-compact-display t)
  (with-eval-after-load 'pulsar
    (add-hook 'vundo-post-exit-hook #'pulsar-pulse-line-green)))


;;;; helpful

(use-package helpful
  :bind (([remap describe-function] . helpful-function)
         ([remap describe-command] . helpful-command)
         ([remap describe-key] . helpful-key)
         ([remap describe-variable] . helpful-variable)))


;;;; `save-place'

(use-feature saveplace
  :config
  (save-place-mode +1)
  (setopt save-place-file (expand-file-name "places" herbsi-state-dir))
  (setopt save-place-limit 1024))


;;;; `which-key.el'

(use-package which-key
  :demand t
  :config
  (which-key-mode +1)
  (setopt which-key-add-column-padding 1)
  (setopt which-key-idle-delay 0.5)
  (setopt which-key-idle-secondary-delay 0.25)
  (setopt which-key-max-description-length 40)
  (setopt which-key-max-display-columns 3)
  (setopt which-key-prefix-prefix "... ")
  (setopt which-key-separator "  "))


;;;; `transient'

(setopt transient-history-file (expand-file-name "transient/history.el" herbsi-state-dir)
        transient-values-file (expand-file-name "transient/values.el" herbsi-state-dir)
        transient-levels-file (expand-file-name "transient/levels.el" herbsi-state-dir))


;;;; `authinfo'

(add-to-list 'auth-sources (expand-file-name "authinfo" herbsi-state-dir))



(provide 'herbsi-essentials)
;;; herbsi-essentials.el ends here
