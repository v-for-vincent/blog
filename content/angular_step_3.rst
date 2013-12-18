AngularJS tutorial walkthrough (step 3)
=======================================

:date: 2013-12-15
:tags: web, AngularJS, Javascript, tutorial, walkthrough
:category: Web development
:slug: angular-part-3-walkthrough
:author: Vincent Nys
:summary: Questions raised and answers proposed during the AngularJS tutorial
:status: draft

Remarks on a quick first reading
--------------------------------

Some things struck me on my first attempt to comprehend the tutorial:

- What does the "fluid" in the new code stand for?
- The ngModel directive is referenced.
  How is it different from what we've seen before?
- Something that looks a lot like a UNIX pipe is used to filter phones 
  through `filter:query`.
- Is the backing model really bound to an input's `name` in the DOM sense?
- What does the `filter` function filter *on*?
  Phones have different attributes, so which, if any, is used for the
  full-text search and why?
- Jasmine test syntax seems to be worth looking into.
- Does the ngBind template replace the text of the element
  it's associated with, or does it doe something else?
- Is there an `unpause` statement in addition to the `pause`?

Some answers
------------

- The "fluid" bit is irrelevant; it might be related to a grid framework.
- `ng-model = "query"` can be read as "consider the value of this element
  to be a variable called `query`. As such, binding does not actually
  rely on an HTML element's name, but rather on what comes after the
  `ngModel` directive.
  This is different from what we've seen before in the sense that it's
  a "direct" manifestation of the data model.
- The "pipe" will probably display quite a bit of functional overlap
  with, say, list comprehensions.
- The `filter` function is a flexible beast. If we supply a objects
  to be filtered and if we supply a string as a predicate, the
  behaviour is to check whether any properties contain the string
  as a substring. But we can also supply other types of predicates,
  including arbitrary functions. Moreover, we can supply a comparator
  to include based on the type of match we get (i.e. equal, <=, >=,...)
- `ngBind` is pretty much the same as using curly braces. The difference
  is that, because it's not written out as element text, it isn't displayed
  before page load. So if, for some reason, curly braces are anathema to your
  users, the directive could be worth looking into.
