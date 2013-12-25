Creating street maps with Kartograph
====================================

:date: 2013-12-25
:tags: Python, Kartograph, maps, Leuven
:category: Python
:slug: kartograph-leuven
:author: Vincent Nys
:summary: How I drew a nice-looking map of Leuven
:status: draft

The plan
--------

I'm involved in an association for alumni of the university of
Leuven and I've been asked to spruce up a map of the city.
The association is a humanities association, so I figured I'd bring
some programming to the table to mix things up a bit.
Specifically, I looked for a library that can be used to draw nice
maps and I found one that fits that bill very nicely in
`Kartograph <http://www.kartograph.org>`_: 

- it's in Python
- the output looks beautiful
- it looks easy to use

The downside is that it's in beta, and it's true that I hit a few
snags. But then, that's why I'm writing this.
Anyway, if you find maps to be even remotely interesting, I recommend
that you have a look at the website, as there are some beautiful
examples there (I particularly like the 3D mapping ones and the
interactive map of Italy).

Concrete steps
--------------

Setting up
++++++++++

First, you'll obviously need to install Kartograph.
I'm assuming Ubuntu here. The first set of instructions on
the website still applies:

.. code:: bash

   sudo apt-get install libxslt1-dev python-dev python-shapely python-gdal python-pyproj python-pip

However, installing from Github (as detailed on the site) did not
quite go as planned. The reason is that the version of GDAL (some
map thingy) in the Ubuntu repos is out of sync with the Python
bindings installed as part of the installation via Pip. So what I
did was to install the previous version (in a Python 2.7 virtualenv),
i.e.

.. code:: bash

   pip install GDAL==1.9.0

Then, I installed Kartograph from Github, as described on the site.

Next, I had to set up PostgreSQL for map data. I already had PostgreSQL
on my system, but instructions can be found
`here <https://help.ubuntu.com/community/PostgreSQL>`_.
I run version 9.

If you follow those instructions, you'll initially have user named "postgres".
That turned out to be somewhat inconvenient because you'll want to access the
database by running Kartograph as a normal user. So I assigned myself the
required PostgreSQL priviliges by logging in as "postgres". I followed
instructions in the
`PostgreSQL docs
<http://www.postgresql.org/docs/9.1/static/app-createuser.html>`_.
IIRC, after creating the user "vincent" (same as my system user) and running
Kartograph, I was told that there was no database named "vincent". I'm not
particularly familiar with PostgreSQL (and that's putting it mildly) but
creating said DB did the trick, so you'll probably want to do the same.

Then, there was the matter of getting the data I needed.
First, I looked up Leuven on `OSM <www.openstreetmap.org>`_.
Next, I clicked "export" and manually selected a rough approximation
of the area I'm interested in. Then, I pressed the *other* export button
to get the serialized map (an .osm file).

Then, I set up PostgreSQL to work with map data (paths may vary on your
system, but you should have these files).

.. code:: bash

   createdb osm
   psql -d osm -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql
   psql -d osm -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql

Then, I imported the data from OSM into my database. Note that the command
from the tutorial found on Github gave me errors, so this one's slightly
different:

.. code:: bash

   osm2pgsql -l -d osm map.osm

That's assuming you haven't renamed your exported data to something other than
map.osm, of course.
