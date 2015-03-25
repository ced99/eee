(eee-templates:init-templates "lisp")

(eee-templates:define-template-expansion "lisp" "defun"
    '( (0 "(defun «!name!» ()")
       (1 "«interactive»")
       (1 "«statements»")
       (0 ")")
     )
)

(eee-templates:define-template-expansion "lisp" "interactive"
    '( (0 "(interactive)")
     )
)

(eee-templates:define-template-expansion "lisp" "statements"
      '( (0 "«statement»")
         (0 "«statements»")
       )
)

(eee-templates:define-template-selection "lisp" "statement"
    ' ( "if"
        "progn"
        "while"
        "dolist"
        "dotimes"
        "let"
      )
)

(eee-templates:define-template-alias "lisp" "else" "statement")

(eee-templates:define-template-expansion "lisp" "if"
    '( (0 "(if («condition»)")
       (1 "«statement»")
       (1 "«else»")
       (0 ")")
     )
)

(eee-templates:define-template-selection "lisp" "condition"
    '( "not" "and" "or"
     )
)

(eee-templates:define-template-expansion "lisp" "not"
    '( (0 "(not «condition»)")
     )
)

(eee-templates:define-template-expansion "lisp" "and"
    '( (0 "(and «codition» «condition»)")
     )
)

(eee-templates:define-template-expansion "lisp" "or"
    '( (0 "(or «codition» «condition»)")
     )
)

(eee-templates:define-template-expansion "lisp" "progn"
    '( (0 "(progn")
       (1 "«statements»")
       (0 ")")
     )
)

(eee-templates:define-template-expansion "lisp" "while"
    '( (0 "(while «condition»")
       (1 "«statements»")
       (0 ")")
     )
)

(eee-templates:define-template-expansion "lisp" "dolist"
    '( (0 "(dolist ()")
       (1 "«statements»")
       (0 ")")
     )
)

(eee-templates:define-template-expansion "lisp" "dotimes"
    '( (0 "(dotimes ()")
       (1 "«statements»")
       (0 ")")
     )
)

(eee-templates:define-template-expansion "lisp" "let"
    '( (0 "(let")
       (1 "( «bindings»")
       (1 ")")
       (1 "«statements»")
       (0 ")")
     )
)
(eee-templates:define-template-expansion "lisp" "bindings"
      '( (0 "()")
         (0 "«bindings»")
       )
)


