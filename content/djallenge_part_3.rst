Djallenge, part 3
=================

:date: 2014-03-13
:tags: web, Django, Python
:category: Programming
:slug: djallenge-3
:author: Vincent Nys
:summary: Third tutorial in a ten-day series.

The plan
--------

#. Check in yesterday's commits properly
#. Add a navbar entry for library for users that are logged in
#. Only show licks associated with that user

So basically the first three bullets I pointed to yesterday.

Step 1
------

Fairly trivial. Turned out this was still manageable. Yay.

Step 2
------

To do this, I need to figure out how to show stuff in a template
based on what kind of user is navigating the site. I can just not
show the link for users that aren't logged in.
They can still navigate to the URL, but they'll get a forbidden view.

First, it's worth noting that I'm using PyDanny's django-cookiecutter
setup. That means there's a customized "users" app. This really just
seems to extend Django's existing authentication system a bit, so what
applies to the latter should still apply.

That said, how do we conditionally display a link in our navbar?
The wonderful Django docs provide this example::

   {% if user.is_authenticated %}

So, yeah, that can go in the base template. Because I'm using the cookiecutter, there are already some conditional links for user logout etc. The tag to use is::

   {% url 'licks.views.LicksView' %}

So does that work? Nope. Can't instantiate the view. Okay, a better way
would be to name the view. That works. Just add a `name` argument when
defining the URL to do that and use that in the template tag.

Step 3
------

First, we need to make sure an unauthenticated user does not see anything.
To do that, we can use a handy decorator: `@login_required`.
Normally, it goes on the view function. We're using a class-based view,
so how do we handle that? I haven't used class decorators in the past, but
I believe that should apply the decorator to each method.

A bit of Googling shows that we need something other than the decorator here. We need to wrap our `as_view` in the "urls.py" file.

**Note to self: check out class decorators. Clearly, `login_required` doesn't wrap as_view when used as a class decorator.**

And that works. Better yet, it automatically refers to the login page if needed.

All right, the next part of this step is for tomorrow. We'll want to handle this on the backend: we don't want to return a full list of licks that is then filtered during page generation, we want to perform a join query on the database.
