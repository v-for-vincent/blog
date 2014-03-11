Djallenge, part 1
=================

:date: 2014-03-12
:tags: web, Django, Python
:category: Programming
:slug: djallenge-1
:author: Vincent Nys
:summary: First tutorial in a ten-day series.

The 10-day Djallenge (\\də-'ja-lənj\\)
--------------------------------------

Old stuff's been growing a little moldy.
Time for something new and, hopefully, feasible:
10 days of messing around in Django.
The idea is to make some real progress on a project I started a while back.
It's called `Loopy <https://github.com/v-for-vincent/loopy>`_.
The plan is to make it into an online library of guitar licks for practice.
It's similar to YATM or the Amazing Slowdowner or whatever it's called,
but it should take the hassle out of finding licks.
It should also provide a kind of scrapbook for analysis of licks.

The plan
------------------

Some work has been done on the project already.
Right now, I'd like to allow logged-in users to see their licks.
Registering new licks is not part of the plan yet.

Populating the database
-----------------------

I've got a model for licks that includes the location of the lick online,
annotations (just a character field) and some data about timing
(so you can, say,
single out a small portion of a song and play it back at half speed).

I haven't made any lick objects yet.
That can be done with the admin interface.

Steps:

#. http://localhost:8000/admin (might be different with honeypot,...)
#. notice licks are not visible here
#. register the model class in the licks/admin.py file
#. add two licks
#. wonder how to link licks to users
#. decide link users-licks is one-to-many (licks include personalized settings)
#. use a ForeignKey field
#. **note to self: figure out how to enable licks app for migrations**
#. clear existing entries
#. note that it's getting late - decide to correct licks tomorrow
