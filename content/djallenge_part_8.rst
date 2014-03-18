Djallenge, part 8
=================

:date: 2014-03-18
:tags: web, Django, Python
:category: Programming
:slug: djallenge-8
:author: Vincent Nys
:summary: Eighth tutorial in a ten-day series.

The plan
--------

Add an edit view.

Implementation
--------------

An edit view should do more or less the same as the creation view.
There's a generic view for this job, too, and it's called `UpdateView`.

The `UpdateView` is super simple: set `model` to `Lick` and set the
attributes like we did for `CreateView`. Done. We don't need to be able
to set the user, because that is set correctly when the lick is first
created.

The URL for this new view requires a `pk` group (for "primary key").
We just define this group as part of the URL with this: `(?P<pk>\d+)`.

Again, short and sweet. Tomorrow I'll add the success URL and link to
the edit view from each element in the list view.
