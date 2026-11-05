;;; herbsi-age.el --- age encrypted secrets -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defconst herbsi-secrets-dir (expand-file-name "secrets/" user-emacs-directory)
  "Age encrypted secrets tracked in this repository.")


(defconst herbsi-age-identity (expand-file-name "id_ed25519" "~/.ssh/")
  "Private key decrypting `herbsi-secrets-dir'.")


(defconst herbsi-age-recipient
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILA0+MyUCeN/XMZPefsTBAe6XpSXoioIiJtiZTJZW/Mv"
  "Public key encrypting `herbsi-secrets-dir'.
Keep in sync with secrets/secrets.nix.")


(defun herbsi-age-file (name)
  "Return the encrypted file of secret NAME."
  (expand-file-name (concat name ".age") herbsi-secrets-dir))


(defun herbsi-age--decrypt (name)
  "Decrypt secret NAME into the current buffer.
Signal an error when the identity, the secret, or the `age' binary is
missing."
  (unless (file-exists-p herbsi-age-identity)
    (error "Missing identity: %s" herbsi-age-identity))
  (unless (zerop (call-process "age" nil t nil
                               "-d" "-i" herbsi-age-identity
                               (herbsi-age-file name)))
    (error "age failed to decrypt %s" name)))


(defun herbsi-age-read (name)
  "Return the s-expressions of secret NAME as a list.
Return nil when the secret is absent or cannot be decrypted, e.g. on
a fresh clone without the private key, so that startup works either
way."
  (when (file-exists-p (herbsi-age-file name))
    (condition-case err
        (with-temp-buffer
          (herbsi-age--decrypt name)
          (goto-char (point-min))
          (let (forms)
            (while (progn (skip-chars-forward " \t\r\n") (not (eobp)))
              (push (read (current-buffer)) forms))
            (nreverse forms)))
      (error (message "herbsi-age: %s" (error-message-string err))
             nil))))


(use-package age
  :config
  (setopt age-default-identity herbsi-age-identity)
  (setopt age-default-recipient herbsi-age-recipient)
  (age-file-enable))



(provide 'herbsi-age)
;;; herbsi-age.el ends here
