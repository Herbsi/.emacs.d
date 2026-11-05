;;; herbsi-dired.el --- Dired -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-feature dired
  :hook (dired-mode-hook . hl-line-mode)
  :config
  (setopt dired-auto-revert-buffer #'dired-directory-changed-p) ; also see `dired-do-revert-buffer'
  (setopt dired-dwim-target t)
  (setopt dired-free-space nil)
  (setopt dired-listing-switches "-AGFhlv --group-directories-first --time-style=long-iso")
  (setopt dired-make-directory-clickable t)
  (setopt dired-mouse-drag-files t)
  (setopt dired-recursive-copies 'always)
  (setopt dired-recursive-deletes 'always))


(use-feature dired-aux
  :after (dired)
  :config
  (setopt dired-isearch-filenames 'dwim)
  (setopt dired-create-destination-dirs 'ask)
  (setopt dired-vc-rename-file t)
  (setopt dired-do-revert-buffer (lambda (dir) (not (file-remote-p dir))))
  (setopt dired-create-destination-dirs-on-trailing-dirsep t))


(use-feature dired-x
  :after (dired)
  :config
  (setopt dired-clean-up-buffers-too t)
  (setopt dired-clean-confirm-killing-deleted-buffers t)
  (setopt dired-x-hands-off-my-keys t)
  (setopt dired-bind-man nil)
  (setopt dired-bind-info nil))



(provide 'herbsi-dired)
;;; herbsi-dired.el ends here
