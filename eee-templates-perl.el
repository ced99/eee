(eee-templates:init-templates "perl")

(eee-templates:define-template-expansion "perl" "sub"
    '( (0 "sub «!name!» {")
       (1 "")
       (0 "}")
     )
)

(eee-templates:define-template-expansion "perl" "msub"
    '( (0 "sub «!name!» {")
       (1 "my $self = shift;")
       (1 "")
       (0 "}")
     )
)

(eee-templates:define-template-expansion "perl" "mooseclass"
    '( (0 "package «!classname!»")
       (0 "")
       (0 "use Carp;")
       (0 "use Moose;")
       (0 "use namespace::autoclean;")
       (0 "")
       (0 "__PACKAGE__->meta->make_immutable;")
       (0 "")
       (0 "1;")
     )
)

(eee-templates:define-template-expansion "perl" "mooserole"
    '( (0 "package «!rolename!»")
       (0 "")
       (0 "use Carp;")
       (0 "use Moose::Role;")
       (0 "use namespace::autoclean;")
       (0 "")
       (0 "1;")
     )
)

(eee-templates:define-template-selection "perl" "moose"
    '( "mooseclass"
       "mooserole"
     )
)

(eee-templates:define-template-expansion "perl" "eval"
    '( (0 "eval {")
       (0 "")
       (1 "1;")
       (0 "} or do {")
       (1 "")
       (0 "}")
     )
)
