CHR for humans, part 1
======================

:slug: chr
:date: 2014-03-30 14:31:33
:category: Programming
:summary: Trying to come to terms with CHR, first impressions.
:tags: CHR, Prolog

The main focus of my PhD will be coroutining.
Simply put, coroutining is a superset of subroutining.
It is more general in the sense that a coroutine may possess several points of entry and exit.
Coroutining facilities are found in many languages (e.g. generators in Python),
but I'm currently looking at it in the context of logic programming - basically, Prolog.

An interesting application that seems to share quite a bit with coroutining is the constraint handling paradigm.
There is a system called CHR that is built on top of SWI Prolog that implements this paradigm
(Actually, CHR implementations exist for different languages, but we'll look at the reference Prolog version.)
It's powerful, but it's strange, too. I'd like to come to terms with it.
Much like Lisp, it doesn't really distinguish between code and data.
The mere existence of data can trigger behaviour, and behaviour is all about modifying data.

Essential syntax
----------------

Let's start with the `simplest possible example <|filename|/attachments/chr_party.pl>`_:

.. code-block:: prolog

   :- module(party, [party/0]).
   :- use_module(library(chr)).

   :- chr_constraint party/0, sleepy/0, headache/0.

   party ==> sleepy.
   party ==> headache.

To experiment with this sample, just start up the SWI-Prolog interpreter (`swipl` under Ubuntu)
and `consult` the file, for instance with `[chr_party]`.

The idea behind CHR should become clear as soon as you specify the constraints `party`,
`sleepy` and `headache`. As usual in Prolog, terminate facts with a dot.

Note how the file uses standard SWI conventions.
It adds some syntax, but I think it's useful to keep in mind that this is still Prolog.
CHR adds a directive, `chr_constraint`, which is pretty much a declaration.
Unlike regular Prolog facts and implications, constraints *must* be declared.
If you omit the declaration, the program won't run.

I haven't poked around in the implementation yet, but `==>` is almost certainly
defined as a predicate with infix notation. In fact, you can write `==>(party, sleepy)`
and the program will behave in the same way as before: it will infer new constraints
based on old ones.

In this program, constraints are inferred using **propagation**, i.e. `==>`.
Alternatively, we can also use **simplification** and **simpagation**.

The former mechanism takes the following form:

.. code-block:: prolog

   positive, negative <=> true.

In other words, it can be used to *replace* constraints.
If we replace constraints with `true`, we are essentially removing them from our rule base.
In this case, we use the mechanism to cancel out opposites.
Note also that, unlike in Prolog, we have "multi-headed" rules.
That is, Prolog resolution works by taking a single, atomic goal and trying instantiate that.
For instance: `neutral :- positive, negative.` but not `neutral, boring :- positive, negative`.
In CHR, we can have multiple constraints on both sides of a rule, which improves expressiveness.

Simpagation, our other mechanism, is a combination of the two previous mechanisms.
It looks like this:

.. code-block:: prolog

   sleepy \ aspirin, headache <=> true.

Basically, our `headache` constraint goes away if there are also constraints stating that we
are sleepy and that we have taken our aspirin. And of course we use up the aspirin in the
process. So if we supply the query
`sleepy, aspirin, headache` (with constraints in any order) we are left with only the first
constraint remaining. We could also add something new, e.g.

.. code-block:: prolog

   sleepy \ aspirin, headache <=> alittlebetter.

Execution
---------

It is worth noting that, although the reference implementation is built on top of Prolog,
CHR behaves differently. By itself, it *does not backtrack*.
That is, if there are two textual possibilities to alter contraints, only one will be
applied. To complicate things, it *can* backtrack if the host language does.
That is, if a backtracking Prolog predicate is executed in the program,
backtracking will occur.
For instance:
`sunny ==> member(Activity, [swimming, icecream]), performing(Activity).`

`member/2` is a backtracking predicate, so we'll see both the execution in which
the program decides we should go swimming and the one where we eat ice cream.

Also note that we need to reconcile the idea of a Prolog predicate with the idea
of a constraint. How come they're the same? We'll look at that in a followup post.
