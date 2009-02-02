(defun f (x y)
  (+ x y))

; (f x y) == ((f x) y)

(defun f (x y)
  (funcall
   (lambda (y) (+ x y))
  y))

(defmacro s11 (f x)
  `(lambda (y) (,f ,x y)))
