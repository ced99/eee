(defun eee-buffer:revert-current-buffer ()
  (interactive)
  (revert-buffer t t t)
)

(defun eee-buffer:revert-one-buffer (buffer)
  (switch-to-buffer buffer)
  (if
      (buffer-file-name buffer)
      (eee-buffer:revert-current-buffer)
  )
)

(defun eee-buffer:revert-all-buffers ()
  (interactive)
  (setq eee-buffer:my-current-buffer (current-buffer))
  (mapcar 'eee-buffer:revert-one-buffer (buffer-list))
  (switch-to-buffer eee-buffer:my-current-buffer)
  (message "All buffers reverted")
)

(global-set-key [red ?r]     'eee-buffer:revert-current-buffer)
(global-set-key [red red ?r] 'eee-buffer:revert-all-buffers)

(defun eee-buffer:prepend-to-buffer-name (current prefixlist namelist)
  (if (member current namelist)
      (progn
          (eee-buffer:prepend-to-buffer-name
              (concat (car prefixlist) ":" current)
              (cdr prefixlist) namelist
          )
      )
      current
  )
)

(defun eee-buffer:list-without (elem list)
  (if (> (length list) 0)
      (if (equal elem (car list))
          (eee-buffer:list-without elem (cdr list))
          (cons (car list) (eee-buffer:list-without elem (cdr list)))
      )
      list
  )
)

(defun eee-buffer:unify-buffer-name ()
  (let ( (filename (buffer-file-name))
         (current (car (split-string (buffer-name) "<")))
         (namelist
             (eee-buffer:list-without (buffer-name)
                 (mapcar 'buffer-name (buffer-list))
             )
         )
       )
       (rename-buffer
           (eee-buffer:prepend-to-buffer-name
               current
               (cdr (reverse (split-string filename "/")))
               namelist
           )
       )
  )
)

(add-hook 'find-file-hooks 'eee-buffer:unify-buffer-name)

;; Wrapper for setting the coding system
(defun eee-buffer:set-coding-system ()
    (interactive)
    (set-buffer-file-coding-system 'iso-8859-1 nil)
)

(global-set-key [red ?c] 'eee-buffer:set-coding-system)
(global-set-key [red ?#] 'comment-or-uncomment-region)

(setq eee-buffer:sensitive-file-types '(".tfo" ".meta" ".bin"))

(defun eee-buffer:delete-trailing-whitespace ()
  (interactive)
  (let ( (filename (buffer-file-name)) )
    (unless (string-match (regexp-opt eee-buffer:sensitive-file-types) filename)
      (delete-trailing-whitespace)
      )
    )
  )
(global-set-key [red ?w] 'eee-buffer:delete-trailing-whitespace)

;; Define various hooks
(add-hook 'write-file-hooks 'eee-buffer:delete-trailing-whitespace)
