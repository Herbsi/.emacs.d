;;; herbsi-python.el --- Python editing -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-feature python
  :defer t
  :config
  (setopt python-shell-interpreter "ipython")
  (setopt python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True")
  (setopt python-check-command "ruff check"))



(provide 'herbsi-python)
;;; herbsi-python.el ends here
