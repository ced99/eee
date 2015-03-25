(global-set-key [pink ?t]           'transpose-chars)
(global-set-key [pink pink ?t]      'transpose-words)
(global-set-key [pink pink pink ?t] 'transpose-lines)
(global-set-key [pink ?1]           'just-one-space)

(defun eee-text:backward-non-whitespace ()
    (if
        (re-search-backward "[^ \t\n]" nil t)
        (backward-char)
    )
)

(defun eee-text:forward-non-whitespace ()
    (if
        (re-search-forward "[^ \t\n]" nil t)
        (backward-char)
    )
)

(defun eee-text:is_whitespace (c)
  (if (equal c nil)
      t
      (member (char-to-string c) '(" " "\t" "\n"))
  )
)

(defun eee-text:is_identifier_char (c)
  (if (equal c nil)
      nil
      (member (char-to-string c)
              '("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o"
                "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "A" "B" "C" "D" "E"
                "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T"
                "U" "V" "W" "X" "Y" "Z" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"
                "ä" "ö" "ü" "Ä" "Ö" "Ü" "_" "-" "ß"))
  )
)

(defun eee-text:empty-region (l r)
  (or (> l r)
      (and (eee-text:is_whitespace (char-after l))
           (eee-text:empty-region (+ l 1) r)
      )
  )
)

(defun eee-text:empty-line ()
  (eee-text:empty-region (line-beginning-position) (line-end-position))
)

(defun eee-text:kill-whole-line ()
  (beginning-of-line)
  (kill-line)
)

(defun eee-text:insert-alignment (linedir)
  (setq eee-text:current-point (point))
  (setq eee-text:current-col (current-column))
  (line-move linedir)
  (move-to-column eee-text:current-col)
  (setq eee-text:dest-col
      (re-search-forward "[ \t][^ \t\n]" (line-end-position) t)
  )
  (if (not (equal eee-text:dest-col nil))
      (setq eee-text:dest-col (- (current-column) 1))
  )
  (goto-char eee-text:current-point)
  (if (not (equal eee-text:dest-col nil))
      (progn
          (setq eee-text:num-spaces (- eee-text:dest-col (current-column)))
          (if (> eee-text:num-spaces 0)
              (insert
                  (make-string eee-text:num-spaces
                      (string-to-char " ")
                  )
              )
          )
      )
  )
)

(defun eee-text:insert-alignment-from-above ()
  (interactive)
  (eee-text:insert-alignment -1)
 )

(defun eee-text:insert-alignment-from-below ()
  (interactive)
  (eee-text:insert-alignment 1)
 )

(global-set-key [pink tab]      'eee-text:insert-alignment-from-above)
(global-set-key [pink pink tab] 'eee-text:insert-alignment-from-below)

(defun eee-text:delete-empty-lines ()
  (if (eee-text:empty-line)
      (progn
          (eee-text:kill-whole-line)
          (eee-text:delete-empty-lines)
      )
  )
)

(defun eee-text:delete-superflous-empty-lines ()
  (interactive)
  (if (eee-text:empty-line)
      (progn
        (eee-text:backward-non-whitespace)
        (next-line 1)
        (eee-text:delete-empty-lines)
        (insert "\n")
      )
  )
)

(global-set-key [pink ?k]      'eee-text:delete-superflous-empty-lines)


(defun eee-text:kill-backward-whitespace (n)
  (if (eee-text:is_whitespace (char-before (point)))
      (progn
         (if n
          (backward-delete-char n)
          (backward-char)
         )
         (eee-text:kill-backward-whitespace n)
      )
  )
)

(defun eee-text:kill-backward-chars (n)
  (if (eee-text:is_identifier_char (char-before (point)))
      (progn
         (if n
          (backward-delete-char n)
          (backward-char)
         )
         (eee-text:kill-backward-chars n)
      )
  )
)

(defun eee-text:kill-backward-symbols (n)
  (if (not (or (eee-text:is_whitespace (char-before (point)))
               (eee-text:is_identifier_char (char-before (point)))))
      (progn
         (if n
          (backward-delete-char n)
          (backward-char)
         )
         (eee-text:kill-backward-symbols n)
      )
  )
)

(defun eee-text:kill-forward-whitespace (n)
  (if (eee-text:is_whitespace (char-after (point)))
      (progn
         (if n
          (delete-char n)
          (forward-char)
         )
         (eee-text:kill-forward-whitespace n)
      )
  )
)

(defun eee-text:kill-forward-chars (n)
  (if (eee-text:is_identifier_char (char-after (point)))
      (progn
         (if n
          (delete-char n)
          (forward-char)
         )
         (eee-text:kill-forward-chars n)
      )
  )
)

(defun eee-text:kill-forward-symbols (n)
  (if (not (or (eee-text:is_whitespace (char-after (point)))
               (eee-text:is_identifier_char (char-after (point)))))
      (progn
         (if n
          (delete-char n)
          (forward-char)
         )
         (eee-text:kill-forward-symbols n)
      )
  )
)

(defun eee-text:kill-backward-thing ()
  (interactive)
  (if (eee-text:is_whitespace (char-before (point)))
      (eee-text:kill-backward-whitespace t)
      (if (eee-text:is_identifier_char (char-before (point)))
          (eee-text:kill-backward-chars t)
          (eee-text:kill-backward-symbols t)
      )
  )
)

(defun eee-text:kill-forward-thing ()
  (interactive)
  (if (eee-text:is_whitespace (char-after (point)))
      (eee-text:kill-forward-whitespace t)
      (if (eee-text:is_identifier_char (char-after (point)))
          (eee-text:kill-forward-chars t)
          (eee-text:kill-forward-symbols t)
      )
  )
)

(defun eee-text:move-backward-thing ()
  (interactive)
  (if (eee-text:is_whitespace (char-before (point)))
      (eee-text:kill-backward-whitespace nil)
      (if (eee-text:is_identifier_char (char-before (point)))
          (eee-text:kill-backward-chars nil)
          (eee-text:kill-backward-symbols nil)
      )
  )
)

(defun eee-text:move-forward-thing ()
  (interactive)
  (if (eee-text:is_whitespace (char-after (point)))
      (eee-text:kill-forward-whitespace nil)
      (if (eee-text:is_identifier_char (char-after (point)))
          (eee-text:kill-forward-chars nil)
          (eee-text:kill-forward-symbols nil)
      )
  )
)

(global-set-key [pink backspace] 'eee-text:kill-backward-thing)
(global-set-key [pink delete]    'eee-text:kill-forward-thing)
(global-set-key [pink left]      'eee-text:move-backward-thing)
(global-set-key [pink right]     'eee-text:move-forward-thing)






