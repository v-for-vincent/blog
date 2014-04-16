=====================================================
Program transformation example with Compiling Control
=====================================================

:slug: compiling-control
:date: 2014-04-16 06:53:03
:category: PhD
:summary: Another side-by-side comparison, this time with an extra variant
:tags: Prolog, CHR, Coroutines, compiling control

The problem
===========

My supervisor suggested that I try to find some fresh examples.
So this time, we'll be looking at the graph coloring problem.
In addition to the naive Prolog version, the coroutining version
and the CHR variant, I've also written a transformation of the
naive version. That transformation is based on a 1986 paper which
introduces the concept of "compiling control". Basically, it takes
a nonstandard pattern of execution (like the trace of a metainterpreter)
and "compiles it in", i.e. it uses that to synthesize a standard
Prolog program with the same behaviour. Note that the transformation
is not automatic, but it is systematic. I'll be zooming in on this
technique in the next few weeks, so who knows, maybe I'll try to make
it automatic.

Standard Prolog
===============

.. code-block:: prolog

   :- module(graphcol, [coloring/2, safe_coloring/2]).
   
   % set 'global info'
   edge(belgium, netherlands).
   edge(belgium, germany).
   edge(germany, netherlands).
   
   colour(red).
   colour(green).
   colour(blue).
   
   % we only supply edges once, using lexicographical ordering
   bidirectional(X,Y) :- edge(X,Y).
   bidirectional(Y,X) :- edge(X,Y).
   
   % given a list of nodes, assign unconstrained colour to each node
   % list of nodes is ground with ground elements (and no duplicates)
   % list of colours is free
   coloring([], []).
   coloring([_NH|NT], [CH|CT]) :- colour(CH), coloring(NT, CT).
   
   % given a colour assignment, determine whether it is unsafe
   unsafe(Ns, Cs) :- nth1(Index1, Ns, N1),
                     nth1(Index1, Cs, C1),
                     length(Ns, Len),
                     IndexPlus is Index1 + 1,
                     between(IndexPlus, Len, Index2),
                     nth1(Index2, Ns, N2),
                     nth1(Index2, Cs, C2),
                     bidirectional(N1, N2),
                     C1 = C2.
   
   % nodes are specified implicitly through edges
   % backtrack will generate the same node repeatedly, so filtering is required
   node(X) :- bidirectional(X,_).
   
   % a coloring is safe if it cannot be proven unsafe
   safe_coloring(Ns, Cs) :- setof(N, node(N), Ns),
                            coloring(Ns, Cs),
                            \+unsafe(Ns, Cs).

Coroutining
===========

I wrote this version because I though it would be helpful in understanding
what I needed to do to get compiling control working. At the source-code
level, it turned out to be counterproductive, though. Because I started
thinking: "now how do I formulate this if I use compiling control?"

That isn't the question one should be asking. Compiling control looks
at the *trace*, so the techniques used here might be more suited to
the implementation of a metainterpreter. Right now, control and logic
are mixed (even more than usual in Prolog...).

.. code-block:: prolog

   :- module(graphcol, [coloring/2, safe_coloring/2]).
   
   % set 'global info'
   edge(belgium, netherlands).
   edge(belgium, germany).
   edge(germany, netherlands).
   
   colour(red).
   colour(green).
   colour(blue).
   
   % we only supply edges once, using lexicographical ordering
   bidirectional(X,Y) :- edge(X,Y).
   bidirectional(Y,X) :- edge(X,Y).
   
   % given a list of nodes, assign unconstrained colour to each node
   % list of nodes is ground with ground elements (and no duplicates)
   % list of colours is free
   % careful not to specify structure of Cs in head: coroutine would fire too quickly
   coloring([], []).
   coloring([_NH|NT], Cs) :- colour(CH), append([CH], CT, Cs), coloring(NT, CT).
   
   % given a colour assignment, determine whether it is unsafe
   unsafe(Ns, Cs) :- nth1(Index1, Ns, N1),
                     nth1(Index1, Cs, C1),
                     length(Ns, Len),
                     IndexPlus is Index1 + 1,
                     between(IndexPlus, Len, Index2),
                     nth1(Index2, Ns, N2),
                     nth1(Index2, Cs, C2),
                     bidirectional(N1, N2),
                     C1 = C2.
   
   % nodes are specified implicitly through edges
   % backtrack will generate the same node repeatedly, so filtering is required
   node(X) :- bidirectional(X,_).
   
   % a coloring is safe if it cannot be proven unsafe
   % implementation note: could also add simple auxiliary predicate to check safety of subset, but then we wouldn't have coroutining
   % program transformation of a similar flow could possibly create this predicate to achieve desired result
   safe_coloring(Ns, Cs) :- setof(N, node(N), Ns),
                            delayed_safety(Ns, Cs, []),
                            coloring(Ns, Cs).
   
   % get the first elements in a list
   beginning(_List, 0, []).
   beginning([H|T], Num, [H|ResT]) :- Num > 0,
                                      NewNum is Num - 1,
                                      beginning(T, NewNum, ResT).
   
   % check if the first Num elements of a graph coloring make the result unsafe
   first_num_unsafe(Ns, Cs, Num) :- beginning(Ns, Num, FirstNs),
                                    beginning(Cs, Num, FirstCs),
                                    unsafe(FirstNs, FirstCs).
   
   % check whenever possibility of unification with Template is known
   % i.e. check against [] when we have one element,...
   % but also check against list of n elements when we have n
   % note: this is not as easy-to-understand as might be desired, especially because the coloring predicate has to be modified
   delayed_safety(Ns, Cs, Template) :- length(Template, Length),
                                       length(Ns, NLength),
                                       Longer is Length + 1,
                                       Longer =< NLength,
                                       when(?=(Cs, Template), \+first_num_unsafe(Ns, Cs, Longer)),
                                       length(NewTemplate, Longer),
                                       delayed_safety(Ns, Cs, NewTemplate).
   % ensure termination by avoiding failure
   delayed_safety(Ns, Cs, Template) :- length(Template, TLength),
                                       length(Ns, NLength),
                                       NLength = TLength,
                                       when(?=(Cs, Template), \+first_num_unsafe(Ns, Cs, NLength)).

