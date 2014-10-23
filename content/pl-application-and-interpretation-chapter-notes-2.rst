Programming Languages: Application and Interpretation: Chapter Notes (2)
========================================================================
:slug: application-and-interpretation-chapter-notes-2
:date: 2014-10-23
:category: Programming
:summary: Most important points of chapter 2 in book
:tags: Racket, interpreter, programming languages

Notes
+++++

* In Racket, `read` provides us with a list (as does `quote` on a parenthesized expression).
* In typed PLAI, these give us an S-expression, which is a large recursive type, encompassing printable types and collections of S-expressions.
* S-expressions must be cast to their "native" types, e.g. `s-exp->list`.
* `read` can be considered a complete parser, but using datatypes such as `ArithC` provides insight into the semantics of an expression.

Questions
+++++++++

Question
--------
Does plain Racket distinguish at all between S-expressions and lists? Does typed Racket?

Answer
------
There is nothing in the Racket Guide or Racket Reference that suggests this.
An S-expression is quite simply described as a nested list of values.

For typed Racket, there does not appear to be a documented S-expression type.

So the current answer is that, unlike PLAI, neither does.
