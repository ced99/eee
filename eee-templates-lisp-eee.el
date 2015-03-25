(eee-templates:define-template-selection "lisp" "template"
    '("expansion" "selection" "alias")
)

(eee-templates:define-template-expansion "lisp" "alias"
    '( (0 "(eee-templates:define-template-alias \"«!mode!»\" \"«!alias!»\" \"«!real!»\")")
     )
)

(eee-templates:define-template-expansion "lisp" "selection"
    '( (0 "(eee-templates:define-template-selection \"«!mode!»\" \"«!name!»\"")
       (1 "'()")
       (0 ")")
     )
)

(eee-templates:define-template-expansion "lisp" "expansion"
    '( (0 "(eee-templates:define-template-expansion \"«!mode!»\" \"«!name!»\"")
       (1 "'( «explines»")
       (1 " )")
       (0 ")")
     )
)

(eee-templates:define-template-expansion "lisp" "explines"
    '( (0 "(«!level!» \"«!line!»\")")
       (0 "«explines»")
     )
)
