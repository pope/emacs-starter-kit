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

(add-to-list 'load-path vendor-dir)
(add-to-list 'load-path (concat vendor-dir "textmate"))
(add-to-list 'load-path (concat vendor-dir "color-theme"))
(add-to-list 'load-path (concat vendor-dir "gist"))
(add-to-list 'load-path (concat vendor-dir "cheat"))
(add-to-list 'load-path (concat vendor-dir "geben"))
(add-to-list 'load-path (concat vendor-dir "auto-complete"))
(add-to-list 'load-path (concat vendor-dir "malabar/lisp"))
(add-to-list 'load-path (concat vendor-dir "ecb"))
(add-to-list 'load-path (concat vendor-dir "rudel"))

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
(require 'confluence)

(require 'vimpulse)
(viper-go-away)

(autoload 'geben "geben" "PHP Debugger on Emacs" t)

(require 'multi-term)
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

(if window-system
    (color-theme-github))

(delete-selection-mode t)
(global-auto-revert-mode)
(prefer-coding-system 'utf-8)

(load-file (concat vendor-dir "cedet/common/cedet.el"))
(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
(global-ede-mode t)

(require 'malabar-mode)
(setq malabar-groovy-lib-dir (concat vendor-dir "malabar/lib"))
(add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))
(add-hook 'malabar-mode-hook
          '(lambda ()
            (add-hook 'after-save-hook 'malabar-compile-file-silently
                      nil t)))
(require 'ecb)

(load-file (concat vendor-dir "rudel/rudel-loaddefs.el"))
(global-rudel-minor-mode)

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