CHR
===

This is extremely short, partly due to the data-is-code aspect.
In the other samples, it would have been possible to specify nodes,
edges and colours in the query, but that would've been tedious.
Here, we can just supply everything in constraint form.

.. code-block:: prolog

   :- module(graphcol, []).
   
   :- use_module(library(chr)).
   
   :- chr_constraint transparent/1, colors/1, edge/2, bidir/2, node/1, colored/2.
   
   % assume node constraints are given because generating from edges is a bit messy with multiset semantics
   node(X) ==> transparent(X).
   
   % assume edges are supplied in one direction only (e.g. lexicographical order)
   edge(X,Y) ==> bidir(X,Y), bidir(Y,X).
   
   % test 'before" generate
   colored(N1,C), colored(N2,C), bidir(N1,N2) ==> fail.
   
   % select a random color for a yet-to-be-colored node
   % due to BT, this will generate *all* possible graph colorings
   colors(Cs), node(N) \ transparent(N) <=> member(C, Cs), colored(N,C).

Compiling Control
=================

Okay, this one is pretty long.
That's partly due to the fact that it's a transformation, though,
and partly due to my using a different form of indentation. The
lines were getting too long.

Also, it's worth noting the compiling control can deal with negation.
The paper makes no mention of it, but "no negation" is something you come
across fairly often in papers on logic programming.

