===================================================================
A side-by-side comparison of Prolog, Prolog with coroutines and CHR
===================================================================

:slug: coroutines-side-by-side
:date: 2014-04-07 11:22:14
:category: PhD
:summary: A comparison of regular Prolog programs, programs with coroutining predicates and CHR programs
:tags: Prolog, CHR, Coroutines

Why a comparison
================

I'd like to take the time to contrast some different approaches to the same programming problem.
Sometimes, one paradigm can be easy and another can be more difficult and vice versa.
Also, complexity in time and space can differ.

Problem 1: permutation sort
===========================

Prolog
------

In (SWI-)Prolog, this is very easy:

.. code-block:: prolog

   :- module(permsort, [permsort/2]).

   /* Generate all permutations. Implementation not suited to coroutining. */
   permute([], []).
   permute([H|T], [RH|RTT]) :- select(RH, [H|T], RT), permute(RT, RTT).

   /* Sort by permuting. */
   permsort(L, S) :- permute(L, S), sort(L, S).

Because there is no random element involved and because Prolog backtracks,
we will eventually see a "good" permutation (so this is not :math:`O(∞)` as
in some implementations). Specifically, in the worst case we will go over
all :math:`n!` permutations and, for each permutation, apply a `sort`. The latter
predicate is apparently written as a merge sort in C for SWI-Prolog,
so we have to execute an :math:`n log n` operation :math:`n!` times.

In terms of space, this is okay: the call to `permute` is tail recursive,
but it is preceded by a backtracking call to `select`. I don't know Prolog
well enough to predict the results there. I used the graphical debugger to
gain some understanding and it seems that the `permute` calls aren't being
erased from the call stack. I guess that makes sense if you backtrack.
I would have to look at some of the implementation details of Prolog to
know exactly what's going on, but this certainly demonstrates that space
complexity is proportional to the depth of the tree for `permute`, so
it's :math:`O(n)`, though it's hard to say anything about the constant
factor for me right now.

The complexity of merge sort is :math:`2n`, according
to Wikipedia.

Prolog with coroutining
-----------------------

A bit more involved, but much faster:

.. code-block:: prolog

   :- module(permsort, [permsort/2]).

   /* Generate all permutations. Implementation suited to coroutining. */
   permsort([], []).
   permsort([H|T], P) :- length([H|T], L), length(P, L), freeze_order(P), permute([H|T], P). % i.e. create a list of free variables

   /* Auxiliary predicate: generate permutation when free-variable skeleton is given. */
   permute([], []).
   permute([H|T], [TemplateH|TemplateT]) :- select(Elem, [H|T], Rem), TemplateH = Elem, permute(Rem, TemplateT).

   /* Coroutine that checks whether order is maintained in a list of free variables. */
   freeze_order([_]). % single element is always ordered
   freeze_order([H|[HT|TT]]) :- freeze(HT, HT >= H), freeze_order([HT|TT]).

We take advantage of the fact that a permutation does not change the number of elements.
(Note that there are probably other ways to do this that preserve a closer equivalence
with the regular Prolog program.) The `permute` operation was also slightly modified in
light of this, but there are other ways.

The main thing is that we "freeze" on the order of our permutation before we begin
to apply it. That is, we wait for something to become ground, and that something
is the first free variable in our permutation. If it's the only variable, we won't
have much work to do. If the permutation matches with a longer structure, we state
that the second element will be compared to the first as soon as that is ground,
and that the tail of the list should also be checked for order.

If this fires and fails, backtracking will occur.
The SWI docs don't really state how backtracking is affected in the case of coroutining,
but the output was as hoped. And the first `permute` call takes place after all the
variables are frozen, so one would think that backtracking only affects the permutation.

I did a trace of this program to verify this. Nothing about the `freeze` calls is
changed during the program.

If you run this program, you'll see that it's significantly faster than the regular
Prolog program. This is because it detects failure much more quickly, i.e. as soon
as two instantiated elements are out of order. As a result, it prunes away permutations
that have a prefix with elements that are out of order.

Freezing the free variables means traversing them, so that's :math:`O(n)`.
The fact that we're pruning away permutations based on prefixes gives us
a good indication of the number of permutations that we still do:
assuming no duplicates, there is one element with a prefix of length :math:`n-1` or
greater (which is also the correct solution), there are two elements of length
:math:`n-2` (i.e. the correct solution, plus an incorrect solution in which only
the final two elements are swapped). There are six with a prefix of length :math:`n-3`.
So essentially, for a prefix of an actual length :math:`n-i`, there are :math:`i!`
solutions.

