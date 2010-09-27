(load-file (concat vendor-dir "cedet/common/cedet.el"))
(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
(global-ede-mode t)

(require 'malabar-mode)
(setq malabar-groovy-lib-dir (concat vendor-dir "malabar/lib"))
(add-hook 'malabar-mode-hook
          '(lambda ()
            (add-hook 'after-save-hook 'malabar-compile-file-silently
                      nil t)))
(require 'ecb)
