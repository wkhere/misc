(in-package :sicp)

(defun cube (x) (* x x x))

(defun sum-integers (a b)
  (if (> a b)
      0
      (+ a (sum-integers (1+ a) b))))

(defun pi-sum (a b)
  (if (> a b)
      0
      (+ (/ 1.0 (* a (+ a 2))) (pi-sum (+ a 4) b))))

(defun sum (term a next b)
  (if (> a b)
      0
      (+ (funcall term a)  ; non tail-call
	 (sum term (funcall next a) next b))))

(defun sum (term a next b)
  (labels ((rec (acc x)
	     (if (> x b)
		 acc
		 (rec (+ acc (funcall term x)) (funcall next x)))))
    (rec 0 a)))

(defun sum-integers (a b)
  (sum #'identity a #'1+ b))

(defun pi-sum (a b)
  (sum (lambda (x) (/ 1.0 (* x (+ x 2)))) a (lambda (x) (+ x 4)) b))

(defun integral (f a b dx)
  (* (sum f (+ a (/ dx 2.0)) (lambda (x) (+ x dx)) b)
     dx))

(defun test-integral ()
  (mapcar (lambda (dx) (integral #'cube 0 1 dx))
	      '(1e-1 1e-2 1e-3 1e-4)))

(defun accumulate (combiner nullval term a next b)
  (labels ((rec (acc x)
	     (if (> x b)
		 acc
		 (rec (funcall combiner acc (funcall term x))
		      (funcall next x)))))
    (rec nullval a)))

(defun sum (term a next b)
  (accumulate #'+ 0 term a next b))

(defun product (term a next b)
  (accumulate #'* 1 term a next b))

(defun fac (n)
  (product #'identity 1 #'1+ n))

