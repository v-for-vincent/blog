AJAX-powered auction in Django - Part 1: Jenkins
################################################

:date: 2013-07-18
:tags: Django
:category: Python
:slug: auction-in-django
:author: Vincent Nys
:summary: A rundown of how to set up Jenkins for the auction.

Intro
-----

I'd like to improve my knowledge of Django.
I spent a few weeks with Pyramid last year and, although it is a powerful
framework, it just doesn't have the same backing. If Pyramid was as popular
as Django, I'd probably stick with it, but more backing means better
learnability and more traction for projects. So Django it is.

To start learning, I wrote an auction web application.
Not exactly an ebay clone, but something you'd use to sell off high volumes
of low-value items to acquaintances.
That means you don't need the strict transaction flow ebay gives you, but you
do want maximal convenience.
Therefore, the application uses existing social network logins to identify
users and allows one-click bids by using AJAX.

This post details how it can be done.
For myself, it serves two purposes: to retrace my steps and solidify the
concepts, and to do everything by the book the second time around.
The first time, I had to get acquainted with a lot of concepts.
Now, I want to focus on building it the right way.

This tutorial does not assume that you have worked with Django before,
but it only explains the concepts that are used for the web app.
Some great resources on Django itself are
`The Django Book <http://www.djangobook.com/en/2.0/index.html>`_,
`Obey the Testing Goat! <http://www.obeythetestinggoat.com/>`_,
`2 Scoops of Django <https://django.2scoops.org/>`_ and, of course,
`The Django Project <https://www.djangoproject.com/>`_.
The first two links are complete online ebooks which can be understood
even by Python beginners.

Quite a bit of emphasis will be placed on how the application can be tested,
because I feel you can't learn proper testing practices for a framework soon
enough.

Django and Continuous Integration
---------------------------------

I think continuous integration is brilliant.
Up until now, I've applied a "lite" version of CI by using tdaemon and nose
to run all my tests when a file changes.
That's huge improvement over running tests manually, but there is dedicated
software for the job and it's used in industry, so I'd like to figure out
how to apply that to Django.

A well-known CI tool is `Jenkins <http://jenkins-ci.org/>`_.
I'll be using that.
Specifically, I'll be using django-jenkins.
This is a tremendously useful tool, but the
`generic tutorial <https://sites.google.com/site/kmmbvnr/home/django-jenkins-tutorial>`_
for it glosses over way too many points, like what each setting does.

I'll start with a completely minimal setup and I'll configure plugins for
more detailed output later on.

Before I explain how I'd like things to be tested, a bit of explanation may be
in order: Django distinguishes between "projects" and "apps", the former being
composed of the latter. Projects are just web applications in the general
sense. Apps are smaller components, like a forum, a store, etc.
The reason for the distinction is reusability.
Well-designed apps are reusable.
You could use the same forum app on multiple web sites, for instance.
This implies that apps are written in a loosely coupled manner.
They can have their own templates (which render to HTML) but these should
be minimal.

With that in mind, I'd like Jenkins to run tests for both the project we'll
be building and for the app we'll be writing and including in the project.
I'd also like to make a distinction between functional tests and unit tests,
like in `Obey the Testing Goat! <http://www.obeythetestinggoat.com/>`_.
Functional tests will usually be more expensive, because they test larger
chunks of functionality.
It'd be cool if I could run unit tests on each code change and functional
tests on each commit, but I can live with another setup.

Let's dig in.
On my desktop, installing it was enough to make it available at
localhost:8080 after reboot.
I ran into a few snags on my laptop because it's already gone through quite
a few Ubuntu upgrades and Java re/de/re-re-installs.
I used apt-get, but frankly, getting it from the site and running the .jar
might be the easiest thing to do.
If you see a Jenkins administration interface at localhost:8080, you're good
to go.

Here's the main idea behind Jenkins.
First, Jenkins starts by monitoring a repository for changes via polling.
It checks out what's in the repository, executes some commands
(like a build script) and gives output.
The workflow is simple enough, but a plethora of plugins makes Jenkins a
very flexible system.
Also note that, because it checks out the code from the specified repository,
you can't afford half-baked version control. You need a working
requirements file, for one. Kind of a plus, really.

By the way, you can also set Jenkins to build based on another trigger than a
time-based one.
For instance, when you visit a particular URL. 
You could set up a post-commit hook to do that automatically.

