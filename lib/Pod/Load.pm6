use v6.c;
unit module Pod::Load:ver<0.0.3>;

=begin pod

=head1 NAME

Pod::Load - Loads and compiles the Pod documentation of an external file

=head1 SYNOPSIS

    use Pod::Load;

    # Read a file handle.
    my $pod = load("file-with.pod6".IO);
    say $pod.perl; # Process it as a Pod

    my $string-with-pod = q:to/EOH/;
    =begin pod
    This ordinary paragraph introduces a code block:
    =end pod
    EOH

    say load( $string-with-pod ).perl;

=head1 DESCRIPTION

Pod::Load is a module with a simple task: obtain the documentation of an external file in a standard, straighworward way. Its mechanism is inspired by L<C<Pod::To::BigPage>|https://github.com/perl6/perl6-pod-to-bigpage>, from where the code to use the cache is taken from.

=head1 AUTHOR

JJ Merelo <jjmerelo@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2018 JJ Merelo

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

use nqp;

$*TMPDIR.add('perl6-pod-load');
mkdir("/tmp/perl6-pod-load") if ! "/tmp/perl6-pod-load".IO.e;

#| Loads a string, returns a Pod.
multi sub load ( Str $string ) is export {
    my $initials= $string.words.map( *.substr(1,1) )[^128]:v;
    my $id = "/tmp/perl6-pod-load/"~ $initials.join("") ~ ".pod6";
    spurt $id, $string;
    return load( $id.IO );
}

#| Loads a IO::Path, returns a Pod. Taken from pod2onepage
multi sub load ( IO::Path $io ) is export {
    my $file = $io.path;
    my $precomp-store = CompUnit::PrecompilationStore::File.new(prefix => "/tmp/perl6-pod-load/".IO);
    my $precomp = CompUnit::PrecompilationRepository::Default.new(store => $precomp-store);
    my $id = nqp::sha1(~$file);
    my $handle = $precomp.load($id)[0];
    without $handle {
        $precomp.precompile($io, $id, :force);
        $handle = $precomp.load($id)[0] // fail("Could not precompile $file");
    }

    return nqp::atkey($handle.unit,'$=pod')[0];

}
