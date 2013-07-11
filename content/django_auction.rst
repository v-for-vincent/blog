Writing an AJAX-powered auction in Django
#########################################

:date: 2013-07-11
:tags: Django
:category: Python
:slug: auction-in-django
:author: Vincent Nys
:status: draft
:summary: A complete rundown of my recent Github project.

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
It does not assume that you have worked with Django before, but it only
explains the concepts that are used for the web app.
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
I'll be using that. Specifically, I'll be using django-jenkins and
I'll be basing my experiments here on
`this tutorial <https://sites.google.com/site/kmmbvnr/home/django-jenkins-tutorial>`_.

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
