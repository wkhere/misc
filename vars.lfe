(defmodule vars
  (export all)
  (export (init 0) (def 1) (def 2) (get 1) (set 2) (show 0)))

(defun get-ets (tabname)
  (case (: ets info tabname 'name)
    ('undefined (: ets new tabname '[set named_table public]))
    (tab tab)))

(defmacro varstab () ''lfevars)
;;(defmacro varstab-bk () ''lfevars-backup)
;;(defun varsfile () (: filename join (: os getenv '"HOME") '".lfevars.dts"))

(defun init ()
  (get-ets (varstab)))
  
(defun def (x)
  (def x 'undefined))
(defun def (x v)
  (let (('true (: ets insert (varstab) (tuple x v))))  v))

(defun get (x)
  (let (([(tuple _ v) . _]  (: ets lookup (varstab) x)))  v))

(defun set (x v)
  (def x v))

(defun show ()
  (lc ((<-[kv . _] (: ets match (varstab) '$1))) kv))

;; (defun save ()
;;   (save (varsfile)))
;; (defun save (to-file)
;;   (let* (((tuple 'ok bk) (: dets open_file (varstab-bk) `[#(file ,to-file)]))
;; 	 ('ok (: dets from_ets bk (varstab)))
;; 	 ('ok (: dets close bk)))
;;     `#(ok ,to-file)))