To get Jenkins to work with Git, you need to go the Jenkins administration
page for plugins.
Under available, you'll find the "Git plugin".
Just check it and choose to install.
The main django-jenkins tutorial also uses the "Violations" and "Cobertura"
plugins, so you should install those, as well.
The former can check for style violations using such tools as pep8 and pylint.
The latter checks for code coverage.
(**Edit: You can put this off until the next iteration of this tutorial,
because I want to keep things concise so I didn't include the plugins
after all.**)

Once that's done, I create a new free form job and I name it
"django-jenkins-yardsale".
Note that your Git repo can be local.
In my case, Jenkins is happy when I supply
/home/vincent/Projects/YardSaleEnv/.git.

Originally, I was a bit surprised there's no box asking me for the directory
from which the command will be run.
Again, Jenkins actually checks out your code and goes through the entire build
process.
It uses a workspace of its own to do this.

To determine when the project gets built, check "poll SCM" and fill in::

   */5 * * * *

This is crontab syntax, so every five minutes your Git repo will be checked
for new commits.

To run the tests, I specify these
build steps (as "shell script")::

   virtualenv my_env
   my_env/bin/pip install -r requirements.txt
   my_env/bin/python src/yardsale/manage.py jenkins

Just a word of explanation.
The first command creates a virtualenv in your workspace.
The second command installs the dependencies of your environment.
I'm assuming you define these in the root of your repository.
To generate a requirements file, follow the simple instructions found
`here <http://www.pip-installer.org/en/latest/requirements.html>`_.
Look for "pip freeze".
The final command is made available by the django-jenkins package,
which we'll set up shortly.
The path is due to my own approach to project structures:
I have a "Projects" folder on my hard drive.
Within that folder, I've got a bunch of virtualenvs.
In this case, "YardSaleEnv".
I make that the root of my repository.
Within those virtualenvs, you've got your "bin", "lib", "local"
folders and some other stuff.
Anything that is created by virtualenv, I add to the root .gitignore file.
I add a "src" folder in the root folder and put stuff that is not just part of
the environment in there.

For easy reference, here's my requirements file:

   | Django==1.5.1
   | argparse==1.2.1
   | coverage==3.6
   | distribute==0.6.24
   | django-dajax==0.9.2
   | django-dajaxice==0.5.5
   | django-jenkins==0.14.0
   | django-social-auth==0.7.23
   | httplib2==0.8
   | jslint==0.6.0
   | logilab-astng==0.24.3
   | logilab-common==0.59.1
   | oauth2==1.5.211
   | pep8==1.4.6
   | pyflakes==0.7.3
   | pylint==0.28.0
   | python-openid==2.2.5
   | selenium==2.33.0
   | wsgiref==0.1.2

You can copy-paste that into a requirements file to quickly replicate my
environment. Just use the "pip install -r" command shown above.

Now, Jenkins won't be able to work with Git until you configure it.
First, find your Jenkins home folder.
Chances are that's ~/.jenkins or /var/lib/jenkins.
Then, go to jobs/django-jenkins-yardsale/workspace.
Enter the following commands::

   sudo git config user.name "jenkins"
   sudo git config user.email "test@gmail.com" 

Once that's out of the way, start a django project called "yardsale".
See the "startproject" command at
`The Django Book`_.
Use the same layout I described earlier.
So that's `django-admin.py startproject yardsale` from within the "src"
folder.

Then, find your settings.py file, and add 'django_jenkins' to the
INSTALLED_APPS tuple.

Next, add this::

   JENKINS_TASKS = (
       'django_jenkins.tasks.django_tests',
   )

This enables test discovery.

Now, when I ran `python manage.py jenkins` I got this vague error:
"AttributeError: 'NoneType' object has no attribute 'result'".

Okay, let's try something.
The django-jenkins tutorial says that:

   Now running python manage.py jenkins will do the same job as python manage.py tests,
   but also will create reports folder in the root of your django project with jenkins parsable pylint,
   test coverage and tests reports.

Now that is interesting.
Maybe I'll get some extra output from `manage.py test`.

Turns out that I do.
I need to set a database engine after all.
The comments in the settings.py file explain how to set up sqlite3.

Once I've got that, `manage.py test` works.
I commit and, sure enough, Jenkins reports a successful run.

For next time
-------------

This is turning into a long tutorial, so I'll settle for the basic setup we've
got so far. Next time, I'll handle (some of) the following subjects:

#. Adding tasks
#. Adding reports
#. Creating a division between functional tests and unit tests

Little Extra for Gnome Shell users
----------------------------------

If you're using Gnome Shell, there's a nice plugin called
`Jenkins CI Server Indicator <https://extensions.gnome.org/extension/399/jenkins-ci-server-indicator/>`_.
I'm a sucker for these things.
