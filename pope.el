(defvar *emacs-load-start* (float-time))

(setq ns-pop-up-frames nil
      ring-bell-function 'ignore
      vendor-dir (concat dotfiles-dir "vendor/")
      indent-tabs-mode nil
      c-basic-offset 4
      nxml-child-indent 4
      tab-width 4
      scroll-step 1
      mumamo-background-colors nil
      twittering-use-master-password t)
(line-number-mode t)
(column-number-mode t)
(winner-mode t)
(delete-selection-mode t)
(global-auto-revert-mode)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

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
(setenv "XDEBUG_CONFIG" "idekey=geben_session")

(load-file (concat vendor-dir "/cedet/common/cedet.el"))

(add-to-list 'load-path vendor-dir)

(dolist (ext '("textmate" "color-theme" "cheat" "geben" "auto-complete"
               "rudel" "html5" "mingus" "vc-p4" "apel" "jabber" "eproject"
               "ecb" "color-theme-ir-black" "color-theme-github"
               "color-theme-mac-classic" "color-theme-tangotango" "emacs-w3m"
               "twittering-mode" "gnus/lisp" "org-mode/lisp"))
  (add-to-list 'load-path (concat vendor-dir ext)))

(require 'gnus-load)
(require 'w3m-load)
(require 'org-install)

(require 'auto-complete)
(add-to-list 'ac-dictionary-directories (concat vendor-dir "auto-complete/dict"))
(require 'auto-complete-config)
(ac-config-default)

(require 'textmate)
(require 'peepopen)
(require 'vc-p4)
(require 'eproject)
(require 'eproject-extras)
(require 'eproject-load)
(require 'ecb-autoloads)
(require 'twittering-mode)

(autoload 'sr-speedbar "sr-speedbar" "Same frame speedbar" t)
(autoload 'quack-load "quack-load" "Initialize Quack" t)
(autoload 'turn-on-zf "zf" "Turn on zf-mode" t)
(autoload 'zf-mode "zf" "A minor mode for when you're working with a ZendFramework project." t)
(autoload 'sync-mode "sync-mode" "A minor mode to sync a buffer from one directory to another" t)

(load (concat vendor-dir "nxhtml/autostart.el"))

;;(require 'vimpulse)
;;(viper-go-away)

(autoload 'mingus "mingus-stays-home" "Music Player Client on Emacs" t)

(autoload 'multi-term "multi-term" "Multi-Term" t)
(setq multi-term-program "/bin/bash")

;; PHP Stuff

(defun php-mode-settings ()
  (setq c-basic-offset 4) ; 4 tabs indenting
  (setq indent-tabs-mode nil)
  (setq fill-column 78)
  (setq case-fold-search t)
  (c-set-offset 'case-label '+)
  (c-set-offset 'arglist-close 'c-lineup-arglist-operators)
  (c-set-offset 'arglist-intro '+) ; for FAPI arrays and DBTNG
  (c-set-offset 'arglist-cont-nonempty 'c-lineup-math)
  (setq php-mode-force-pear t)) ; for DBTNG fields and values

(eval-after-load "php-mode"
  '(progn
     (require 'php-electric)
     (require 'php-flymake)
     (add-hook 'php-mode-hook 'php-mode-settings)
     (add-hook 'php-mode-hook 'turn-on-zf)))

(autoload 'geben "geben" "PHP Debugger on Emacs" t)

;; nxml-mode
(setq nxml-slash-auto-complete-flag t)

(eval-after-load "rng-loc"
  '(add-to-list 'rng-schema-locating-files
                (concat vendor-dir "html5/schemas.xml")))

(add-hook 'nxml-mode-hook '(lambda () (require 'whattf-dt)))

;; textmate-mode
(textmate-mode)
(add-to-list '*textmate-project-roots* "pom.xml")
(setq *textmate-gf-exclude* (concat *textmate-gf-exclude* "|target"))

;; Initalize theme
(require 'color-theme)
;;(color-theme-initialize)

(setq color-theme-is-global t)

;; Activate theme
(autoload 'color-theme-ir-black "color-theme-ir-black" "IR Black Color Theme" t)
(autoload 'color-theme-github "color-theme-github" "Github Color Theme" t)
(autoload 'color-theme-mac-classic "color-theme-mac-classic" "Mac Classic Color Theme" t)
(autoload 'color-theme-tangotango "color-theme-tangotango" "TangoTango Color Theme" t)
(autoload 'color-theme-dark-emacs "color-theme-dark-emacs" "Dark Emacs Color Theme" t)
(autoload 'color-theme-wombat "color-theme-wombat" "Wombat Color Theme" t)

;; Java
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

(defun eshell/clear ()
  "04Dec2001 - sailor, to clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

(defun toggle-fullscreen (&optional f)
  "Toggles a fullscreen view of the frame"
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
                         (if (equal 'fullboth current-value)
                             (if (boundp 'old-fullscreen) old-fullscreen nil)
                           (progn (setq old-fullscreen current-value)
                                  'fullboth)))))

(autoload 'pope-setup-tabbar "tabbar-load" "Start Up Tabbar" t)
(unless (featurep 'aquamacs) (pope-setup-tabbar))

;;Keys
(global-set-key (kbd "s-w") 'kill-this-buffer)
(global-set-key (kbd "s-k") 'kill-this-buffer)
(global-set-key [f11] 'toggle-fullscreen)
(global-set-key (kbd "s-F") 'toggle-fullscreen)

(message "My .emacs loaded in %.1fs" (- (float-time) *emacs-load-start*))
