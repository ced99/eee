;; Set custom variables
(setq fill-column 79)
(setq require-final-newline t)
(setq-default indent-tabs-mode nil)
(setq transient-mark-mode t)
(setq show-paren-face 'highlight)
(setq blink-matching-paren nil)
(setq show-paren-style 'expression)
(setq visible-bell t)

;; Customize the font
(set-face-attribute 'default nil :height 94)

;; Define major modes per extension
(setq auto-mode-alist
      (cons '("\\.el$" . lisp-interaction-mode) auto-mode-alist)
)
(setq auto-mode-alist
      (cons '("\\.emacs$" . lisp-interaction-mode) auto-mode-alist)
)
(setq auto-mode-alist
      (cons '("\\.py$" . python-mode) auto-mode-alist)
)
(setq auto-mode-alist
      (cons '("\\.ixx$" . c++-mode) auto-mode-alist)
)
(setq auto-mode-alist
      (cons '("\\.pl$" . perl-mode) auto-mode-alist)
)
(setq auto-mode-alist
      (cons '("\\.pm$" . perl-mode) auto-mode-alist)
)
(setq auto-mode-alist
      (cons '("\\.t$" . perl-mode) auto-mode-alist)
)
(setq auto-mode-alist
      (cons '("\\.jsx$" . jsx-mode) auto-mode-alist)
)
;; Call various functions
(auto-fill-mode 1)
(global-font-lock-mode t)
(show-paren-mode t)
(tool-bar-mode 0)
