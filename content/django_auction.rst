Writing an AJAX-powered auction in Django
#########################################

:date: 2013-07-11
:tags: Django
:category: Python
:slug: auction-in-django
:author: Vincent Nys
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
Quite a bit of emphasis will be placed on how the application can be tested,
because I feel you can't learn proper testing practices for a framework soon
enough.

