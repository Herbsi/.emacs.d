;;; early-init.el --- Emacs 27+ pre-initialisation config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq frame-resize-pixelwise t
      frame-inhibit-implied-resize t
      frame-title-format '("%b")
      ring-bell-function 'ignore
      use-dialog-box t
      use-file-dialog nil
      use-short-answers t
      inhibit-splash-screen t
      inhibit-startup-screen t
      inhibit-x-resources t
      inhibit-startup-echo-area-message user-login-name
      inhibit-startup-buffer-menu t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(add-hook 'elpaca-after-init-hook (lambda ()
                                    (setq default-frame-alist `((horizontal-scroll-bars . nil)
                                                                (menu-bar-lines . 0)
                                                                (tool-bar-lines . 0)
                                                                (vertical-scroll-bars . nil)
                                                                (scroll-bar-width . 12)
                                                                (undecorated . t)
                                                                (border-width . 0)))))

;; Temporarily increase the garbage collection threshold.  These
;; changes help shave off about half a second of startup time.  The
;; `most-positive-fixnum' is DANGEROUS AS A PERMANENT VALUE.  See the
;; `emacs-startup-hook' a few lines below for what I actually use.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

;; Preserve the default handlers so they can be restored after init.
(defvar early-init-file-name-handler-alist file-name-handler-alist)

(setq file-name-handler-alist nil
      vc-handled-backends nil)

(add-hook 'elpaca-after-init-hook
          (lambda ()
            (setq gc-cons-threshold (* 100 100 8)
                  gc-cons-percentage 0.1
                  file-name-handler-alist early-init-file-name-handler-alist)))

;;; Misc

(setq package-enable-at-startup nil)

(set-language-environment "UTF-8")

;; `set-language-environment' sets default-input-method, which is unwanted.
(setq default-input-method nil)



;;; early-init.el ends here
