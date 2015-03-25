(eee-templates:init-templates "c++")
(eee-templates:inherit-templates "c++" "c")

(eee-templates:define-template-expansion "c++" "class"
    '( (0 "class «!name!» : public «!ancestor!»")
       (0 "{")
       (0 " public:")
       (1 "«!name!»(void);")
       (1 "~«!name!»(void);")
       (1 "")
       (0 "private:")
       (1 "")
       (0 "};")
     )
)

(eee-templates:define-template-expansion "c++" "iterate"
    '( (0 "for («!seqtype!»::iterator cur = «!seq!».begin();")
       (0 "     cur != «!seq!».end(); cur++) {")
       (1 "")
       (0 "}")
     )
)

