(eee-templates:init-templates "c")

(eee-templates:define-template-expansion "c" "function"
    '( (0 "«!retval!» «!name!» ()")
       (0 "{")
       (1 "")
       (0 "}")
     )
)

(eee-templates:define-template-expansion "c" "if"
    '( (0 "if () {")
       (1 "")
       (0 "}")
     )
)

(eee-templates:define-template-expansion "c" "for"
    '( (0 "for () {")
       (1 "")
       (0 "}")
     )
)

(eee-templates:define-template-expansion "c" "fori"
    '( (0 "for (i = «!start!»; i < «!limit!»; i++) {")
       (1 "")
       (0 "}")
     )
)

(eee-templates:define-template-expansion "c" "switch"
    '( (0 "switch («!expr!») {")
       (1 "«cases»")
       (1 "«defaultcase»")
       (0 "  }")
     )
)

(eee-templates:define-template-expansion "c" "cases"
    '( (0 "case «!case!» :")
       (1 "")
       (1 "break;")
       (0 "«cases»")
     )
)

(eee-templates:define-template-expansion "c" "defaultcase"
    '( (0 "default :")
       (1 "")
       (1 "break;")
     )
)
