;;; herbsi-ghostel.el --- Terminal emulator powered by libghostty -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-package ghostel
  :bind ("C-x C-m" . ghostel)
  :config
  (ghostel-status-indicator-mode +1))


(use-feature ghostel-project
  :after (ghostel project)
  :bind (:map project-prefix-map
              ("m" . ghostel-project)
              ("M" . ghostel-project-list-buffers))
  :config
  (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
  (add-to-list 'project-switch-commands '(ghostel-project-list-buffers "Ghostel buffers") t)
  ;; Have `project-kill-buffers' kill the project's terminals too
  (add-to-list 'project-kill-buffer-conditions '(derived-mode . ghostel-mode)))


(use-feature ghostel-compile
  :after ghostel
  :config
  (ghostel-compile-global-mode +1))


(use-feature ghostel-comint
  :after ghostel
  :config
  (ghostel-comint-global-mode +1))



(provide 'herbsi-ghostel)
;;; herbsi-ghostel.el ends here
