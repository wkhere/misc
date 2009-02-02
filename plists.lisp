(defun make-plist-comparison-expr (field value)
  `(equal (getf plist ,field) ,value))

(defun make-plist-comparisons-list (fields)
  (loop while fields collecting 
       (make-plist-comparison-expr (pop fields) (pop fields))))

(defmacro plist-where (&rest clauses)
  `#'(lambda (plist) (and ,@(make-plist-comparisons-list clauses))))


(defun plist-select (plist selector-fn)
  (remove-if-not selector-fn plist))

