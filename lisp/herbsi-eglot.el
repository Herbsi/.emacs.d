;;; herbsi-eglot.el --- LSP Support -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-feature eglot
  :hook (ess-r-mode-hook . eglot-ensure)
  :hook ((python-mode-hook python-ts-mode-hook) . eglot-ensure)
  :hook (rustic-mode-hook . eglot-ensure)
  :config
  (setopt eglot-sync-connect nil)
  (setopt eglot-autoshutdown t)
  (setopt eglot-connect-timeout 10)
  (setopt eglot-send-changes-idle-time 0.5)
  (fset #'jsonrpc--log-event #'ignore)
  (add-to-list
   'eglot-server-programs
   '(ess-r-mode . ("air" "language-server")))
  (add-to-list
   'eglot-server-programs
   '(rustic-mode
     ("rust-analyzer" :initializationOptions (:check (:command "clippy"))))))


(use-package consult-eglot
  :after (consult eglot)
  :bind (:map eglot-mode-map ([remap xref-find-apropos] . consult-eglot-symbols)))


(use-feature treesit
  :config
  ;; Grammar sources for manual `treesit-install-language-grammar'
  ;; runs; no automatic installation, so init never touches the
  ;; network.  ikatyang's markdown and yaml repos are archived; the
  ;; tree-sitter-grammars forks are maintained.
  (dolist (grammar
           '((css "https://github.com/tree-sitter/tree-sitter-css")
             (elisp "https://github.com/Wilfred/tree-sitter-elisp")
             (json "https://github.com/tree-sitter/tree-sitter-json")
             (lua "https://github.com/tjdevries/tree-sitter-lua")
             (markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown")
             (nix "https://github.com/nix-community/tree-sitter-nix")
             (org "https://github.com/milisims/tree-sitter-org")
             (python "https://github.com/tree-sitter/tree-sitter-python")
             (r "https://github.com/r-lib/tree-sitter-r")
             (rust "https://github.com/tree-sitter/tree-sitter-rust")
             (toml "https://github.com/tree-sitter/tree-sitter-toml")
             (typst "https://github.com/uben0/tree-sitter-typst")
             (yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml")))
    (add-to-list 'treesit-language-source-alist grammar))
  (dolist (mapping '((css-mode . css-ts-mode)
                     (json-mode . json-ts-mode)
                     (js-json-mode . json-ts-mode)
                     (python-mode . python-ts-mode)))
    (add-to-list 'major-mode-remap-alist mapping)))



(provide 'herbsi-eglot)
;;; herbsi-eglot.el ends here
