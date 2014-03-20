Djallenge, part 9
=================

:date: 2014-03-19
:tags: web, Django, Python
:category: Programming
:slug: djallenge-9
:author: Vincent Nys
:summary: Ninth tutorial in a ten-day series.

The plan
--------

* Add a success URL to the edit view.
* Add links to corresponding edit view instances in the list view.

Implementation
--------------

First job is exactly the same as for the `CreateView`. Done.

Second job requires that we reference the URL for the `UpdateView` from
within our list template. Turns out it's surprisingly easy:
instead of saying `{% url 'update_lick_view' %}` (which does not specify
which lick we want to edit), we specify the `pk` parameter as follows:
`{% url 'update_lick_view' pk=lick.pk %}`. That's all there is to it.

One important remark left to make, though.
We will need to make sure a user cannot access the `UpdateView` for
someone else's lick just by entering a particular primary key in the
URL. We'll tackle that tomorrow.
