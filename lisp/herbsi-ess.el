;;; herbsi-ess --- Emacs Speaks Statistics -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-package ess-r-mode
  :ensure (ess)
  :defer t
  :config
  (setopt ess-use-company nil)
  (setopt ess-use-ido nil)
  (setopt ess-nuke-trailing-whitespace-p t)
  (setopt ess-style 'DEFAULT)
  (ess-set-style 'DEFAULT)
  (setopt ess-history-directory (expand-file-name "ess-history/" herbsi-state-dir))
  (setopt inferior-R-args "--silent --no-save")
  (add-to-list 'ess-r-flymake-linters "indentation_linter = NULL"))



(provide 'herbsi-ess)
;;; herbsi-ess.el ends here
