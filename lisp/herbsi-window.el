;;; herbsi-window.el - Window management -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:


;;;; `uniquify' (unique names for buffers)

(use-feature uniquify
  :config
  (setopt uniquify-buffer-name-style 'forward)
  (setopt uniquify-strip-common-suffix t)
  (setopt uniquify-after-kill-buffer-p t))


;;;; `hl-line'

(use-feature hl-line
  :config
  (setopt hl-line-sticky-flag nil)
  (setopt hl-line-overlay-priority -50))


;;;; Line numbers

(use-feature display-line-numbers
  :config
  (setq-default display-line-numbers-type nil)
  (setq-default display-line-numbers-widen t) ; Use absolute numbers in narrowed buffers
  (setopt display-line-numbers-major-tick 0) ; Those two variables were introduced in Emacs 27.1
  (setopt display-line-numbers-minor-tick 0))


;;;; `window', `display-buffer-alist', and related

(use-feature window
  :demand t
  :config
  (setopt window-combination-resize t)
  (setopt even-window-sizes 'height-only)
  (setopt window-sides-vertical nil)
  (setopt switch-to-buffer-in-dedicated-window 'pop); switch-to-buffer runs pop-to-buffer-same-window instead
  (setopt switch-to-buffer-obey-display-actions t)
  (setopt split-height-threshold 80)
  (setopt split-width-threshold 125)
  (setopt window-min-height 3)
  (setopt window-min-width 30))


;;;; Header line context of symbol/heading (breadcrumb.el)

(use-package breadcrumb
  :demand t
  :config
  (breadcrumb-mode +1)
  (setopt breadcrumb-imenu-crumb-separator " > ")
  (setopt breadcrumb-imenu-max-length 1.0)
  (setopt breadcrumb-project-crumb-separator "/")
  (setopt breadcrumb-project-max-length 0.5))


;;;; ace-window.el

(use-package ace-window
  :bind (([remap other-window] . ace-window))
  :config
  (setopt aw-background nil)
  (setopt aw-dispatch-always nil)
  (setopt aw-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n ?s))
  (setopt aw-scope 'frame))



(provide 'herbsi-window)
;;; herbsi-window.el ends here