Because of this idea of pruning, we can come up with a decision tree structure,
in which leaves represent sets of permutations. If :math:`i` represents an element
at index `i` in a permutation and if we we choose whether
:math:`i < i + 1`, we get a decision tree of depth :math:`l-1`
(i.e. compare the first and second element on the first level, second and third on
the second level,...)
Because of that, we have :math:`2^(l-1)` leaves which represent a total of
`l!` permutations. Some leaves therefore represent multiple permutations.
Obviously, the correct solution is alone: if each element is smaller than
the next, the permutation is sorted, and with distinct elements that solution is
unique.

In this decision tree, we always prune solutions that build on a "no" answer.
Roughly speaking, we first prune away half of the search space when we know
the first two elements, then half of half when we know the third element,
then another half, etc. Which checks out, because the sum of binary fractions
converges to 1, so we're left with only one element all the way at the end.

We also need to consider that more than one comparison is needed to prune away
half a search tree. Specifically, we grab two random elements from the whole
list and then consider half the permutations of those two elements to be good
and half of those to be ruled out. To find out how many grabs we do at each
level, we use the binomial coefficient: math:`n!/(k! (n-k)!)`, where :math:`k`
is 2 and `n` is the number of elements left to consider.

Therefore, on the first level, we rule out half the search space using
:math:`l!/2(l-2)!` comparisons, or :math:`l * (l-1) / 2`. We do the same
number of comparisons at this level for permutations on which we will keep
building. If we apply the same reasoning to other levels of the tree, we
can summarize the comparisons with the following sum:
:math:`l * (l-1) + (l-1) * (l-2) + ...`
That leaves us with a number of comparisons between :math:`O(l²)` and
:math:`O(l³)`. So we've gone from factorial to polynomial.

In terms of space, this approach is also pretty good.
We create a list of free variables, so we've definitely got :math:`O(2l)`.
The `permute` call is similar to that which we saw earlier.
We gain some space when it comes to `select`. Whereas the original version
had a linear number of selects, this one only keeps two on the stack, at
most. Which is something I can't really explain. It's also interesting to
note that the "bindings" screen of the SWI Prolog debugger shows a number
of "constraints". So it seems to process coroutines fairly intelligently,
in the sense that it has recognized the fact that certain values have to
relate to each other in a particular way as constraints.

Still, I'll **need to ask about the call stack**.

CHR
---

Pretty simple code in CHR, too.

.. code-block:: prolog

   :- module(permsort, [to_sort/1]).
   :- use_module(library(chr)).

   :- chr_constraint index/2, num_unsorted/1, to_sort/1, unsorted/1.

   % distinguish between elements "yet to be sorted" and assigned elements
   to_sort(L) ==> length(L, N), unsorted(L), num_unsorted(N).

   % for each unassigned element, create an index position
   num_unsorted(N) <=> N > 0 | NumRemaining is N-1, index(N, _), num_unsorted(NumRemaining).

   % once two successive elements have been assigned, they can be checked
   index(I1, E1), index(I2, E2) ==> ground(E1), ground(E2), I2 is I1+1, E2 < E1 | fail.

   % assign unused positions to elements with Prolog backtracking
   % note unification
   index(_, VarEl) \ unsorted(L) <=> var(VarEl) | select(VarEl, L, Rem), unsorted(Rem).

Again, I haven't really tried to preserve the "how", just the "what".
The logic here is closer to the coroutining program in the sense that it checks
adjacent elements as soon as possible. It is also similar in the sense that it
creates a set of "placeholder" constraints with a free variable inside them,
i.e. `index(N, _)`. What's most striking about this, as a CHR program, is that
it does bactrack. That is, it uses the `select` predicate before the `unsorted`
constraint. Strictly speaking, this is not "pure" CHR. But it works when the host
language is Prolog, and something like this is probably needed to make the algorithm
more or less feasible.

The paradigm is different and I made a few syntactic changes, like the `index`
constraint, but the same reasoning can be applied here as in the case of
the coroutining solution. It's important to note, though, that this is because
we are dealing with CHR(Prolog).

As for spatial complexity, I cannot give an accurate response at this time,
as I am not familiar enough with the CHR data structures.
