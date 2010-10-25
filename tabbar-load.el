;; My Setup for Tabbar.  This is in an autoload file because Aquamacs
;; doesn't use this

(defun pope-setup-tabbar ()
  (require 'tabbar)
  (set-face-attribute
   'tabbar-default-face nil
   :background "gray60")
  (set-face-attribute
   'tabbar-unselected-face nil
   :background "gray85"
   :foreground "gray30"
   :box nil)
  (set-face-attribute
   'tabbar-selected-face nil
   :background "#f2f2f6"
   :foreground "black"
   :box nil)
  (set-face-attribute
   'tabbar-button-face nil
   :box '(:line-width 1 :color "gray72" :style released-button))
  (set-face-attribute
   'tabbar-separator-face nil
   :height 0.7)

  (setq tabbar-buffer-groups-function 'pope-tabbar-buffer-groups)
  (tabbar-mode 1)

  (global-set-key (kbd "s-{") 'tabbar-backward)
  (global-set-key (kbd "s-}") 'tabbar-forward)
  (global-set-key (kbd "s-[") 'tabbar-forward-group)
  (global-set-key (kbd "s-]") 'tabbar-backward-group))


(defun pope-tabbar-buffer-groups (buffer)
  "Return the list of group names BUFFER belongs to.
Return only one group for each buffer."
  (with-current-buffer (get-buffer buffer)
    (cond ((or (get-buffer-process (current-buffer))
               (memq major-mode '(comint-mode compilation-mode)))
           '("Process"))
          ((member (buffer-name) '("*scratch*" "*Messages*")) '("Common"))
          ((eq major-mode 'dired-mode) '("Dired"))
          ((memq major-mode '(help-mode apropos-mode Info-mode Man-mode)) '("Help"))
          ((memq major-mode
                 '(rmail-mode
                   rmail-edit-mode vm-summary-mode vm-mode mail-mode
                   mh-letter-mode mh-show-mode mh-folder-mode
                   gnus-summary-mode message-mode gnus-group-mode
                   gnus-article-mode score-mode gnus-browse-killed-mode))
           '("Mail"))
          ((ignore-errors (eproject-root)) (list
                                            (file-name-nondirectory
                                             (directory-file-name (eproject-root)))))
          (t (list
              (if (and (stringp mode-name) (string-match "[^ ]" mode-name))
                  mode-name
                (symbol-name major-mode)))))))
