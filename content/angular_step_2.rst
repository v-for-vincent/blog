AngularJS tutorial walkthrough (step 2)
=======================================

:date: 2013-12-14
:tags: web, AngularJS, Javascript, tutorial, walkthrough
:category: Web development
:slug: angular-part-2-walkthrough
:author: Vincent Nys
:summary: Questions raised and answers proposed during the AngularJS tutorial

Getting started with AngularJS
------------------------------

`AngularJS <www.angularjs.org>`_ seems to be all the rage these days.
For my job, I do quite a bit of frontend development, so I figured it
was high time I had a look at it. It's accessible, but there were a few
hiccoughs in my case, so I figured a blog post might help others.

First, let me mention that I'm running Ubuntu 13.10.
This is relevant because in that version, NodeJS (which appears to
be something of an analogue to Python's `Twisted <www.twistedmatrix.com>`_)
is not run using the standard `node` command, but rather using the
`nodejs` command. I'll also mention that I can muck around in JS a bit,
but that I do not know the core concepts of the language very well. That
is, I do not typically go around changing prototypes, etc.

Now, the first two parts of the tutorial are quite trivial.
Step 2 is a bit longer than 0 and 1, and it requires you to think a bit.
Here are some of the points I came across:

- The term "directives" is used, but it is not explained. I'm taking it
  to mean that AngularJS is configured based on the declaration of these
  things. Because the tutorial distinguishes between the attribute used
  to declare the directives in HTML and the directives themselves, I'm going
  to assume directives exist as objects of some sort in the backing JS code.

- The diagrams in the tutorial are important. They do not simply reinforce
  what is said in the text, they complete the message.

- The AngularJS definition of the "model" appears to be data-only.
  Not everyone has the same definition of model-view-controller, so that's
  worth noting. Also, AngularJS appears to be close to Django in the sense
  that the real view in the rendered HTML, and that the "template" tells us
  how data are displayed.

- At this step in the tutorial, the only relevant JS appears to be in
  `controllers.js`. At this stage, at least, the app is declared in the
  same place as the controller. The latter appears to be little more than
  a function that is named by supplying an argument to the `controller`
  function of an angular `module`.

- The **scope** is not really the model, but it is where the model lives.
  The model itself consists of data, which are wrapped in a scope, which
  in turn is made accessible to the controller.

- By attaching the controller to an HTML element (using the ngController
  directive) we can start accessing the model from the controller, thanks
  to the scope. We have automatic access to the scope, i.e. we don't write
  `scope.phones` or anything like that in the HTML, just `{{phones}}`.

- Controllers can be registered in the global namespace, so that individual
  objects can be created manually, but this should be avoided. They are
  normally registered in an app. In the case of tests, when we do want explicit
  access to the controllers, we use dependency injection.
  The syntax is not entirely clear to me at this time, but it works like this:
  rather than explicitly constructing an object with `new`, we describe what
  we want, i.e. a controller with the name `PhoneListCtrl` and the supplied
  scope. The service appears to act as an inversion-of-control container.
  I'll definitely look into this in the future.

- To run the tests on Ubuntu, make sure `nodejs` is used instead of `node`.
  Symlinking was enough to install libraries using `npm`, the NodeJS package
  manager, but not enough to run the test script. However, the latter refers
  to the `karma` program, which declares that it should be run with `node`
  after the initial `#!` ("shebang", IIRC). I may need a more general solution
  in time, but for now, just open the `karma` program and change the
  declaration from `node` to `nodejs` if you're in the same situation I was
  in just now.

- When the tutorial says to "create a new model property in the controller",
  what is meant is that extra data should be made accessible within the scope.
  Essentially, define a new member on the scope.
