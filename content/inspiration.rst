Inspiration
===========

:date: 2014-08-31
:tags: Racket, inspiration
:category: Programming
:slug: inspiration
:author: Vincent Nys
:summary: A tiny, tiny Racket program to generate ideas

I'm intrigued by Racket and I started learning it by writing this:

.. code-block:: racket

   #lang racket
   ;; randomly choose a major and a minor emotion
   ;; used by the author as an inspiration for short fiction
   (define emotions '("rage" "greed" "fear" "willpower" "hope" "compassion" "love"))
   (define (pick items)
     (let ([index (random (length items))])
          (list-ref items index)))
   (define (select)
     (let ([major (pick emotions)]
           [minor (pick emotions)])
          (printf "major emotion: ~a\n" major)
          (printf "minor emotion: ~a\n" minor)))
   (select)

I wanted to do something creative but I didn't know how to start, so I looked up a range of emotions that I could draw on.
In a suitably geeky turn of events, that brought me to the "emotional spectrum" from Green Lantern.
Anyway, compile that with `raco exe`, move it to `usr/local/bin` and inspiration is just a command away.
