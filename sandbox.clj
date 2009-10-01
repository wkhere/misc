(defmacro tc [& body] 
  `(let [t0# (System/nanoTime) res# (do ~@body) t1# (System/nanoTime)] 
	{:res res# :time (/ (- t1# t0#) 1000.0)}))

(defmacro read-str [s]
  `(read (java.io.PushbackReader. (java.io.StringReader. ~s))))

(defn str2is [s]
  (-> s .getBytes java.io.ByteArrayInputStream.))

(defn tagsoup [s h]
  (let [p (new org.ccil.cowan.tagsoup.Parser)] 
       (.setContentHandler p h)
       (.parse p s)))

(defn parse [in]
  (let [s (if (seq? in)
	      ;; todo: use PipedReader or sth
	      (java.io.StringReader. 
	       (clojure.contrib.str-utils/str-join "\n" in))
	    in)]
  (clojure.xml/parse (org.xml.sax.InputSource. s) tagsoup)))

(defn drop-eqlist [l1 l2]
  (if (and (empty? l1) (empty? l2)) :eq
    (let [[x & xs] l1 [y & ys] l2]
	 (if (= x y) (recur xs ys)
	   [:non-eq x y]))))

(comment
 
 (ns my (:require [clojure.zip :as z][clojure.xml :as x][clojure.contrib.zip-filter.xml :as zx]))
 (import '(java.net URL))

)