===================================
Abstract unification for ACPD trees
===================================

:slug: first-acpd-procedure
:date: 2014-05-05 10:24:50
:category: PhD
:summary: First formalization of the procedure used to construct ACPD trees
:tags: compiling control, abstract conjunctive partial deduction

In our latest work on compiling control, we build an abstract representation
of a set of computations. This allows us to more easily identify computational
patterns, which can be used to transform a logic program. Transformations may
improve the efficiency of a program, but they can also influence its
completeness: because a language like Prolog follows a fixed search strategy
(i.e. depth-first), it can get lost in infinite (specifically, endlessly
recursive) branches of its search tree. If we rewrite the program to apply
its declarative rules in another order, we can avoid this problem, because
sometimes there is information in the later branches that would lead us to
stop descending in the "infinite" branches.

That gives us what is probably the best use case for compiling control.
Let's look at how it works, using slowsort as an example. Slowsort is
a sorting algorithm that tests random permutations of a sequence until
the result happens to be correctly sorted.

.. code-block:: prolog

   sort(X,Y) :- perm(X,Y), ord(Y).

   perm([],[]).
   perm([X|Y],[U|V]) :- del(U,[X|Y],W), perm(W,V).

   del(X,[X|Y],Y).
   del(X,[Y|U],[Y|V]) :- del(X,U,V).

   ord([]).
   ord([_X]).
   ord([X,Y|Z]) :- X =< Y, ord([Y|Z]).

Suppose we supply a sequence as the first argument to our `sort`.
The way this works now is that Prolog first completely evaluates
`perm`. But, even without thinking about this algorithmically, we can do
better. The reason is that, if we have a tiny bit of a permutation, we
can check if that is ordered before completing the whole thing. If it isn't,
we can save ourselves work by not completing it. To capture this pattern, we
draw an ACPD tree or abstract conjunctive partial deduction tree.

An ACPD tree does not use concrete values, but works in our abstract domain.
This abstract domain consists of the following (types of) values:

* `g`: any fully ground element
* `a`: any element. An `a` is subscripted to capture shared references.
* any constant in the concrete domain
* any functor in the concrete domain

To execute slowsort abstractly, we still need a unification algorithm.
The algorithm is simple, but a few rules should be established beforehand.

#. We do not keep track of the links between `g`'s, only between `ai`'s.
#. Constants are 0-arity functors.
#. Unify with elements of the concrete domain by renaming variables to "fresh"
   `ai`'s.
#. Assume that an implicit identity function can always be applied.
   So the rule explaining `ai = f(c)` also covers the case `ai = c`.

With these rules in mind, we can find a substitution as follows:

#. `g = f(c1,c2,a1,a2,g,g)` (where `c`'s are constants and there is no bound
   on indices): switch the two sides of the unification.
#. `f(c1,c2,a1,a2,g,g) = g`: add `a1 = g`, `a2 = g`,... to the resulting
   substitution
#. `ai = f(c1,c2,ai,aj,g,g)` (unless `f` is the identity function): fail.
   This corresponds to the "occurs check": `ai` is unified with a term
   containing `ai`.
#. `ai = f(c1,c2,a1,a2,g,g)`: substitute `ai` for a literal occurrence
   of the term (including `a1`,...).
#. `f(c1,c2,a1,a2,g,g)` = `f(c3,c4,a3,a4,g,g)` (notation could be a bit
   misleading here: the arity is the same, but matching arguments do not
   need to have the same "status", e.g. we can unify `ai` with `g`):
   move on to do a pairwise unification between each argument.

That's it. For permsort, I've drawn up a tree that illustrates the process.
I'll scan it shortly.
