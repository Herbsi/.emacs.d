;;; herbsi-format.el --- Automatic formatting -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:


(use-package apheleia
  :demand t
  :config
  (apheleia-global-mode +1)
  (push '(air "air" "format" file) apheleia-formatters)
  ;; Change formatters
  (setf (alist-get 'bean-format apheleia-formatters)
        '("bean-format" input))
  (setf (alist-get 'stylua apheleia-formatters)
        '("stylua" "--search-parent-directories" "-"))
  ;; Change Major-Mode–Formatter associations
  (push '(ess-r-mode . air) apheleia-mode-alist)
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff)))



(provide 'herbsi-format)
;;; herbsi-format.el ends here
