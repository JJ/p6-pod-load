#| Exception representing errors in the source of any kind
unit class X::Pod::Load::SourceErrors is Exception;

has $.error;
method message { $!error }
