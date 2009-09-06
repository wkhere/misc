(defmodule sandbox
  (export all))

(include-file "tools.lfi")

(defun how-arg-patterns-are-matched 
  ((x) (when (is_number x)) (+ 23 x))
  (((= e (tuple _))) (tuple 'single e))
  (((= e [x . _])) (tuple 'nonzero-list e)))

(defun another-compose
  ((fs)
   (lambda (x) (foldl (lambda (f v) (funcall f v)) x fs))))

(defun del-dups
  ((xs) (del-dups xs '[])))
(defun defun-for-different-arities-can-be-separated-by-other-defun ())
(defun del-dups
  (('[] acc) (reverse acc))
  (([x y . xs] acc) (when (== x y)) (del-dups (cons x xs) acc))
  (([x . xs] acc) (del-dups xs (cons x acc))))

(defun check-compilation-to-core ()
  (andalso (eq 1 1) 'true))

(defun example-fns ()
  [list (fn (x) (+ 10 x)) (fn (x) (* 2 x))])

(defun compose-test1 (x)
  (map (fn (f) (funcall f x))
       [list (compose (example-fns)) (chain (example-fns))]))

(defun macrology-test1 ()
  (let1 l '[1 2 3 4 5 6]
	(list
	 (car' [])
	 (cdr' [])
	 (cdr' l)
	 (nthcdr' 4 l)
	 (nthcdr' 10 l)	 
	 (macrolet1 (foo () 42) (foo))
	 (let/ [x 1 y 2] `[,x ,y])
	 (macrolet1/f (foo (x) (+ 10 x)) (foo 20))
	 (test)
	 'ok)))
