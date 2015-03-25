(defun eee-keys:define-key (key def)
   (define-key function-key-map key def)
)

(eee-keys:define-key [f5]   [red])
(eee-keys:define-key [f6]   [gold])
(eee-keys:define-key [f7]   [pink])
(eee-keys:define-key [f8]   [blue])


(defun eee-keys:enclose-region (l r)
    (interactive "r")
    (setq eee-region-left  (min (mark) (point)))
    (setq eee-region-right (max (mark) (point)))
    (goto-char eee-region-left)
    (insert l)
    (goto-char (1+ eee-region-right))
    (insert r)
    (deactivate-mark)
)

(defun eee-keys:insert-char-pair (l r)
    (if mark-active
        (eee-keys:enclose-region l r)
        (insert l r)
    )
    (backward-char)
)

(defun eee-keys:insert-char-space (c)
   (insert c " ")
)

(defun eee-keys:insert-braces ()
    (interactive)
    (eee-keys:insert-char-pair "{" "}")
)

(defun eee-keys:insert-brackets ()
    (interactive)
    (eee-keys:insert-char-pair "[" "]")
)

(defun eee-keys:insert-parantheses ()
    (interactive)
    (eee-keys:insert-char-pair "(" ")")
)

(defun eee-keys:insert-dquotes ()
    (interactive)
    (eee-keys:insert-char-pair "\"" "\"")
)

(defun eee-keys:insert-squotes ()
    (interactive)
    (eee-keys:insert-char-pair "'" "'")
)

(defun eee-keys:insert-comma ()
    (interactive)
    (eee-keys:insert-char-space ",")
)

(global-set-key "{"  'eee-keys:insert-braces)
(global-set-key "["  'eee-keys:insert-brackets)
(global-set-key "("  'eee-keys:insert-parantheses)
(global-set-key "\"" 'eee-keys:insert-dquotes)
;;(global-set-key ","  'eee-keys:insert-comma)

(global-set-key [gold ?\{] 'self-insert-command)
(global-set-key [gold ?[]  'self-insert-command)
(global-set-key [gold ?(]  'self-insert-command)
(global-set-key [gold ?\"] 'self-insert-command)
;;(global-set-key [gold ?,]  'self-insert-command)


(setq eee-keys:kbd-macro-index -1)

(defun eee-keys:get-unique-kbd-macro-name ()
  (setq eee-keys:kbd-macro-index (+ eee-keys:kbd-macro-index 1))
  (concat "eee-keys:user-kbd-macro-" (number-to-string eee-keys:kbd-macro-index))
)

(defun eee-keys:stop-and-bind-kbd-macro ()
    (interactive)
    (end-kbd-macro)
    (setq eee-keys:current-kbd-macro-name
          (intern (eee-keys:get-unique-kbd-macro-name))
    )
    (name-last-kbd-macro
             eee-keys:current-kbd-macro-name
    )
    (global-set-key eee-keys:current-kbd-macro-key
             eee-keys:current-kbd-macro-name
    )
    (message (concat (key-description eee-keys:current-kbd-macro-key) " succefully defined"))
)

(defun eee-keys:learn-kbd-macro (key)
    (interactive "KKey to define: \n")
    (global-set-key key 'eee-keys:stop-and-bind-kbd-macro)
    (setq eee-keys:current-kbd-macro-key key)
    (start-kbd-macro ())
)

(global-set-key [red ?m] 'eee-keys:learn-kbd-macro)

(global-set-key [red ?d] 'dabbrev-expand)
(global-set-key [red ?l] 'goto-line)

(defun eee-keys:new-frame ()
;;; Workaround, since in emacs 21.4 new frames ignore the default
;;; face settings. Damn !!!
    (interactive)
    (new-frame)
    (set-face-attribute 'default nil :height 94)
)

(global-set-key [red ?+] 'eee-keys:new-frame)
(global-set-key [red ?-] 'delete-frame)

(defun eee-keys:fix-c-keymap ()
  (substitute-key-definition
      'c-electric-paren 'eee-keys:insert-parantheses c-mode-map)
  (substitute-key-definition
      'c-electric-brace 'eee-keys:insert-braces c-mode-map)
  ;;(substitute-key-definition
  ;;    'c-electric-semi&comma 'eee-keys:insert-comma c-mode-map)
)
(add-hook 'c-mode-hook 'eee-keys:fix-c-keymap)

(defun eee-keys:fix-c++-keymap ()
  (substitute-key-definition
      'c-electric-paren 'eee-keys:insert-parantheses c++-mode-map)
  (substitute-key-definition
      'c-electric-brace 'eee-keys:insert-braces c++-mode-map)
  ;;(substitute-key-definition
  ;;    'c-electric-semi&comma 'eee-keys:insert-comma c++-mode-map)
)
(add-hook 'c++-mode-hook 'eee-keys:fix-c++-keymap)

(defun eee-keys:fix-perl-keymap ()
  (local-set-key "{" 'eee-keys:insert-braces)
  (local-set-key "'" 'eee-keys:insert-squotes)
)
(add-hook 'perl-mode-hook 'eee-keys:fix-perl-keymap)




