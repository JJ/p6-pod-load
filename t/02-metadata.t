use v6.c;
use Test;
use Pod::Load;

diag "Testing strings with metadata";
my $string-with-pod = q:to/EOH/;
=begin pod :3ver
This ordinary paragraph introduces a code block:
    $this = 1 * code('block');
    $which.is_specified(:by<indenting>);
=end pod
EOH

my @pod = load( $string-with-pod );
ok( @pod, "String load returns something" );
like( @pod[0].^name, /Pod\:\:/, "The first element of that is a Pod");
dd @pod[0].config;
is( @pod[0].config, {:ver}, "Config passed" );
done-testing;
