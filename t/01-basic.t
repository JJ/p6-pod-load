use v6.c;
use Test;
use Pod::Load;

sub do-the-test() {
    diag "Testing strings";
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
    
    diag "Testing files";
    for <test.pod6 class.pm6> -> $file {
        my $prefix = $file.IO.e??"./"!!"t/";
        my $file-name = $prefix ~ $file;
        $pod = load( $file-name );
        ok( $pod, "$file-name load returns something" );
        like( $pod.^name, /Pod\:\:/, "That something is a Pod");
        my $io = $file-name.IO;
        $pod = load( $io );
        ok( $pod, "$file load returns something" );
        like( $pod.^name, /Pod\:\:/, "That something is a Pod");
        $pod = load( $io );
        ok( $pod, "$file load returns something and is cached" );
        
    }
}

do-the-test(); # Use default values
$Pod::Load::tmp-dir= "/tmp/my-precomp-dir/";
mkdir($tmp-dir) if ! $Pod::Load::tmp-dir.IO.e;
$Pod::Load::precomp-store = CompUnit::PrecompilationStore::File.new(prefix => $Pod::Load::tmp-dir.IO);
$Pod::Load::precomp = CompUnit::PrecompilationRepository::Default.new(store => $Pod::Load::precomp-store);
diag( "Changing default values" );
do-the-test(); # Use these new values.

done-testing;
