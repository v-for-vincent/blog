Djallenge, part 2
=================

:date: 2014-03-12
:tags: web, Django, Python
:category: Programming
:slug: djallenge-2
:author: Vincent Nys
:summary: Second tutorial in a ten-day series.

The plan
--------

#. Create new licks with reference to user
#. Look into existing class based views to list licks
#. Show the licks in a template

Step 1
------

Easy enough. Clear the database, sync it again, perform migrations,
create super user (again, migrations for the apps are on the TODO pile),
log in, create some licks via admin interface.

Incidentally, even the super user needs to be activated.
I haven't configured a mail server, so I just copy the link to localhost
that's shown in the logs to activate.

Step 2
------

I haven't had the time yet to go through my copy of Two Scoops of Django
in full detail yet, but I recall it mentioning that there's a prebuilt
class-based view to list model objects. It turns out this is the `ListView`.
To use it, just add a subclass of `ListView` to views.py, setting the
`model` attribute to the corresponding class.

Step 3
------

Standard Django templating language for each loop. Oddly, I need to place
the template in a subfolder 'licks' of my app's templates folder. Seems a bit redundant.

Tomorrow
--------

Plenty of rough edges. Will tackle one or more of the following:

* properly check in changes
* anyone can navigate to the list URL and see all the licks
* add link for list view to navigation pane, but only for logged in users
* what's up with the templates folder's subfolder requirement
* no way to add licks as an end user
* tests
