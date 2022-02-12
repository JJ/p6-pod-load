[![Build
status](https://ci.appveyor.com/api/projects/status/lq9rqjq6hljdfqw4?svg=true)](https://ci.appveyor.com/project/JJ/p6-pod-load) 
[![Test in a Raku container](https://github.com/JJ/p6-pod-load/actions/workflows/test.yaml/badge.svg)](https://github.com/JJ/p6-pod-load/actions/workflows/test.yaml)

NAME
====

Pod::Load - Loads and compiles the Pod documentation of an external file

SYNOPSIS
========

    use Pod::Load;
    use X::Pod::Load::SourceErrors;

    # Try to parse a string
    say pod-load(<<EOP).raku;
    =head1 Header
    
    =head2 Another header
    EOP
    
    # Read a file handle.
    my $pod = load("file-with.pod6".IO);
    say $pod.raku; # Process it as a Pod

    # Or use simply the file name
    my @pod = load("file-with.pod6");
    say .raku for @pod;

    # Or a string
    @pod = load("=begin pod\nThis could be a comment with C<code>\n=end pod");

    # Or ditch the scaffolding and use the string directly:
    @pod = load-pod("This could be a comment with C<code>");
    
    # If there's an error, it will throw X::Pod::Load::SourceErrors

DESCRIPTION
===========

Pod::Load is a module with a simple task: obtain the documentation of an
external file in a standard, straighworward way.

Its mechanism was originally inspired by
[`Pod::To::BigPage`](https://github.com/perl6/perl6-pod-to-bigpage), from where
the code to use the cache was taken from.

### multi sub load

```perl6
multi sub load(
    Str $string
) returns Mu
```

Loads a string, returns a Pod.

### multi sub load

```perl6
multi sub load(
    Str $file where { ... }
) returns Mu
```

If it's an actual filename, loads a file and returns the pod

### multi sub load

```perl6
multi sub load(
    IO::Path $io
) returns Mu
```

Loads a IO::Path, returns a Pod.

## INSTALL

Do the usual:

    zef install .

to install this if you've made any modification.

INSTRUCTIONS
============

This is mainly a reminder to myself, although it can help you if you create a distribution just like this one.

Write:

    export VERSION=0.x.x

And

    make dist

To create a tar file ready for CPAN.

AUTHOR
======

JJ Merelo <jjmerelo@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2018, 2019, 2020 JJ Merelo

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