.. code-block:: prolog

   :- module(graphcol, [safe_coloring/2]).
   
   % solution to the graph coloring problem, transformed from naive implementation
   % uses the compiling control technique, as discussed in original paper
   % note that this solution generates duplicate solutions
   % most likely this is due to the bidirectional nature of edges
   
   % set 'global info'
   edge(belgium, netherlands).
   edge(belgium, germany).
   edge(germany, netherlands).
   
   colour(red).
   colour(green).
   colour(blue).
   
   % we only supply edges once, using lexicographical ordering
   bidirectional(X,Y) :- edge(X,Y).
   bidirectional(Y,X) :- edge(X,Y).
   
   % nodes are specified implicitly through edges
   % backtrack will generate the same node repeatedly, so filtering is required
   node(X) :- bidirectional(X,_).
   
   % atomic renaming of a conjunction for \+ operator
   clash(Node1, Node2, Colour1, Colour2) :- bidirectional(Node1, Node2),
                                            Colour1 = Colour2.
   
   % a coloring is safe if it cannot be proven unsafe
   % this is the uncategorized initial state (everything else follows a pattern)
   safe_coloring(Ns, Cs) :- setof(N, node(N), Ns),
                            length(Ns, NLength),
                            length(Cs, NLength), % not sure if this is fair...
                            a(coloring(Ns, Cs), safe(Ns, Cs, 2), [], []).
   
   % recursively construct all clash terms
   constructed_clashes(_, _, [], [], []).
   constructed_clashes(FromNElem, FromCElem, [NH|NT], [CH|CT], [\+clash(FromNElem, NH, FromCElem, CH) | TailClashes]) :- constructed_clashes(FromNElem, FromCElem, NT, CT, TailClashes).
   
   % auxiliary predicate to get the first n elements
   first_n(0, _List, []).
   first_n(N, [H|T], [H|Rest]) :- N > 0, Nminus is N - 1, first_n(Nminus, T, Rest).
   
   % auxiliary predicate to get the last n elements
   last_n(N, List, Last) :- reverse(List, RevList),
                            first_n(N, RevList, RevLast),
                            reverse(RevLast, Last).
   
   % based on transition 2-4
   a(coloring([NPartH|NPartT], [CPartH|CPartT]),
     safe(Ns, Cs, Param),
     [],
     []) :- length([NPartH|NPartT], NPartLength),
            NPartLength >= Param,
            length(Ns, NPartLength),
            colour(CPartH),
            a(coloring(NPartT, CPartT), safe(Ns, Cs, Param), [], []).
   
   % based on transition 2-3, 4-5, 9-10,...
   a(coloring(_NPart, _CPart),
     safe(Ns, _Cs, Param),
     [],
     []) :- length(Ns, NLength),
            NLength =< Param. % the B-state is redundant, because it always passes
   
   % based on transition 4-6
   a(coloring([NPartH|NPartT], [CPartH|CPartT]),
     safe(Ns, Cs, Param),
     [],
     []) :- length([NPartH|NPartT], NPartLength),
            length(Ns, NsLength),
            NPartLength >= Param,
            NPartLength < NsLength,
            colour(CPartH),
            c(coloring(NPartT, CPartT), safe(Ns, Cs, Param), [], []).
   
   % based on later transitions from A (always A-F)
   a(coloring([_NPartH|NPartT], [CPartH|CPartT]),
     safe(Ns, Cs, Param),
     [],
     Residues) :- colour(CPartH),
                  findall(R1, (member(R1, Residues), term_variables(R1, [])), InstantiatedResidues),
                  findall(R2, (member(R2, Residues), term_variables(R2, VL), VL \= []), RemainingResidues),
                  f(coloring(NPartT, CPartT),
                    safe(Ns, Cs, Param),
                    InstantiatedResidues,
                    RemainingResidues).
   
   % based on all C-D transitions, e.g. 6-7 or 12-13
   c(coloring(NPart, CPart),
     safe(Ns, Cs, Param),
     [],
     Residues) :- PlusParam is Param + 1,
                  d(coloring(NPart, CPart),
                    safe(Ns, Cs, PlusParam),
                    \+unsafe(Ns, Cs, Param),
                    [],
                    Residues).
   
   % based on all D-E transitions, e.g. 7-8 or 13-14
   d(coloring(NPart, CPart),
     safe(Ns, Cs, PlusParam),
     \+unsafe(Ns, Cs, Param),
     [],
     Residues) :- MinusParam is Param - 1,
                  nth1(MinusParam, Cs, FromCElem),
                  nth1(MinusParam, Ns, FromNElem),
                  nth1(Param, Cs, ParamCElem),
                  nth1(Param, Ns, ParamNElem),
   
                  % findall(I, between(PlusParam, NLength, I), ToElemIndices),
                  % this is problematic: most likely second argument is treated as simple condition
                  % so yes, ToCElem *can unify* with ToCElem
                  % but after that the link is no longer preserved!?
                  % findall(\+clash(FromNElem, ToNElem, FromCElem, ToCElem),
                  %         (member(Index, ToElemIndices),
                  %          nth1(Index, Cs, ToCElem),
                  %          nth1(Index, Ns, ToNElem)),
                  %         AddedResidues),
   
                  % alternative that should retain the link
                  term_variables(Cs, CVars),
                  length(CVars, CVarLength),
                  last_n(CVarLength, Ns, LastNs),
                  constructed_clashes(FromNElem, FromCElem, LastNs, CVars, AddedResidues),
                  append(Residues, AddedResidues, AllResidues),
                  e(coloring(NPart, CPart),
                    safe(Ns, Cs, PlusParam),
                    [\+clash(FromNElem, ParamNElem, FromCElem, ParamCElem)],
                    AllResidues).
   
   
   
   % as long as there are executable goals in the E state, execute them
   e(coloring(NPart, CPart),
     safe(Ns, Cs, Param),
     [ExH|ExT],
     Residues) :- call(ExH),
                  e(coloring(NPart, CPart),
                    safe(Ns, Cs, Param),
                    ExT,
                    Residues).
   
   % as long as there are executable goals in the F state, execute them
   f(coloring(NPart, CPart),
     safe(Ns, Cs, Param),
     [ExH|ExT],
     Residues) :- call(ExH),
                  f(coloring(NPart, CPart),
                    safe(Ns, Cs, Param),
                    ExT,
                    Residues).
   
   % based on E-A transition, e.g. 8-9
   e(coloring(NPart, CPart),
     safe(Ns, Cs, Param),
     [],
     Residues) :- a(coloring(NPart, CPart),
                    safe(Ns, Cs, Param),
                    [],
                    Residues).
   
   % based on F-C transition, e.g. 11-12
   f(coloring(NPart, CPart),
     safe(Ns, Cs, Param),
     [],
     Residues) :- c(coloring(NPart, CPart),
                    safe(Ns, Cs, Param),
                    [],
                    Residues).
