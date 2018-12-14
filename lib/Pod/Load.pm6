use v6.c;
unit package Pod::Load:ver<0.0.1>;


=begin pod

=head1 NAME

Pod::Load - blah blah blah

=head1 SYNOPSIS

  use Pod::Load;

=head1 DESCRIPTION

Pod::Load is ...

=head1 AUTHOR

JJ Merelo <jjmerelo@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2018 JJ Merelo

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

use nqp;

#| Loads a file, returns a Pod. Taken from pod2onepage
sub load ( $file where .IO.e ) is export {
    my $io = $file.IO;
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
