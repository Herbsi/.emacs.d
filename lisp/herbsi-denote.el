;;; herbsi-denote.el --- denote.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-package denote
  :hook (text-mode-hook . denote-fontify-links-mode-maybe)
  :hook (dired-mode-hook . denote-dired-mode)
  :config
  (setopt denote-file-type 'text)
  (setopt denote-directory org-directory)
  (setopt denote-dired-directories `(,denote-directory ,(expand-file-name "~/Resources/") ,(expand-file-name "~/Archive/")))
  (setopt denote-dired-directories-include-subdirectories t)
  (setopt denote-excluded-directories-regexp "Finance")

  (with-eval-after-load 'org
    (setopt denote-known-keywords (cl-remove-if-not #'stringp (mapcar #'car org-tag-alist))))
  (setopt denote-infer-keywords nil)
  (setopt denote-sort-keywords t)

  ;; Possible values: title keywords file-type date subdirectory templates signature
  (setopt denote-prompts '(title keywords file-type subdirectory))
  (defun denote-date-signature ()
    "Create note while prompting for a date and signature.

This is equivalent to calling `denote' when `denote-prompts' is
set to '(title keywords file-type subdirectory date signature)."
    (declare (interactive-only t))
    (interactive)
    (let ((denote-prompts '(title keywords file-type subdirectory date signature)))
      (call-interactively #'denote)))
  (setopt denote-file-name-letter-casing
	      '((signature . verbatim)
	        (title . downcase)
	        (keywords . downcase)
	        (t . verbatim)))

  (setopt denote-rename-confirmations nil)
  (setopt denote-modules '(project xref))
  (setopt denote-backlinks-show-context t)
  (setopt denote-date-prompt-use-org-read-date t)
  (setopt denote-rename-buffer-format "%t")

  (denote-rename-buffer-mode +1)

  (with-eval-after-load 'org-capture
    (add-to-list 'org-capture-templates
		         '("n" "Denote" plain
		           (file denote-last-path)
		           #'denote-org-capture
		           :no-save t
		           :immediate-finish nil
		           :kill-buffer t
		           :jump-to-captured t))))



(provide 'herbsi-denote)
;;; herbsi-denote.el ends here
