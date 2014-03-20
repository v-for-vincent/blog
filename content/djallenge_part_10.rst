Djallenge, part 10
==================

:date: 2014-03-20
:tags: web, Django, Python
:category: Programming
:slug: djallenge-10
:author: Vincent Nys
:summary: Tenth tutorial in a ten-day series.

The plan
--------

* Block unwarranted access to someone else's `Lick` objects.

Implementation
--------------

My gut tells me this should be somewhat similar to how we handled our
list view. There, we overwrote `get_queryset`. Obviously, it won't be
the same here.

Turns out it's similar, though. And it's also on StackOverflow :-) ::

   def get_object(self, *args, **kwargs):
       obj = super(LickUpdateView, self).get_object(*args, **kwargs)
       if obj.user != self.request.user:
           raise PermissionDenied()
       return obj

Conclusions
-----------

The changes I've made over the last ten days have been minor,
but they add up. And I'm kind of proud that I managed to do something
every day.

I think it won't be long until I write a sequel series of blog posts.
There are some things I'd like to improve, though.
