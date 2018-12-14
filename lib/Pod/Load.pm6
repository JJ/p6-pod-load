use v6.c;
unit module Pod::Load:ver<0.0.2>;

=begin pod

=head1 NAME

Pod::Load - Loads and compiles the Pod documentation of an external file

=head1 SYNOPSIS

    use Pod::Load;

    my $pod = load("file-with.pod6");
    say $pod.perl; # Process it as a Pod

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

#| Loads a file, returns a Pod. Taken from pod2onepage
multi sub load ( $file where .IO.e ) is export {
    return load( $file.IO );
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
