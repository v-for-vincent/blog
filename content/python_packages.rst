Python packages, imports and the working dir demystified
========================================================

:category: Programming
:status: draft

Recently as I was working on a moderately large codebase I had to
figure out how to refer to another package from a script somewhere
within the same higher-level package. An absolute import did not
work. Well, I've had it with guesswork. And I've had enough of
programs that only run correctly if you run them from the right
directory, too. Consider this my attempt to root out all common
misunderstandings related to these concepts. My goal here is to make
the concepts as clear as possible, so if I have overlooked anything,
if I have provided ambiguous examples or if you simply have
something you need to get off your chest, kindly drop me a comment
below.

Let's start at the beginning with modules. The definition I picked
up from my first Python book is that a module is simply a `.py`
file. The Python docs are only slightly more restrictive, stating
that "[a] module is a file containing Python definitions and statements."

I'm not going to split hairs. I think an empty `__init__.py` is the
same type of thing as one that has statements in it, so I'll stick
with modules as "`.py` files". If you're not familiar with
`__init__.py`, I'll get to that a bit further down.

(Actually, "files containing Python definitions and statements" exist
that are not themselves written in Python. So modules are `.py` files
plus some more exotic stuff mostly found in the standard library.)

Regardless of corner cases like empty files, the above definitions
imply that all Python programs are modules. The reverse is not true,
though. Some modules are purely meant to be used as libraries.

Although modules can function as both programs and libraries, I
don't recommend using them this way. First of all, doing so goes
against that holiest of principles, separation of concerns.
Second, (for the more practically inclined) it can lead to your
having to use special syntax to invoke the program you want.

.. todo:: add example

I'd give you an example, but first you need to know about packages.
If modules are like the leaves of a tree data structure, packages
are like the internal nodes. They group related Python modules in
a hierarchical namespace. They leverage two things: the
hierarchical filesystem structure and the `__init__.py` file.

The former is simple: packages map to directories containing either
other directories (internal nodes) or files, i.e. modules (leaves).
Packages may or may not contain subpackages, but they always contain
at least one `.py` file: `__init__.py`. This atrociously named file
can be empty, but it has to be there for a directory to be considered
a package. Its function is to initialize 

.. todo::  http://mikegrouchy.com/blog/2012/05/be-pythonic-__init__py.html en __all__
