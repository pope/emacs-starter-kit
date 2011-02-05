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
  (let ((bname (replace-regexp-in-string "^\\(.*?\\)/controllers/.*$" "\\1" (buffer-file-name)))
        (cname (zf/camel-to-hyphens
                (replace-regexp-in-string "^.*/\\(.*\\)Controller\\.php$" "\\1"
                                          (buffer-file-name))))
        (sname (zf/camel-to-hyphens
                (save-excursion
                  (save-restriction
                    (narrow-to-defun)
                    (goto-char (point-min))
                    (replace-regexp-in-string "^.*function \\(.*\\)Action.*\n"
                                              "\\1"
                                              (thing-at-point 'line) t nil))))))
    (zf/goto-file (concat bname "/views/scripts/" cname "/" sname ".phtml"))))

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
    (let* ((fp (substring str 0 1))
           (lp (substring str 1))
           (result (concat (downcase fp)
                           (downcase
                            (replace-regexp-in-string "[A-Z]" "-\\&" lp)))))
      (setq case-fold-search cfs)
      result)))

(provide 'zf)
