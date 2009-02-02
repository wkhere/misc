(defstruct queue head last)

(defun qadd (item q)
  (let* ((q q)
	(butlast (queue-last q))
	(newcons (list item)))
    (setf (queue-last q) newcons)
    (if (null butlast)
	(setf (queue-head q) newcons)
	(setf (cdr butlast) newcons))
    q))

(defun qpop (q)
  (let* ((q q)
	 (top (pop (queue-head q))))
    (unless (queue-head q)
      (setf (queue-last q) nil))
    (values top q)))

	 
    
  