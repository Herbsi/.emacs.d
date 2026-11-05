;;; herbsi-search.el --- Search -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;; Isearch, occur, grep, and extras

(use-feature isearch
  :demand t
  :config
  (setopt isearch-lax-whitespace t)
  (setopt isearch-lazy-count t)
  (setopt isearch-lazy-highlight t)
  (setopt isearch-regexp-lax-whitespace nil)
  (setopt isearch-repeat-on-direction-change t)
  (setopt isearch-wrap-pause t) ; `no-ding' makes keyboard macros never quit
  (setopt lazy-count-prefix-format "(%s/%s) ")
  (setopt lazy-count-suffix-format nil)
  (setopt lazy-highlight-initial-delay 0.5)
  (setopt lazy-highlight-no-delay-length 4)
  (setopt search-highlight t)
  (setopt search-whitespace-regexp ".*?"))


(use-feature occur
  :hook (occur-mode-hook . hl-line-mode)
  :config
  (setopt list-matching-lines-jump-to-current-line nil)) ; do not jump to current line in `*occur*' buffers (add-hook 'occur-mode-hook #'hl-line-mode)


;;;; grep and xref

(use-feature xref
  :config
  ;; All those have been changed for Emacs 28
  (setopt xref-show-definitions-function #'xref-show-definitions-completing-read) ; for M-.
  (setopt xref-show-xrefs-function #'xref-show-definitions-buffer) ; for grep and the like
  (setopt xref-file-name-display 'project-relative))


(use-feature grep
  :commands (grep lgrep rgrep)
  :config
  (setopt grep-save-buffers nil)
  (setopt grep-use-headings t) ; Emacs 30

  (setopt grep-program "rg")
  (setopt grep-template "rg -nH --null -e <R> <F>")
  (setopt xref-search-program 'ripgrep))


(use-package wgrep
  :after (grep)
  :bind (:map grep-mode-map
	          ("e" . wgrep-change-to-wgrep-mode)
	          ("C-x C-q" . wgrep-change-to-wgrep-mode)
	          ("C-c C-c" . wgrep-finish-edit))
  :config
  (setopt wgrep-auto-save-buffer t)
  (setopt wgrep-change-readonly-file t))


;;;; Fast navigation (avy.el)

(use-package avy
  :bind ("C-=" . avy-goto-char-2)
  :config
  (setopt avy-style 'pre)
  (setopt avy-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n ?s)) ; Dvorak layout
  (setopt avy-background t)
  (setopt avy-highlight-first t))



(provide 'herbsi-search)
;;; herbsi-search.el ends here
