Djallenge, part 4
=================

:date: 2014-03-14
:tags: web, Django, Python
:category: Programming
:slug: djallenge-4
:author: Vincent Nys
:summary: Fourth tutorial in a ten-day series.

Preliminary note
----------------

This was published a day late, but it was still written on the date
mentioned. So I haven't lost my streak :-p

The plan
--------
So this is pretty annoying.
I'm currently using my thesis supervisor's spare computer, I won't be home tonight and I don't want to set up all the dependencies (including Postgres,...) just to write a blog post.
So I'll keep it short and give a concrete outline of some things that *should* work.

Like I said yesterday, we want our user to be able to see their own licks,
but not someone else's. So we need a filter operation of some sort.
This will involve an inner join
operation on the database backend, but we don't want to write SQL directly.

Instead, we need to do the following:

#. grab info regarding the user in the view
#. look at our model for licks
#. instead of returning the full list, return only those licks that are associated with the user

The approach
------------

Because we're leveraging a class-based view, we can't implement those steps directly.
But luckily, and also because we're using a class-based view, this kind of filtering is pretty common.
We can edit the view easily by implementing a non-default `get_queryset` method::

def get_queryset(self):
    return Lick.objects.filter(user=self.request.user)

Afterthought
------------

Now, as that was especially little work, let's just do some research to see how an end user could add new licks.
My original intent was to use the "single lick" page for that, but maybe I can merge that interface with a class-based model creation view of sorts.
Again, Google + Django docs almost make it too easy.
Turns out Django's `CreateView` can be used to save an object.
It uses Django's form functionality, so I'll read up on that and then provide an implementation.
