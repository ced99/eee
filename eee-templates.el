(setq eee-templates:indent-depth 4)

(defun eee-templates:insert-open-token ()
  (interactive)
  (insert "«")
)

(defun eee-templates:insert-close-token ()
    (interactive)
    (insert "»")
)

(defun eee-templates:insert-token-pair ()
    (interactive)
    (eee-templates:insert-open-token)
    (eee-templates:insert-close-token)
    (backward-char)
)

(global-set-key [gold ?<]      'eee-templates:insert-token-pair)
(global-set-key [gold ?>]      'eee-templates:insert-close-token)
(global-set-key [gold gold ?<] 'eee-templates:insert-open-token)

(defun eee-templates:backward-open-token ()
    (re-search-backward "«" nil t)
)

(defun eee-templates:backward-close-token ()
    (interactive)
    (re-search-backward "»" nil t)
)

(defun eee-templates:forward-open-token ()
    (interactive)
    (if (= (char-after) (string-to-char "«"))
        (forward-char)
    )
    (if
        (re-search-forward "«" nil t)
        (backward-char)
    )
)

(defun eee-templates:forward-close-token ()
    (if
        (re-search-forward "[a-zA-Z0-9]»" nil t)
        (backward-char)
    )
)

(defvar eee-templates:last-overlay)
(make-variable-buffer-local 'eee-templates:last-overlay)

(setq eee-template:highlight-face (make-face 'eee-template:highlight-face))
(set-face-background eee-template:highlight-face "yellow")

(defun eee-templates:highlight-region (face start end)
    (setq eee-templates:last-overlay (make-overlay start end))
    (overlay-put eee-templates:last-overlay 'face face)
)

(defun eee-templates:highlight-current ()
  (if eee-templates:last-overlay
      (delete-overlay eee-templates:last-overlay)
  )
  (setq eee-template:current-pos (point))
  (eee-templates:backward-open-token)
  (setq eee-template:highlight-start (point))
  (eee-templates:forward-close-token)
  (setq eee-template:highlight-end (+ (point) 1))
  (goto-char eee-template:current-pos)
  (eee-templates:highlight-region
      eee-template:highlight-face
      eee-template:highlight-start eee-template:highlight-end
  )
)

(defun eee-templates:fix-after-erase ()
  (if (eee-text:empty-region
          (line-beginning-position) (line-end-position)
       )
      (eee-text:kill-whole-line)
  )
  (eee-text:forward-non-whitespace)
  (if (= (char-after)  (string-to-char "«"))
      (eee-templates:goto-next-fill-in)
  )
)


(defun eee-templates:erase-active-fill-in ()
  (interactive)
  (if (and (<= (overlay-start eee-templates:last-overlay) (point))
           (>= (overlay-end eee-templates:last-overlay) (point))
      )
      (progn
          (if eee-templates:last-overlay
              (progn
                  (delete-region
                      (overlay-start eee-templates:last-overlay)
                      (overlay-end   eee-templates:last-overlay)
                  )
                  (delete-overlay eee-templates:last-overlay)
              )
          )
          (setq eee-templates:last-overlay nil)
      )
  )
)

(defun eee-templates:kill-active-fill-in ()
  (interactive)
  (eee-templates:erase-active-fill-in)
  (eee-templates:fix-after-erase)
)

(defun eee-templates:goto-prev-fill-in ()
  (interactive)
  (setq eee-template:current-pos (point))
  (backward-char)
  (eee-templates:backward-open-token)
  (forward-char)
  (setq eee-template:new-pos (point))
  (if (not (= eee-template:current-pos eee-template:new-pos))
      (eee-templates:highlight-current)
  )
)

(defun eee-templates:goto-next-fill-in ()
  (interactive)
  (setq eee-template:current-pos (point))
  (forward-char)
  (eee-templates:forward-close-token)
  (backward-char)
  (setq eee-template:new-pos (point))
  (if (not (= eee-template:current-pos eee-template:new-pos))
      (eee-templates:highlight-current)
  )
)

(defun eee-templates:get-current-fill-in ()
  (thing-at-point 'word)
)

(defun eee-templates:init-templates (mode)
  (set
      (intern (concat "eee-templates-" mode "-map"))
      (make-hash-table :test 'equal :size 240)
  )
)

(defun eee-templates:insert-template (name explist)
  (puthash name explist eee-template:current-mode-table)
)

(defun eee-templates:inherit-templates (mode ancestor)
    (setq eee-template:current-mode-table
        (symbol-value (intern (concat "eee-templates-" mode "-map")))
    )
    (let
        ( (ancestor-table
              (symbol-value
                  (intern (concat "eee-templates-" ancestor "-map"))
              )
          )
        )
       (maphash 'eee-templates:insert-template ancestor-table)
    )
)

(defun eee-templates:define-template-expansion (mode name explist)
  (let ((templ-table
           (symbol-value (intern (concat "eee-templates-" mode "-map")))
        )
       )
       (puthash name explist templ-table)
  )
)

(defun eee-templates:define-template-selection (mode name options)
  (let ((templ-table
           (symbol-value (intern (concat "eee-templates-" mode "-map")))
        )
       )
       (puthash name (push "???" options) templ-table)
  )
)

(defun eee-templates:define-template-alias (mode alias real)
  (let ((templ-table
           (symbol-value (intern (concat "eee-templates-" mode "-map")))
        )
       )
       (puthash alias (gethash real templ-table) templ-table)
  )
)

(defun eee-templates:get-current-mode-key ()
  (interactive)
  (car (split-string (symbol-name major-mode) "-"))
)

(defun eee-templates:add-to-map (word)
  (if (eq (assoc word eee-templates:current-fillin-map) nil)
      (setq eee-templates:current-fillin-map
          (push (list word (read-string (concat word ": ")))
              eee-templates:current-fillin-map
          )
      )
  )
)

(defun eee-templates:add-line-to-map (line)
  (let ( (pattern "«!\\([_A-Za-z]+\\)!»")
         (i -1)
       )
       (while (not (eq i nil))
          (setq i (string-match pattern line (+ i 1)))
          (if (not (eq i nil))
              (eee-templates:add-to-map (match-string 1 line))
          )
       )
  )
)

(defun eee-templates:build-fillin-map (template)
  (setq eee-templates:current-fillin-map '())
  (mapcar 'eee-templates:add-line-to-map (mapcar 'car (mapcar 'cdr template)))
)

(defun eee-templates:apply-map (text)
  (dolist (mapping eee-templates:current-fillin-map text)
      (let ( (from (car mapping))
             (to   (car (cdr mapping)))
           )
          (let ((applied
                    (string-replace-match
                        (concat "«!" from "!»") text to :global t
                    )
                 )
                )
               (if (not (eq applied nil))
                   (setq text applied)
               )
          )
      )
  )
)

(defun eee-templates:insert-template-line (line)
  (let ( (level (car line))
         (text  (car (cdr line)))
       )
       (progn
           (move-to-column eee-templates:current-start-column t)
           (insert
               (make-string (* level eee-templates:indent-depth)
                            (string-to-char " ")
               )
           )
           (insert (eee-templates:apply-map text))
           (if (equal eee-templates:current-template-is-multiline t)
               (insert "\n")
           )
       )
  )
)

(defun eee-templates:ask-user-for-option (options)
  (let ( (prompt "")
         (i 0)
       )
       (progn
           (dolist (opt options prompt)
               (progn
                   (setq prompt
                       (concat prompt (number-to-string i) ": " opt "\n")
                   )
                   (setq i (+ i 1))
               )
           )
           (let ( (selection (string-to-number
                                 (read-string (concat "Select:\n\n" prompt))
                             )
                  )
                )
                (nth selection options)
           )
       )
  )
)

(defun eee-templates:do-selection (options)
  (let ( (choice (eee-templates:ask-user-for-option options))
       )
       (progn
           (insert (concat "«" choice "»"))
           (eee-templates:goto-prev-fill-in)
           (eee-templates:expand-current-fill-in)
       )
  )
)

(defun eee-templates:expand-fill-in (template)
  (if template
      (progn
          (if (not (member (char-to-string (char-before)) '("«" " " "\n")))
              (backward-word 1)
          )
          (kill-word 1)
          (if (string= (char-to-string (char-before)) "«")
              (progn
                  (backward-char)
                  (delete-char 2)
              )
          )
          (if (and (stringp (car template))(string= (car template) "???"))
              (eee-templates:do-selection (cdr template))
              (progn
                  (setq eee-templates:current-point (point))
                  (setq eee-templates:current-start-column (current-column))
                  (eee-templates:build-fillin-map template)
                  (setq eee-templates:current-template-is-multiline
                      (> (length template) 1)
                  )
                  (mapcar 'eee-templates:insert-template-line template)
                  (goto-char eee-templates:current-point)
              )
          )
      )
  )
)

(defun eee-templates:lookup-key (key value)
  (let ( (keylen (length eee-templates:current-key))
         (testkey eee-templates:current-key)
       )
       (if (equal (compare-strings testkey 0 keylen key 0 keylen) t)
           (setq eee-templates:current-possible-fill-ins
               (push key eee-templates:current-possible-fill-ins)
           )
       )
  )
)

(defun eee-templates:ask-for-fill-in (keys table)
  (gethash (eee-templates:ask-user-for-option keys) table nil)
)

(defun eee-templates:select-fill-in (key table)
  (setq eee-templates:current-possible-fill-ins '())
  (setq eee-templates:current-key key)
  (maphash 'eee-templates:lookup-key table)
  (if (< (length eee-templates:current-possible-fill-ins) 2)
      (gethash (car eee-templates:current-possible-fill-ins) table nil)
      (let ( (found (gethash key table nil))
           )
           (if (not (equal found nil))
               found
               (eee-templates:ask-for-fill-in
                   eee-templates:current-possible-fill-ins table
               )
           )
      )
  )

)

(defun eee-templates:expand-current-fill-in ()
  (interactive)
  (let ((mode    (eee-templates:get-current-mode-key))
        (fill-in (eee-templates:get-current-fill-in))
       )
       (let ((templ-table
                (symbol-value (intern (concat "eee-templates-" mode "-map")))
             )
            )
            (eee-templates:expand-fill-in
                (eee-templates:select-fill-in fill-in templ-table)
            )
       )

  )
)

(global-set-key [blue ?n] 'eee-templates:goto-next-fill-in)
(global-set-key [blue ?p] 'eee-templates:goto-prev-fill-in)
(global-set-key [blue ?k] 'eee-templates:kill-active-fill-in)
(global-set-key [blue ?e] 'eee-templates:expand-current-fill-in)
(global-set-key [blue ?r] 'eee-templates:erase-active-fill-in)






