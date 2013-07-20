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

I do some digging and find out that someone gets the same error message, 
but they can "generate reports from the command line".
So I `apt-get install cobertura` to see if I can do the same.
