(setq ns-pop-up-frames nil
      ring-bell-function 'ignore
      vendor-dir (concat dotfiles-dir "vendor/")
      indent-tabs-mode nil
      c-basic-offset 4
      nxml-child-indent 4
      tab-width 4
      scroll-step 1)
(line-number-mode t)
(column-number-mode t)

(setenv "PATH" (concat "/usr/local/zend/bin" ":"
                       "/Users/pope/.gem/ruby/1.8/bin" ":"
                       "/opt/local/sbin" ":"
                       "/opt/local/bin" ":"
                       "/usr/local/bin" ":"
                       "/usr/bin" ":"
                       "/bin" ":"
                       "/usr/sbin" ":"
                       "/sbin" ":"
                       "/usr/X11/bin"))
(setenv "MAVEN_OPTS" "-Xms512m -Xmx1024m")
(setenv "P4CONFIG" ".p4settings")

(add-to-list 'load-path vendor-dir)
(add-to-list 'load-path (concat vendor-dir "textmate"))
(add-to-list 'load-path (concat vendor-dir "color-theme"))
(add-to-list 'load-path (concat vendor-dir "gist"))
(add-to-list 'load-path (concat vendor-dir "cheat"))
(add-to-list 'load-path (concat vendor-dir "geben"))
(add-to-list 'load-path (concat vendor-dir "auto-complete"))
(add-to-list 'load-path (concat vendor-dir "rudel"))
(add-to-list 'load-path (concat vendor-dir "html5"))
(add-to-list 'load-path (concat vendor-dir "mingus"))
(add-to-list 'load-path (concat vendor-dir "vc-p4"))
(add-to-list 'load-path (concat vendor-dir "apel"))
(add-to-list 'load-path (concat vendor-dir "jabber"))
(add-to-list 'load-path (concat vendor-dir "eproject"))

(require 'auto-complete)
(add-to-list 'ac-dictionary-directories (concat vendor-dir "auto-complete/dict"))
(require 'auto-complete-config)
(ac-config-default)

(require 'textmate)
(require 'peepopen)
(require 'color-theme)
(require 'php-mode)
(require 'php-electric)
(require 'gist)
(require 'sr-speedbar)
(require 'quack)
(require 'cheat)
(require 'vc-p4)
(require 'eproject)
(require 'eproject-extras)

(require 'vimpulse)
(viper-go-away)

(autoload 'geben "geben" "PHP Debugger on Emacs" t)
(autoload 'mingus "mingus-stays-home" "Music Player Client on Emacs" t)

(autoload 'multi-term "multi-term" "Multi-Term" t)
(setq multi-term-program "/bin/bash")

(add-hook 'php-mode-hook '(lambda ()
  (setq c-basic-offset 4) ; 4 tabs indenting
  (setq indent-tabs-mode nil)
  (setq fill-column 78)
  (setq case-fold-search t)
  (c-set-offset 'case-label '+)
  (c-set-offset 'arglist-close 'c-lineup-arglist-operators)
  (c-set-offset 'arglist-intro '+) ; for FAPI arrays and DBTNG
  (c-set-offset 'arglist-cont-nonempty 'c-lineup-math)
  (setq php-mode-force-pear t))) ; for DBTNG fields and values

;; nxml-mode
(setq nxml-slash-auto-complete-flag t)

(textmate-mode)
(add-to-list '*textmate-project-roots* "pom.xml")
(setq *textmate-gf-exclude* (concat *textmate-gf-exclude* "|target"))

;; Initalize theme
(color-theme-initialize)

;; Activate theme
(load (concat vendor-dir "color-theme-ir-black/color-theme-ir-black.el"))
(load (concat vendor-dir "color-theme-github/color-theme-github.el"))
(load (concat vendor-dir "color-theme-mac-classic/color-theme-mac-classic.el"))
(load (concat vendor-dir "color-theme-tangotango/color-theme-tangotango.el"))
(load (concat vendor-dir "color-theme-dark-emacs.el"))
(load (concat vendor-dir "color-theme-wombat.el"))

;;(color-theme-github)
;;(set-mouse-color "black")

(delete-selection-mode t)
(global-auto-revert-mode)
(prefer-coding-system 'utf-8)

(add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))
(autoload 'malabar-mode "malabar-load" "Start Up Malabar Mode" t)

(autoload 'global-rudel-minor-mode "rudel-loaddefs" "Rudel - Code Collaborator" t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(menu-bar-mode t)
;;(tool-bar-mode t)
;;(scroll-bar-mode t)

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
    (filename (buffer-file-name)))
    (if (not filename)
    (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
      (message "A buffer named '%s' already exists!" new-name)
    (progn
      (rename-file name new-name 1)
      (rename-buffer new-name)
      (set-visited-file-name new-name)
      (set-buffer-modified-p nil))))))

(eval-after-load "rng-loc"
  '(add-to-list 'rng-schema-locating-files
                (concat vendor-dir "html5/schemas.xml")))

(require 'whattf-dt)

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
          ((ignore-errors (eproject-root)) (list (eproject-root)))
          (t (list
              (if (and (stringp mode-name) (string-match "[^ ]" mode-name))
                  mode-name
                (symbol-name major-mode)))))))
(setq tabbar-buffer-groups-function 'pope-tabbar-buffer-groups)

(tabbar-mode 1)

;;Keys

(global-set-key (kbd "s-{") 'tabbar-backward)
(global-set-key (kbd "s-}") 'tabbar-forward)
(global-set-key (kbd "s-[") 'tabbar-forward-group)
(global-set-key (kbd "s-]") 'tabbar-backward-group)
(global-set-key (kbd "s-w") 'kill-this-buffer)
(global-set-key (kbd "s-k") 'kill-this-buffer)
