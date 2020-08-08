[![Build Status](https://travis-ci.com/JJ/p6-pod-load.svg?branch=master)](https://travis-ci.com/JJ/p6-pod-load) [![Build status](https://ci.appveyor.com/api/projects/status/lq9rqjq6hljdfqw4?svg=true)](https://ci.appveyor.com/project/JJ/p6-pod-load)

NAME
====

Pod::Load - Loads and compiles the Pod documentation of an external file

SYNOPSIS
========

    use Pod::Load;

    # Read a file handle.
    my $pod = load("file-with.pod6".IO);
    say $pod.perl; # Process it as a Pod

    # Or use simply the file name
    my @pod = load("file-with.pod6");
    say .perl for @pod;

    my $string-with-pod = q:to/EOH/;

This ordinary paragraph introduces a code block:

EOH

    say load( $string-with-pod ).perl;

DESCRIPTION
===========

Pod::Load is a module with a simple task: obtain the documentation of an external file in a standard, straighworward way. Its mechanism is inspired by [`Pod::To::BigPage`](https://github.com/perl6/perl6-pod-to-bigpage), from where the code to use the cache is taken from.

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

Copyright 2018, 2019 JJ Merelo

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

