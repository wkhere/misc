(proclaim '(optimize speed))

(defun fac- (x)
  (if (<= x 1)
      x
      (* x (fac- (1- x)))))

(defun fac (x &optional (acc 1))
  (if (<= x 1)
      acc
      (fac (1- x) (* acc x))))

(defmacro timer (&body body)
  `(time (progn ,@body (values))))
