AJAX-powered auction in Django - Part 2: More Jenkins
#####################################################

:date: 2013-07-20
:tags: Django, Jenkins
:category: Python
:slug: auction-in-django-2
:author: Vincent Nys
:status: draft
:summary: Adding tasks and reports to Jenkins.

Intro
-----

In `part one of this series <|filename|django_auction.rst>`_ I explained
how to integrate a Django project with Jenkins using django-jenkins, but
I left the configuration as minimal as possible. In this part of the series,
I'll add some more bells and whistles, like code coverage, style violation
reports, etc.

Little tip for deployment
-------------------------

I switch between several machines several times a day.
That makes running Jenkins locally something of a pain.
What I did to fix this was hook up my Raspberry Pi
(hey, now I've got a real use for it!) to my NAT box
and set it up as per
`Making Technology Easier <http://makingtechnologyeasier.blogspot.be/2013/05/jenkins-continuous-integration-server.html>`_.

Easy as pie, and now I can even monitor my tests from my mobile.

Code coverage
-------------

To get code coverage, we need to do three things.

First, we add a task to our settings.py file, changing the
`JENKINS_TASKS` tuple to::

   JENKINS_TASKS = (
    'django_jenkins.tasks.with_coverage',
    'django_jenkins.tasks.django_tests',
   )

Then, we `pip install coverage`.

Finally, we enable the Cobertura plugin.
If you don't have it installed yet, do so through the configuration tab.
Go to the project's configuration and add "publish Cobertura Coverage Report"
as a post-build step. Publish to reports/coverage.xml. Don't worry about
advanced settings just yet.

For me, this led to a strange result: the build started to fail (with no
changes to the actual code) and I got a "No valid coverage data available"
message when trying to look at the report.

And there is no "coverage.xml" report to be found anywhere, so I guess that's
my problem. Interestingly, if I run `python manage.py jenkins`, I *do* get
such a file.

