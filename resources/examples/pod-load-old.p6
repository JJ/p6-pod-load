#!/usr/bin/env raku

use v6;

use MONKEY-SEE-NO-EVAL;

my $pod = "pod-load-clean.pod6".IO.slurp;
dd EVAL("$pod\n\n\$=pod;").perl;
