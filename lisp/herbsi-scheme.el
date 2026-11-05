;;; herbsi-scheme.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-feature scheme
  :defer t)


(use-package geiser
  :init
  (setopt geiser-autodoc-identifier-format "%s -> %s"
          geiser-repl-per-project t
          geiser-repl-history-filename (expand-file-name "geiser-history" herbsi-state-dir))
  (setopt geiser-repl-skip-version-check-p t))


(use-package geiser-chez
  :after geiser
  :init
  (setopt geiser-default-implementation 'chez))


(provide 'herbsi-scheme)
;;; herbsi-scheme.el ends here
