;;; herbsi-typst.el --- Typst support -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;;; typst

(use-package typst-ts-mode
  :after treesit
  :mode ("\\.typ" . typst-ts-mode))



(provide 'herbsi-typst)
;;; herbsi-typst.el ends here
