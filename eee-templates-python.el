(eee-templates:init-templates "python")

(eee-templates:define-template-expansion "python" "def"
    '( (0 "def «!name!» () :")
       (1 "")
       (0 "# end def «!name!»")
     )
)

(eee-templates:define-template-expansion "python" "md"
    '( (0 "def «!name!» (self) :")
       (1 "")
       (0 "# end def «!name!»")
     )
)

(eee-templates:define-template-expansion "python" "class"
    '( (0 "class «!name!» () :")
       (1 "")
       (1 "«new»")
       (1 "«init»")
       (1 "«call»")
       (1 "")
       (0 "# end class «!name!»")
     )
)

(eee-templates:define-template-expansion "python" "new"
    '( (0 "def __new__ (cls) :")
       (1 "")
       (0 "# end def __new__")
     )
)

(eee-templates:define-template-expansion "python" "init"
    '( (0 "def __init__ (self) :")
       (1 "")
       (0 "# end def __init__")
     )
)

(eee-templates:define-template-expansion "python" "call"
    '( (0 "def __call__ (self) :")
       (1 "")
       (0 "# end def __call__")
     )
)

(eee-templates:define-template-expansion "python" "tflclass"
    '( (0 "class «!name!» (TFL.Meta.Object) :")
       (1 "")
       (1 "def __init__ (self) :")
       (2 "self.__super.__init__ ()")
       (1 "# end def __init__")
       (1 "")
       (0 "# end class «!name!»")
     )
)

(eee-templates:define-template-expansion "python" "tflmclass"
    '( (0 "class «!name!» (TFL.Meta.M_Class) :")
       (1 "")
       (1 "«metainit»")
       (1 "«metanew»")
       (1 "«metacall»")
       (1 "")
       (0 "# end class «!name!»")
     )
)

(eee-templates:define-template-expansion "python" "metainit"
    '( (0 "def __init__ (cls, name, bases, dict) :")
       (1 "super («!mclsname!», cls).__init__ (name, bases, dict)")
       (0 "# end def __init__")
     )
)

(eee-templates:define-template-expansion "python" "metanew"
    '( (0 "def __new__ (meta, name, bases, dict) :")
       (1 "result = super («!mclsname!», meta).__new__ (name, bases, dict)")
       (1 "return result")
       (0 "# end def __new__")
     )
)

(eee-templates:define-template-expansion "python" "metacall"
    '( (0 "def __call__ (cls) :")
       (1 "result = super («!mclsname!», cls).__call__ ()")
       (1 "return result")
       (0 "# end def __call__")
     )
)
