;;; herbsi-org.el --- Org Mode - Your life in plain text -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


;;;; Org-mode (personal information manager)

(use-package org
  :init
  (setopt org-directory (expand-file-name "~/Org/"))
  (setopt org-list-allow-alphabetical t)
  (setopt org-imenu-depth 7)

  (add-to-list 'safe-local-variable-values '(org-hide-leading-stars . t))
  (add-to-list 'safe-local-variable-values '(org-hide-macro-markers . t))
  :bind (:map org-mode-map
	          ("C-'" . nil)
	          ("C-," . nil)
	          ("M-;" . nil)
	          ("<C-return>" . nil)
	          ("<C-S-return>" . nil)
	          ("C-M-S-<right>" . nil)
	          ("C-M-S-<left>" . nil)
	          ("C-c ;" . nil))
  :config
  (setopt org-M-RET-may-split-line '((default . nil)))
  (setopt org-adapt-indentation nil)
  (setopt org-blank-before-new-entry '((heading . t) (plain-list-item . auto)))
  (setopt org-cycle-separator-lines 0) ; don’t leave empty lines between subtrees in collapsed view
  (setopt org-default-priority ?A)
  (setopt org-ellipsis "⮧")
  (setopt org-fold-catch-invisible-edits 'show-and-error)
  (setopt org-fontify-quote-and-verse-blocks t)
  (setopt org-fontify-whole-block-delimiter-line t)
  (setopt org-hide-emphasis-markers nil) ; hide org markup syntax
  (setopt org-hide-leading-stars nil)
  (setopt org-hide-macro-markers nil)
  (setopt org-highest-priority ?A)
  (setopt org-insert-heading-respect-content t)
  (setopt org-loop-over-headlines-in-active-region 'start-level)
  (setopt org-lowest-priority ?C)
  (setopt org-pretty-entities t)
  (setopt org-priority-faces nil)
  (setopt org-return-follows-link nil)
  (setopt org-special-ctrl-a/e nil)
  (setopt org-special-ctrl-k nil)
  (setopt org-track-ordered-property-with-tag t)
  (setopt org-use-sub-superscripts '{})

  ;;;;; archive
  (setopt org-archive-location (expand-file-name ".archive/%s::" org-directory))
  (setopt org-archive-subtree-save-file-p t)  ; Save target buffer after archiving a node.

  ;;;;; refile
  (setopt org-refile-targets
	      '((org-agenda-files . (:maxlevel . 2))
	        (nil . (:maxlevel . 2))))
  (setopt org-refile-use-outline-path t)
  (setopt org-refile-allow-creating-parent-nodes 'confirm)
  (setopt org-refile-use-cache t)

  ;;;;; export
  (setopt org-export-in-background t)

  ;;;;; tags
  (setopt org-tag-alist (car (herbsi-age-read "tags")))

  (setopt org-auto-align-tags nil)

  ;;;;; links
  (setopt org-link-context-for-files t)
  (setopt org-link-keep-stored-after-insertion nil)
  (setopt org-id-link-to-org-use-id t)

  ;;;;; capture
  (setopt org-capture-templates
	      '(("b" "Bookmark" entry (file "19990206T020000--bookmarks.org")
	         "* %? %^g\n:PROPERTIES:\n:CREATED: %u\n:END:\n\n" :empty-lines 1)
	        ("w" "Working Memory" plain (file "19990206T010000--working-memory.txt")
	         "%u: %?\n\n" :empty-lines 1)))

  (with-eval-after-load 'pulsar
    (add-hook 'org-follow-link-hook #'pulsar-recenter-center)
    (add-hook 'org-follow-link-hook #'pulsar-reveal-entry)))


;;;; agenda

(use-feature org-agenda
  :after (org)
  :config
  ;;;;; Basic agenda setup
  (setopt org-default-notes-file (make-temp-file "emacs-org-notes-"))
  (setopt org-agenda-files `(,org-directory))
  (setopt org-agenda-span 'fortnight)
  (setopt org-agenda-start-on-weekday 1)  ; Monday
  (setopt org-agenda-confirm-kill t)
  (setopt org-agenda-show-all-dates t)
  (setopt org-agenda-show-outline-path nil)
  (setopt org-agenda-window-setup 'current-window)
  (setopt org-agenda-skip-comment-trees t)
  (setopt org-agenda-menu-show-matcher t)
  (setopt org-agenda-menu-two-columns nil)
  (setopt org-agenda-sticky nil)
  (setopt org-agenda-custom-commands-contexts nil)
  (setopt org-agenda-max-entries nil)
  (setopt org-agenda-max-todos nil)
  (setopt org-agenda-max-tags nil)
  (setopt org-agenda-max-effort nil)

  ;;;;; Agenda marks
  (setopt org-agenda-bulk-mark-char "#")
  (setopt org-agenda-persistent-marks nil)

  ;;;;; Agenda follow mode
  (setopt org-agenda-start-with-follow-mode nil)
  (setopt org-agenda-follow-indirect t)

  ;;;;; Agenda tagged items
  (setopt org-agenda-show-inherited-tags t)
  (setopt org-agenda-use-tag-inheritance
	      '(todo search agenda))
  (setopt org-agenda-hide-tags-regexp nil)
  (setopt org-agenda-remove-tags nil)
  (setopt org-agenda-tags-column -100)

  ;;;;; Pulsar
  (with-eval-after-load 'pulsar
    (add-hook 'org-agenda-after-show-hook #'pulsar-recenter-center)
    (add-hook 'org-agenda-after-show-hook #'pulsar-reveal-entry)))


;;;; ids

(use-feature org-id
  :after (org)
  :config
  (setopt org-id-locations-file (expand-file-name ".orgids" org-directory)))



(provide 'herbsi-org)
;;; herbsi-org.el ends here
