use v6.c;
unit module Pod::Load:ver<0.5.1>;

=begin pod

=head1 NAME

Pod::Load - Loads and compiles the Pod documentation of an external file

=head1 SYNOPSIS

    use Pod::Load;

    # Read a file handle.
    my $pod = load("file-with.pod6".IO);
    say $pod.perl; # Process it as a Pod

    # Or use simply the file name
    my @pod = load("file-with.pod6");
    say .perl for @pod;

    my $string-with-pod = q:to/EOH/;
    =begin pod
    This ordinary paragraph introduces a code block:
    =end pod
    EOH

    say load( $string-with-pod ).perl;

You can also reconfigure the global variables. However, if you change one you'll have to change the whole thing. N<In the future, I might come up with a better way of doing this...>

    $Pod::Load::tmp-dir= "/tmp/my-precomp-dir/";
    $Pod::Load::precomp-store = CompUnit::PrecompilationStore::File.new(prefix => $Pod::Load::tmp-dir.IO);
    $Pod::Load::precomp = CompUnit::PrecompilationRepository::Default.new(store => $Pod::Load::precomp-store);

=head1 DESCRIPTION

Pod::Load is a module with a simple task:
obtaining the documentation of an external file in a standard,
straighworward way. Its mechanism is inspired by
L<C<Pod::To::BigPage>|https://github.com/perl6/perl6-pod-to-bigpage>.

=head1 AUTHOR

JJ Merelo <jjmerelo@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2018,2019 JJ Merelo

This library is free software; you can redistribute it and/or modify
                               it under the Artistic License 2.0. 

=end pod

use MONKEY-SEE-NO-EVAL;

#| Loads a string, returns a Pod.
multi sub load ( Str $string ) is export {
    my $module-name = "m{rand}";
    $module-name ~~ s/\.//;
    my @pod = (EVAL ("module $module-name \{\n" ~ $string ~ "\}\n\$=pod"));
    return @pod;
}

#| If it's an actual filename, loads a file and returns the pod
multi sub load( Str $file where .IO.e ) {
    return load( $file.IO );
}

#| Loads a IO::Path, returns a Pod. (Originally) from pod2onepage
multi sub load ( IO::Path $io ) is export {
    return load($io.slurp);
}
