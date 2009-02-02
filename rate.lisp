;;;; -*- lisp -*-

(defvar *interest-rates* (list (cons 'tax 0.11)))

(defun interest-rate (days year-rate &key (addto1 nil) (days-acc #'identity))
  (let ((rate (* (funcall days-acc days) year-rate 1/365)))
    (if addto1
	(1+ rate)
	rate)))
  

(defun interest-rate-tax (days &key (addto1 nil))
  (interest-rate 
   days 
   (cdr (assoc 'tax *interest-rates*)) 
   :addto1 addto1))

