;;; herbsi-themes.el ---  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;; Theme setup and related

;;;; `modus-themes'

(use-package modus-themes
  :demand t
  :config
  (setopt modus-themes-bold-constructs t
          modus-themes-italic-constructs t
          modus-themes-disable-other-themes t
          modus-themes-mixed-fonts t
          modus-themes-variable-pitch-ui t))


;;;; `standard-themes'

(use-package standard-themes
  :config
  (setopt standard-themes-bold-constructs t
          standard-themes-italic-constructs t
          standard-themes-mixed-fonts t
          standard-themes-variable-pitch-ui t
          standard-themes-mode-line-accented nil
          standard-themes-fringes 'subtle
          standard-themes-links nil
          standard-themes-region nil
          standard-themes-prompts nil))

;;;; `ef-themes'

(use-package ef-themes
  :ensure t
  :init
  ;; This makes the Modus commands listed below consider only the Ef
  ;; themes.  For an alternative that includes Modus and all
  ;; derivative themes (like Ef), enable the
  ;; `modus-themes-include-derivatives-mode' instead.  The manual of
  ;; the Ef themes has a section that explains all the possibilities:
  ;;
  ;; - Evaluate `(info "(ef-themes) Working with other Modus themes or taking over Modus")'
  ;; - Visit <https://protesilaos.com/emacs/ef-themes#h:6585235a-5219-4f78-9dd5-6a64d87d1b6e>
  (ef-themes-take-over-modus-themes-mode 1)
  :config
  (modus-themes-load-theme 'ef-dark))

;;;; `pulsar'

(use-package pulsar
  :demand t
  :hook (next-error-hook . (pulsar-pulse-line pulsar-recenter-top pulsar-reveal-entry))
  :config
  (pulsar-global-mode +1)
  (setopt pulsar-pulse t
          pulsar-delay 0.055
          pulsar-iterations 10
          pulsar-face 'pulsar-magenta
          pulsar-highlight-face 'pulsar-cyan))


;;;; `lin'

(use-package lin
  :demand t
  :config
  (lin-global-mode +1)
  (setopt lin-face 'lin-magenta))


;;;; `fontaine'

(use-package fontaine
  :demand t
  :config
  (setq-default text-scale-remap-header-line t)
  (setopt fontaine-latest-state-file (expand-file-name "fontaine-latest-state.eld" herbsi-state-dir))
  (setopt fontaine-presets
          '((regular)
	        (t
             :default-family "Triplicate A Code"
             :default-weight regular
             :default-height 130
             :fixed-pitch-family nil ; falls back to :default-family
             :fixed-pitch-weight nil ; falls back to :default-weight
             :fixed-pitch-height 1.0
             :fixed-pitch-serif-family nil ; falls back to :default-family
             :fixed-pitch-serif-weight nil ; falls back to :default-weight
             :fixed-pitch-serif-height 1.0
             :variable-pitch-family "Triplicate A Poly"
             :variable-pitch-weight nil
             :variable-pitch-height 1.0
             :bold-family nil ; use whatever the underlying face has
             :bold-weight bold
             :italic-family nil
             :italic-slant italic
             :line-spacing nil)))
  (with-eval-after-load 'pulsar
    (add-hook 'fontaine-set-preset-hook #'pulsar-pulse-line))

  (fontaine-mode +1)
  ;; Set last preset or fall back to desired style from `fontaine-presets'.
  (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular)))

;;;; `cursory'

(use-package cursory
  :demand t
  :config
  (setopt cursory-latest-state-file (expand-file-name "cursory-latest-state.eld" herbsi-state-dir))
  (setopt cursory-presets '((box
                             :blink-cursor-interval 1.2)
                            (box-no-blink
                             :inherit box
                             :blink-cursor-mode -1)
                            (bar
                             :cursor-type (bar . 2)
                             :cursor-color error
                             :blink-cursor-interval 0.8)
                            (bar-no-blink
                             :inherit bar
                             :blink-cursor-mode -1)
                            (underscore
                             :cursor-color warning
                             :cursor-type (hbar . 3)
                             :blink-cursor-blinks 50)
                            (underscore-no-other-window
                             :inherit underscore
                             :cursor-in-non-selected-windows nil)
                            (underscore-thick
                             :inherit underscore
                             :cursor-type (hbar . 8)
                             :cursor-in-non-selected-windows (hbar . 3))
                            (t
                             :cursor-color unspecified
                             :cursor-type bar
                             :cursor-in-non-selected-windows hollow
                             :blink-cursor-mode 1
                             :blink-cursor-blinks 10
                             :blink-cursor-interval 0.2
                             :blink-cursor-delay 0.2)))

  (cursory-set-last-or-fallback)
  (cursory-mode +1))

;;;; `mixed-pitch-mode'

(use-package mixed-pitch
  :hook (text-mode-hook . mixed-pitch-mode))



(provide 'herbsi-themes)
;;; herbsi-themes.el ends here
