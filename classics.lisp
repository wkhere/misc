(defun ack (m n)
  (cond ((zerop m) (1+ n))
	((plusp m) (cond ((zerop n) (ack (1- m) 1))
			 ((plusp n) (ack (1- m) (ack m (1- n))))
			 (t (error "Function only defined for positive values of n"))))
	(t (error "Function only defined for posivite values of m"))))

(defun mc91 (n)
  (cond ((< n 1) (error "Function only defined for positive values of n"))
        ((<= n 100) (mc91 (mc91 (+ n 11))))
        (t (- n 10))))

(defun primep (number)
  (when (> number 1)
    (loop for fac from 2 to (isqrt number) never (zerop (mod number fac)))))

(defun next-prime (number)
  (loop for n from number when (primep n) return n))

(defmacro with-gensyms ((&rest names) &body body)
  `(let ,(loop for n in names collect `(,n (gensym)))
     ,@body))

(defmacro do-primes ((var start end) &body body)
  (with-gensyms (ending-value-name)
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var)))
	  (,ending-value-name ,end))
	  ((> ,var ,ending-value-name))
     ,@body)))

