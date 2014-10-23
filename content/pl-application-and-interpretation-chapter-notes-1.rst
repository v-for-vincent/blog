Programming Languages: Application and Interpretation: Chapter Notes (1)
========================================================================
:slug: application-and-interpretation-chapter-notes-1
:date: 2014-10-21 21:07:52
:category: Programming
:summary: Most important points of chapter 1 in book
:tags: Racket, interpreter, programming languages

What is this?
+++++++++++++

I'm going through Krishnamurthi's "Application and Interpretation" (freely available online).
It examines different language concepts by building an interpreter for a Polish notation language using Racket (or rather, the Racket-based typed PLAI).
It reads quite slowly, and you need a good grasp of the concepts, so I'm summarizing the most important stuff.
And I might as well do that online.

Some useful constructs
++++++++++++++++++++++

* `define-type`: more or less like the definition of an ADT in Haskell, including type constructors
* `type-case`: a pattern match for types, again like in Haskell
