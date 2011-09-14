#lang racket
(provide (all-defined-out))

(define (id x) x)


(define (interpose sep xs)
  (reverse (r-interpose sep xs empty)))

(define (r-interpose sep xs acc)
  (match xs
         [(list* x y ys)
          (r-interpose sep (cons y ys) (list* sep x acc))]
         [(list x)
          (cons x acc)]
         [(list)
          acc]))


(define (take-while pred? xs 
                    #:acc-reversed? [acc-reversed? #f])
  (let ([acc-transform (if acc-reversed? id reverse)])
    (let/ec ret
      (foldl (lambda (x acc)
               (if (pred? x)
                   (cons x acc)
                   (ret (acc-transform acc))))
             empty
             xs))))

(define (drop-while pred? xs)
  (memf (compose not pred?) xs))

(define (split-with pred? xs 
                    #:acc-reversed? [acc-reversed? #f])
  (let ([acc-transform (if acc-reversed? id reverse)])
    (define iter 
      (match-lambda*
       [(list acc1 (list* y ys))
        (if (pred? y)
            (iter (cons y acc1) ys)
            (values (acc-transform acc1) (cons y ys)))]
       [(list acc1 (list))
        (values (acc-transform acc1) empty)]))
    (iter empty xs)))
