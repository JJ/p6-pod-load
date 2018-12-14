use v6.c;
use Test;
use Pod::Load;

for <test.pod6 class.pm6> -> $file {
    my $pod = load( $file );
    ok( $pod, "$file load returns something" );
    like( $pod.^name, /Pod\:\:/, "That something is a Pod");
    $pod = load( $file );
    ok( $pod, "$file load returns something and is cached" );
}

done-testing;
