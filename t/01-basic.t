use v6.c;
use Test;
use Pod::Load;


my $string-with-pod = q:to/EOH/;
=begin pod
This ordinary paragraph introduces a code block:
    $this = 1 * code('block');
    $which.is_specified(:by<indenting>);
=end pod
EOH
my $pod = load( $string-with-pod );
ok( $pod, "String load returns something" );
like( $pod.^name, /Pod\:\:/, "That something is a Pod");

for <test.pod6 class.pm6> -> $file {
    say "Testing files";
    my $prefix = $file.IO.e??"./"!!"t/";
    my $io = ( $prefix ~ $file ).IO;
    my $pod = load( $io );
    ok( $pod, "$file load returns something" );
    like( $pod.^name, /Pod\:\:/, "That something is a Pod");
    $pod = load( $io );
    ok( $pod, "$file load returns something and is cached" );

}


done-testing;
