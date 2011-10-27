#lang racket

(define-syntax-rule (let1 [id e] . body) (let ([id e]) . body))

(provide/contract
 [quux symbol?]
 [foo1 (-> number? number?)]
 )
 
(define quux 'a)
(define (foo1 x) (list 32 x))

;; start with continuations: practical usage of escape cont:
(define (escape-example x)
  (let/ec ret
          (print '1st:) (ret x) (print '2nd:)))

;; restartable exceptions:

(define-syntax-rule (values->list vs)
  (call-with-values (lambda () vs) list))

(define (use-restarts e . restarts)
  (match (values->list (let/cc k (raise (list e k))))
         [(list* case args)
          (apply (cadr (assoc case restarts)) args)]))

(define (this-example-will-raise-exception)
  (for/fold ([acc empty])
            ([x (in-range -5 5)])
    (with-handlers
     ([exn:fail?
       (lambda (e)
         (use-restarts e `[skip ,(lambda () acc)]
                         `[use-value ,(lambda (v) (cons v acc))]))])
     (cons (/ 1 x) acc))))


(define (this-example-will-restart-on-exception)
  (with-handlers
   ([list?
     (match-lambda
      [(list e restart-k)
       (printf "I caught ~s~n" e)
       (printf "What to do [skip use-other] ? ")
       (case (read)
         [(use-other)
          (begin (printf "Enter value to use: ")
                 (restart-k 'use-value (read)))]
         [(skip)
          (restart-k 'skip)]
         [else (raise e)])])])
   (this-example-will-raise-exception)))

;; That's for restartable exceptions - basically it's working. I can
;; write some macros to make the constructs appear nicer and invent
;; some struct to hold wrapping exception - instead of list - to not
;; cause any ambiguity in upper with-handlers catcher.  I can also ask
;; the community if this is optimal, is cont type right etc.


;; Btw the right idiom for 'finally' is dynamic-wind:
(define (exception-finally-example)
  (dynamic-wind void (lambda () raise 1) (lambda () (display "*END\n"))))
;; btw^2 I can use (lambda _ stuff) when I ignore the number of args


;; now the amb, from http://rosettacode.org/wiki/Amb#Scheme

(define (fail) (error "amb tree exhausted"))

(define-syntax amb
  (syntax-rules ()
    [(amb) (fail)]
    [(amb expr) expr]

    [(amb expr ...)
     (let ([fail-save fail])
       ((let/cc k-success
          (let/cc k-failure
            (set! fail k-failure)
            (k-success (lambda () expr)))
          ...
          (set! fail fail-save)
          fail-save)))]))


;; "objects are poor man's closures" ;)

(define (mk-foo)
  (define ns (make-empty-namespace))
  (parameterize ([current-namespace ns])
    (define (bar) 42)
    (namespace-set-variable-value! 'bar bar)
    (define (quux) 23)
    (namespace-set-variable-value! 'quux quux) ; automate by macro
    )
  (define (dispatch name . args)
    (apply (namespace-variable-value name #f #f ns) args))
  dispatch)
