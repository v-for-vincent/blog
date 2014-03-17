Djallenge, part 7
=================

:date: 2014-03-17
:tags: web, Django, Python
:category: Programming
:slug: djallenge-7
:author: Vincent Nys
:summary: Seventh tutorial in a ten-day series.

The plan
--------

Fix the success view on `Lick` creation.
Hide the "create" button for anonymous users.

Implementation
--------------

For the first issue, we need to make sure our view has a `success_url`
attribute. However, because we instantiate the view in our urls.py file,
`reverse` is not a good way to resolve our list view to a URL. The reason
is that we are also defining that in urls.py. Instead, we need a lazily
evaluated version of `reverse`. Fortunately, `reverse_lazy` exists.
So we use that and boom, we've got our list view.

As for the create button, that isn't actually part of the generated form.
So it's in the template, and when we're inside a template we can check
for authentication with `{{ user.is_authenticated }}`. Easy.
