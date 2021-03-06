(eee-templates:define-template-expansion "c++" "qtclass"
    '( (0 "class «!name!» : public «!ancestor!»")
       (0 "{")
       (1 "Q_OBJECT;")
       (0 "")
       (0 "public:")
       (1 "«!name!»(QWidget *parent = 0);")
       (1 "~«!name!»(void);")
       (1 "")
       (0 "private:")
       (1 "")
       (0 "};")
     )
)

(eee-templates:define-template-expansion "c++" "qtclassimpl"
    '( (0 "«!name!»::«!name!»(QWidget *parent)")
       (1 " :«!ancestor!»(parent)")
       (0 "{")
       (0 "")
       (0 "}")
       (0 "")
       (0 "«!name!»::«!name!»(QWidget *parent)")
       (1 " :«!ancestor!»(parent)")
       (0 "{")
       (0 "}")
     )
)

(eee-templates:define-template-expansion "c++" "qtconnect"
    '( (0 "connect(«!source!», SIGNAL(«!signal!»()),")
       (0 "        this, SLOT(«!slot!»()));")
     )
)

