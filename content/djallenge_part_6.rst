Djallenge, part 6
=================

:date: 2014-03-16
:tags: web, Django, Python
:category: Programming
:slug: djallenge-6
:author: Vincent Nys
:summary: Sixth tutorial in a ten-day series.

The plan
--------

Limit the `CreateView` started yesterday so that it automatically
fills out the right user. Refuse unauthenticated users, but allow
them to just play quick licks which they cannot save.

Implementation
--------------

To only show specific fields in a `CreateView`,
we set the view's `fields` attribute to be a list of the editable names::

   fields = ['description', 'reference', 'tempo', 'loop',
             'start', 'end', 'annotations']

The user can be associated with the lick as follows::

   def form_valid(self, form):
       form.instance.user = self.request.user
       return super(CustomCreateView, self).form_valid(form)

The problem with that is that it raises an annoying error for users that
are not logged in, because it tries to register an `AnonymousUser` object
when a `User` object is expected. We want a more standard 403 error, but
we don't want to bar anonymous users from using the view to just parameterize and play a lick.
So we do this::

   def form_valid(self, form):
       user = self.request.user
       from django.core.exceptions import PermissionDenied
       if not self.request.user.is_authenticated():
           raise PermissionDenied
       form.instance.user = user
       return super(CustomCreateView, self).form_valid(form)

There. Still no success view, but it's going well so far.
