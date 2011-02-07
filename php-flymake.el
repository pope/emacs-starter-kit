;; http://sachachua.com/blog/2008/07/emacs-and-php-on-the-fly-syntax-checking-with-flymake/
;; http://blog.arithm.com/2010/03/13/getting-flymake-to-work-with-emacs-nxhtml

(require 'flymake)

;;;###autoload
(defun php-flymake ()
  "Use php to check the syntax of the current file."
  (let* ((temp (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace))
	 (local (file-relative-name temp (file-name-directory buffer-file-name))))
    (list "php" (list "-f" local "-l"))))

(add-to-list 'flymake-err-line-patterns
             '("\\(Parse\\|Fatal\\) error: +\\(.*?\\) in \\(.*?\\) on line \\([0-9]+\\)$" 3 4 nil 2))

(add-to-list 'flymake-allowed-file-name-masks '("\\.php[s34]?$" php-flymake))
(add-to-list 'flymake-allowed-file-name-masks '("\\.phtml$" php-flymake))
(add-to-list 'flymake-allowed-file-name-masks '("\\.inc$" php-flymake))
(add-to-list 'flymake-allowed-file-name-masks '("\\.module$" php-flymake))
(add-to-list 'flymake-allowed-file-name-masks '("\\.install$" php-flymake))
(add-to-list 'flymake-allowed-file-name-masks '("\\.engine$" php-flymake))

(add-hook 'find-file-hook 'flymake-mode-on)

(eval-after-load "php-mode"
  '(progn
     (define-key php-mode-map '[M-S-up] 'flymake-goto-prev-error)
     (define-key php-mode-map '[M-S-down] 'flymake-goto-next-error)))

(provide 'php-flymake)
