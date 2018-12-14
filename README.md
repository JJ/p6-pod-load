[![Build Status](https://travis-ci.org/JJ/p6-pod-load.svg?branch=master)](https://travis-ci.org/JJ/p6-pod-load)

NAME
====

Pod::Load - Loads and compiles the Pod documentation of an external file

SYNOPSIS
========

    use Pod::Load;

    my $pod = load("file-with.pod6");
    say $pod.perl; # Process it as a Pod

DESCRIPTION
===========

Pod::Load is a module with a simple task: obtain the documentation of an external file in a standard, straighworward way. Its mechanism is inspired by [`Pod::To::BigPage`](https://github.com/perl6/perl6-pod-to-bigpage), from where the code to use the cache is taken from.

AUTHOR
======

JJ Merelo <jjmerelo@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2018 JJ Merelo

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

### multi sub load

```perl6
multi sub load(
    $file where { ... }
) returns Mu
```

Loads a file, returns a Pod. Taken from pod2onepage

### multi sub load

```perl6
multi sub load(
    IO::Path $io
) returns Mu
```

Loads a IO::Path, returns a Pod. Taken from pod2onepage

