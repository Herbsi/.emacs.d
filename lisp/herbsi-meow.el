;;; herbsi-meow.el --- Yet another modal editing on Emacs -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-package meow
  :demand t
  :config
  (add-to-list 'meow-mode-state-list '(git-commit-mode . insert))
  (add-to-list 'meow-mode-state-list '(ghostel-mode . insert))
  (setopt meow-use-clipboard t)
  (setopt meow-cheatsheet-layout meow-cheatsheet-layout-dvorak)

  ;; Custom keybindings
  (meow-leader-define-key
   '("/" . consult-ripgrep)
   '("," . consult-buffer)
   '("<" . consult-project-buffer)
   '("." . find-file)
   '(">" . project-find-file)
   '("a" . org-agenda)
   '("c" . org-capture)
   '("f" . apheleia-format-buffer)
   '("n" . denote)
   '("o" . consult-outline)
   '("r" . recentf))
  
  ;; Numeric arguments on SPC 0-9.
  (meow-leader-define-key
   '("0" . meow-digit-argument)
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("?" . meow-cheatsheet))

  ;; Special buffers keep their own keys; only SPC stays modal.
  (meow-motion-define-key
   '("<escape>" . ignore))

  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("<" . meow-beginning-of-thing)
   '(">" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-line)
   '("E" . meow-goto-line)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-join)
   '("k" . meow-kill)
   '("l" . meow-till)
   '("m" . meow-mark-word)
   '("M" . meow-mark-symbol)
   '("n" . meow-next)
   '("N" . meow-next-expand)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-prev)
   '("P" . meow-prev-expand)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-search)
   '("t" . meow-right)
   '("T" . meow-right-expand)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-next-word)
   '("W" . meow-next-symbol)
   '("x" . meow-save)
   '("X" . meow-sync-grab)
   '("y" . meow-yank)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore))

  ;; Complete on C-SPC in insert state, like before.
  (meow-define-keys 'insert
    '("C-SPC" . completion-at-point))
  
  (meow-setup-indicator)
  (meow-global-mode 1))


(provide 'herbsi-meow)
;;; herbsi-meow.el ends here
