use Test;

use Pod::Load;
use X::Pod::Load::SourceErrors;
my $file = "gather.raku".IO.e??"./gather.raku"!!"t/gather.raku";

throws-like {
    my @pod = load( $file );
}, X::Pod::Load::SourceErrors, message => /lib/, "Throwing errors correctly";

done-testing;
