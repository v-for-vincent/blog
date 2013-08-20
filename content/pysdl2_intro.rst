===========================
Getting started with PySDL2
===========================

Intro
=====
I noticed `SDL2 <http://www.libsdl.org>`_ was released a few days ago.
Sounds like a good time to start toying with
`PySDL2 <https://bitbucket.org/marcusva/py-sdl2>`_, which is what you
could consider `PyGame <http://www.pygame.org>`_ for SDL2. The
`documentation <http://pysdl2.readthedocs.org/en/latest/>`_ is decent,
but it could be more complete. It's also a little
advanced. So let's try to make a promising library a bit more accessible.
This post will cover installing PySDL2 and checking your installation,
and it assumes minimal knowledge of Python.

Installation
============

Non-Python dependency
+++++++++++++++++++++
PySDL2 assumes that you have SDL2 installed on your system. You'll need
to grab that from the main SDL website. I run Ubuntu and there are no .deb
packages available, so I had to grab the .tar.gz. 

.. todo:: opname installatie via shelr toevoegen -> op sokrates

Note that, technically, you can supply an SDL library along with your PySDL2
project. I've never packages up and supplied libraries this way, though,
so I just installed the library on my system. It's probably better if you
supply a library when you package the final program or game, though. That way,
there's no risk of backward incompatibilities popping up later on.

Python environment
++++++++++++++++++
If you just want to muck around a bit, you can just `pip install pysdl2`.
I'd like to build something in the environment we're currently setting up,
though, so I'll set up things properly with
`Python Cookie Cutter <https://github.com/audreyr/cookiecutter>`_.

.. todo:: opname setup virtualenv toevoegen

Now, to create the project **in your home directory**, just open up a terminal
and follow the steps on
`PyDanny's page <http://pydanny.com/cookie-project-templates-made-easy.html>`_.
In my case, the process went as follows:
.. todo:: opname clone en invullen template invullen

Or run this from inside a particular directory, like ~/Projects, if you want
to keep your project outside of your home dir. I did this after I noticed
the project was created in the current directory.

Once you've got that set up, you'll want a virtualenv for the new project as
well. `mkvirtualenv pysdl2demonstration` and `pip install pysdl2` should do
the trick. Now, if you run a Python interpreter and try to import `sdl2`,
you'll likely get a `RuntimeError: could not load any library for SDL2`.

The PySDL2 documentation says this:

   If the user has a SDL2 library installed on the target system, the ctypes hooks of sdl2 try to find it in the OS-specific standard locations via ctypes.util.find_library().

Oddly (I've never worked with ctypes before), I can `import ctypes` and get
a result for `ctypes.util.find_library("SDL2")`, but I still get the error.
I know where the library is, though: it's in /usr/local/lib. So I could just
set the environment variable `PYSDL2_DLL_PATH`, but that feels a little
hackish. I have SDL2 installed on my system, so I expect things to behave
normally for that situation. So let's start by checking where
`find_library` looks by default.
