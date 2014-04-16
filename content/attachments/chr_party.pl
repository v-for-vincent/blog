:- module(party, [party/0]).
:- use_module(library(chr)).

:- chr_constraint party/0, sleepy/0, headache/0.

==>(party,sleepy).
party ==> headache.
