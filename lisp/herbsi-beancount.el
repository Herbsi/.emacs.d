;;; herbsi-beancount --- Beancount Mode configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-package beancount
  :ensure (:host github :repo "beancount/beancount-mode")
  :mode ("\\.beancount\\'" . beancount-mode)
  :hook (beancount-mode-hook . outline-minor-mode)
  :config
  (setopt beancount-electric-currency t)
  (setopt beancount-use-ido nil)
  (setopt beancount-number-alignment-column 0)
  (setopt beancount-check-program "bean-check"
	      beancount-doctor-program "bean-doctor"
	      beancount-query-program "bean-query"
	      beancount-price-program "bean-price")

  (defun herbsi-beancount-expenses-accounts ()
    (cl-remove-if-not (lambda (account) (string-match "^Expenses" account))
		              (beancount-get-account-names)))


  (defun herbsi-beancount-ibkr-accounts ()
    (cl-remove-if-not (lambda (account) (string-match "^Assets:UK:IBKR:" account))
		              (beancount-get-account-names)))


  (defun herbsi-beancount-ibkr-tickers ()
    (cl-flet ((extract-ticker-symbol (account)
		        (car (last (string-split account ":")))))
      (mapcar #'extract-ticker-symbol (herbsi-beancount-ibkr-accounts))))


  (defconst herbsi-beancount-private (car (herbsi-age-read "beancount"))
    "Alist of private ledger data: domains, liquidity, spending, splitwise.")


  (defconst herbsi-beancount-domains (alist-get 'domains herbsi-beancount-private)
    "List of domains.")


  (defconst herbsi-beancount-liquidity-accounts
    (alist-get 'liquidity herbsi-beancount-private)
    "List of liquid accounts.")


  (defconst herbsi-beancount-spending-accounts
    (alist-get 'spending herbsi-beancount-private)
    "List of accounts used for spending.")


  (defun herbsi-beancount--close-clause (no-close-date-p)
    "SQL fragment that closes the ledger tomorrow unless NO-CLOSE-DATE-P."
    (if no-close-date-p
        ""
      (format "FROM CLOSE ON %s" (format-time-string "%Y-%m-%d" (days-to-time 1)))))


  (defun herbsi-beancount--account-filter (accounts)
    "SQL predicate matching any of the given ACCOUNTS."
    (string-join (mapcar (lambda (account) (format "account = \"%s\"" account))
                         accounts)
                 " OR "))


  (defun herbsi-beancount--query (query-string)
    "Run `bean-query' with QUERY-STRING against the current ledger."
    (let ((compilation-read-command nil)
          (current-prefix-arg nil))
      (beancount--run beancount-query-program buffer-file-name query-string)))


  (defun herbsi-beancount-networth (no-close-date-p)
    "Run `bean-report networth'.
If `NO-CLOSE-DATE-P' is nil the ledger is closed tomorrow."
    (interactive "P")
    (herbsi-beancount--query
     (format "SELECT sum(convert(position, \"CHF\")) as networth %s WHERE account ~ \"^[AL]\";"
             (herbsi-beancount--close-clause no-close-date-p))))


  (defun herbsi-beancount-liquidity-by-account (no-close-date-p)
    "Run `bean-query' and generate current liquidity by liquid account.
If `NO-CLOSE-DATE-P' is nil the ledger is closed tomorrow."
    (interactive "P")
    (herbsi-beancount--query
     (format "SELECT account, SUM(position) AS position %s WHERE (%s) ORDER BY account"
             (herbsi-beancount--close-clause no-close-date-p)
             (herbsi-beancount--account-filter herbsi-beancount-liquidity-accounts))))


  (defun herbsi-beancount-liquidity (no-close-date-p)
    "Run `bean-query' and generate current total liquidity.
If `NO-CLOSE-DATE-P' is nil the ledger is closed tomorrow."
    (interactive "P")
    (herbsi-beancount--query
     (format "SELECT SUM(position) AS position %s WHERE (%s)"
             (herbsi-beancount--close-clause no-close-date-p)
             (herbsi-beancount--account-filter herbsi-beancount-liquidity-accounts))))


  (defun herbsi-beancount-assets-liabilities (no-close-date-p)
    "Run `bean-query' and generate current assets and liabilities.
If `NO-CLOSE-DATE-P' is nil the ledger is closed tomorrow."
    (interactive "P")
    ;; TODO 2024-07-17 The output of this is ugly (ie too wide).
    (herbsi-beancount--query
     (format "SELECT account, units(SUM(position)) AS units %s WHERE account ~ \"^[AL]\" ORDER BY account;"
             (herbsi-beancount--close-clause no-close-date-p))))


  (defun herbsi-beancount-invested ()
    "Run `bean-query' and generate the amount of CHF invested since
 the selected date."
    (interactive)
    ;; TODO 2026-03-18 Remove `org-read' because `org' isn't guaranteed to be loaded.
    (let ((start-date-string (org-read-date nil nil nil nil nil (format-time-string "%Y-01-01"))))
      (herbsi-beancount--query
       (format "SELECT SUM(CONVERT(position, \"CHF\")) WHERE date >= %s AND account ~ \"IBKR\";"
               start-date-string))))


  (defun herbsi-beancount-splitwise ()
    "Run `bean-query' and report current balance of Splitwise."
    (interactive)
    (herbsi-beancount--query
     (format "SELECT SUM(position) as position WHERE account ~ \"%s\";"
             (alist-get 'splitwise herbsi-beancount-private)))))



(provide 'herbsi-beancount)
;;; herbsi-beancount.el ends here
