;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into a number of other
;; files.

;;; Code:

(setq make-backup-files nil)
(setq create-lockfiles nil)

;; Make native compilation silent and prune its cache.
(when (native-comp-available-p)
  (setq native-comp-async-report-warnings-errors 'silent) ; Emacs 28 with native compilation
  (setq native-compile-prune-cache t)) ; Emacs 29


;; Mutable state lives under XDG_STATE_HOME, keeping the repo clean.
(defconst herbsi-state-dir
  (expand-file-name "emacs/" (getenv "XDG_STATE_HOME")))


;; Variables configured via the interactive `customize' interface
(setq custom-file (expand-file-name "custom.el" herbsi-state-dir))


;; Variables configured via the interactive `customize' interface
(add-hook 'elpaca-after-init-hook
          (lambda () (when (file-exists-p custom-file)
                       (load custom-file 'noerror))))


;; Enable certain commands and disable others
;; Enable these
(mapc
 (lambda (command)
   (put command 'disabled nil))
 '(narrow-to-region narrow-to-page upcase-region downcase-region))

;; And disable these
(mapc
 (lambda (command)
   (put command 'disabled t))
 '(eshell project-eshell overwrite-mode iconify-frame diary))


;; Always start with *scratch*
(setq initial-buffer-choice t)
(setq initial-scratch-message "")

(add-to-list 'load-path (locate-user-emacs-file "lisp"))

;;;; Packages

(setq package-vc-register-as-project nil)

(add-hook 'package-menu-mode-hook #'hl-line-mode)

(require 'herbsi-elpaca)
(require 'herbsi-themes)
(require 'herbsi-age)
(require 'herbsi-evil)
(require 'herbsi-essentials)
(require 'herbsi-completion)
(require 'herbsi-format)
(require 'herbsi-search)
(require 'herbsi-environment)
(require 'herbsi-dired)
(require 'herbsi-window)
(require 'herbsi-git)
(require 'herbsi-org)
(require 'herbsi-beancount)
(require 'herbsi-denote)
(require 'herbsi-langs)
(require 'herbsi-eglot)
(require 'herbsi-ess)
(require 'herbsi-python)
(require 'herbsi-scheme)
(require 'herbsi-typst)



;;; END OF INIT FILE
(provide 'init)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
;;; init.el ends here
