;; COMMANDS

(defun zf-goto-test ()
  (interactive)
  (zf/goto-file
   (cond ((string-match "^\\(.*?\\)/tests/\\(application\\|library\\)/\\(.*?\\)Test\\.php$"
                        (buffer-file-name))
          (replace-match "\\1/\\2/\\3.php"
                         t nil (buffer-file-name)))
         ((string-match "^\\(.*?\\)/\\(application\\|library\\)/\\(.*?\\)\\.php$"
                        (buffer-file-name))
          (replace-match "\\1/tests/\\2/\\3Test.php"
                         t nil (buffer-file-name)))
         (t
          nil))))

(defun zf-goto-alt ()
  (interactive)
  (let* ((fn-line (save-excursion
                    (save-restriction
                      (narrow-to-defun)
                      (goto-char (point-min))
                      (move-end-of-line 1)
                      (buffer-substring (point-min)(point)))))
         (fn-name (if (string-match "defun \\(.*?\\) ()" fn-line)
                      (substring fn-line (match-beginning 1) (match-end 1)))))
    (message fn-name)))

;; HELPERS

(defun zf/goto-file (file)
  (if file
      (if (or (file-exists-p file)
              (y-or-n-p (concat "Could not find " file
                                ". Would you like me to open it anyway? ")))
          (find-file file))
    (message "File does not appear to be a ZF file")))


(defun zf/camel-to-hyphens (str)
  (let ((cfs case-fold-search))
    (setq case-fold-search nil)
    (let ((result (downcase
                   (replace-regexp-in-string "[A-Z]" "-\\&" str))))
      (setq case-fold-search cfs)
      result)))

(provide 'zf)
