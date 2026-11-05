;;; herbsi-git.el --- Magit configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


;;;; `diff-mode'

(use-feature diff-mode
  :defer t
  :config
  (setopt diff-advance-after-apply-hunk t)
  (setopt diff-default-read-only t)
  (setopt diff-font-lock-syntax 'hunk-also)
  (setopt diff-update-on-the-fly t))


;;;; `ediff'

(use-feature ediff
  :defer t
  :init
  (setopt ediff-split-window-function 'split-window-horizontally)
  (setopt ediff-window-setup-function 'ediff-setup-windows-plain)
  :config
  (setopt ediff-keep-variants nil)
  (setopt ediff-make-buffers-readonly-at-startup nil)
  (setopt ediff-merge-revisions-with-ancestor t)
  (setopt ediff-show-clashes-only t)

  (with-eval-after-load 'outline
    (add-hook 'ediff-prepare-buffer-hook #'outline-show-all)))


;;;; `project'

(use-feature project
  :config
  (setopt project-list-file (expand-file-name "projects" herbsi-state-dir))
  (setopt project-vc-extra-root-markers '(".project"))
  (setopt project-key-prompt-style t)
  (setopt project-switch-commands
	      '((project-find-file "Find file" ?f)
	        (project-find-regexp "Find regexp" ?r)
	        (project-dired "Dired" ?j)
	        (keyboard-quit "Quit" ?q))))


;;;; `vc'

(use-feature vc
  :config
  (setopt vc-follow-symlinks t)
  (setopt vc-handled-backends '(Git))
  (setopt vc-find-revision-no-save t))


(use-feature vc-annotate
  :after vc
  :config
  (setopt vc-annotate-display-mode 'scale))


(use-package vc-jj
  :after vc)



(provide 'herbsi-git)
;;; herbsi-git.el ends here
