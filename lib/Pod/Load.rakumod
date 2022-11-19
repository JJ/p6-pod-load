use v6.c;
unit module Pod::Load:ver<0.7.2>;

use X::Pod::Load::SourceErrors;

=begin pod

=head1 NAME

Pod::Load - Loads and compiles the Pod documentation from a string, file or
filehandle.

=head1 SYNOPSIS

    use Pod::Load;

    # Read a file handle.
    my $pod = load("file-with.pod6".IO);
    say $pod.perl; # Process it as a Pod

    # Or use simply the file name (it should exist)
    my @pod = load("file-with.pod6");
    say .perl for @pod;

    my $string-with-pod = q:to/EOH/;
    =begin pod
    This ordinary paragraph introduces a code block:
    =end pod
    EOH

    say load( $string-with-pod ).perl;

=head1 DESCRIPTION

C<Pod::Load> is a module with a simple task (and interface):
obtaining the documentation tree of an external file in a standard,
straighworward way. Its mechanism (using EVAL) is inspired by
L<C<Pod::To::BigPage>|https://github.com/perl6/perl6-pod-to-bigpage>,
although it will use precompilation in case of files.

=head1 CAVEATS

The pod is obtained from the file or string via EVAL. That means that
it's going to run what is actually there. If you don't want that to
happen, strip all runnable code from the string (or file) before
submitting it to C<load>.

=head1 AUTHOR

JJ Merelo <jjmerelo@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2018,2019,2020 JJ Merelo

This library is free software; you can redistribute it and/or modify
it under the Artistic License 2.0. 

=end pod

use MONKEY-SEE-NO-EVAL;
use File::Temp; # For tempdir below

#| The string here should be valid Pod markup, without the enclosing stuff
sub load-pod( Str $string ) is export {
    return load(qq:to/EOP/);
=begin pod
$string
=end pod
EOP
}

#| Loads a Raku code string, returns the Pod that could be included in it
multi sub load ( Str $string ) is export {
    my $module-name = "m{rand}";
    my $copy = $string;
    $module-name ~~ s/\.//;
    $copy ~~ s/"use" \s+ "v6;"//;
    my @pod;
    if $copy ~~ /^^"="output/ {
        my @chunks = $copy.split( /"="output/ );
        @pod = (EVAL ("module $module-name \{\n" ~ @chunks[0] ~ "\}\n\$=pod;\n\n=output@chunks[1]"));
    } else {
        @pod = (EVAL ("module $module-name \{\n" ~ $copy ~ "\n\}\n\$=pod"));
    }
    return @pod;
}

my constant CUPSFS = ::("CompUnit::PrecompilationStore::File" ~ ("System","").first({ ::("CompUnit::PrecompilationStore::File$_") !~~ Failure }));

#| If it's an actual filename, loads a file and returns the pod
multi sub load( Str $file where .IO.e ) {
    use nqp;
    my $cache-path = tempdir;
    my $precomp-repo = CompUnit::PrecompilationRepository::Default.new(
            :store(CUPSFS.new(:prefix($cache-path.IO))),
            );
    my $handle = $precomp-repo.try-load(
            CompUnit::PrecompilationDependency::File.new(
                    :src($file),
                    :id(CompUnit::PrecompilationId.new-from-string($file)),
                    :spec(CompUnit::DependencySpecification.new(:short-name($file))),
                    )
            );
    CATCH {
        default {
            X::Pod::Load::SourceErrors.new(:error( .message.Str )).throw
        }
    }
    nqp::atkey($handle.unit, '$=pod')
}

#| Compiles a file from source
multi sub load ( IO::Path $io ) is export {
    load( $io.path )
}
