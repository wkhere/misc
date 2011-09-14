#lang racket
(require racket/gui/base)
(require racket/draw)
(require racket/flonum)

(define canvas1%
  (class canvas%
         (define/override (on-char ev)
           (printf "* kbd ev ~s  " (send ev get-key-code))
           (flush-output))
         (super-new)))

(define evs (make-eventspace))
(define w
  ;; without the new eventspace window refreshing sux:
  (parameterize ([current-eventspace evs])
    (new frame% [label "FOO"] [width 200][height 200])))
(define c
  (new canvas1% [parent w]
       [paint-callback 
        (lambda (canvas dc)
          (send dc set-font (make-object font% 12 'modern
                                         'normal 'bold #f 'partly-smoothed #f))
          (send dc set-text-foreground (make-object color% 240 240 240))
          (send dc draw-text "Mandelbrot !!" 2 2)
          )]))
(send c set-canvas-background
      (send the-color-database find-color "black"))
(define dc (send c get-dc)) ; further drawing is possible!

(define (mandel x0 y0  x1 y1  xp yp  iters)
  (let ([dx (fl/ (fl- x1 x0) (->fl xp))]
        [dy (fl/ (fl- y1 y0) (->fl yp))])
    (do ([x x0 (fl+ x dx)] [xi 0 (add1 xi)])
        ((>= xi xp))
      (do ([y y0 (fl+ y dy)] [yi 0 (add1 yi)])
          ((>= yi yp))
        (mandel-pixel (calc-mandel iters x y) xi yi)))))
        
(define color-tab '[[20 "white"]
                    [10 "yellow"]
                    [ 8 "green"]
                    [ 6 "cyan"]
                    [ 5 "red"]
                    [ 3 "magenta"]
                    [-1 "blue"]])
(define (mandel-pixel fractality xi yi)
  (define color
    (if (eq? fractality 'in-set)
        "black"
        (second (findf (lambda (kv) (>= fractality (first kv))) color-tab))))
  (send dc set-pen color 1 'solid)
  (send dc draw-point xi yi))
  
(define (calc-mandel maxiter x0 y0)
  (define (loop i x y)
    (let ([x2 (fl* x x)] [y2 (fl* y y)])
      (cond
       [(fl>= (fl+ x2 y2) 4.0)  i]
       [(>= i maxiter)  'in-set]
       [else
        (let ([ny (fl+ (fl* 2.0 (fl* x y)) y0)]
              [nx (fl+ (fl- x2 y2) x0)])
          (loop (add1 i) nx ny))])))
  (loop 0 x0 y0))

(define (run)
  (mandel -1.8 -1.2  0.7 1.2  200 200 25))


(send w show #t)
(run)
(yield evs)
