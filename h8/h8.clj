(load-file "./unwindrec.clj")

(unwindrec exponent [n e]

            (= e 0) 1
            (> e 0) (* n (exponent n (- e 1)))
            (throw (Exception. "Trying to calculate factorial of a negative number."))

    )

(defn exponent-tr [n e]
    (unwindrec exponent-tr-helper [ n e collect]
                (= e 0) collect
                (> e 0 ) (exponent-tr-helper n (- e 1 ) (* collect n))
                (throw (Exception. "Trying to calculate factorial of a negative number."))
    )
    (exponent-tr-helper n e 1) 
    )

(unwindrec sumlist [l]
            (empty? l) 0
            (= (empty? l) false) (+ (first l) (sumlist (rest l)))
            (throw (Exception. "error occured"))
    )

(defn sumlist-tr [list]
    (unwindrec sumlist-tr-helper [list xs]
                (empty? list) xs
                (= (empty? list) false) (sumlist-tr-helper (rest list) (+ (first list) xs))
                (throw (Exception. "error occured")))
    (sumlist-tr-helper list 0)
    )

(unwindrec flattenlist [list]
    (empty? list) ()
    (= (empty? list) false) (into (flattenlist (rest list)) (reverse (first list)))
    (throw (Exception. "error occured")))

(defn flattenlist-tr [list]
    (unwindrec flattenlist-tr-helper [list remaining]
                (empty? list) remaining
                (= (empty? list) false) (flattenlist-tr-helper (rest list) (into (first list) (reverse remaining)))
                (throw (Exception. "error occured")))
    (flattenlist-tr-helper list '()))

(unwindrec postfixes [list]
    (empty? list) (reverse (cons () list))
    (= (empty? list) false) (cons list (postfixes (rest list)))
    (throw (Exception. "error occured"))
    )


(defn postfixes-tr [list]
    (unwindrec postfixes-tr-helper [list xs]
                (empty? list) (reverse (cons () xs))
                (= (empty? list) false) (postfixes-tr-helper (rest list) (cons list xs))
                (throw (Exception. "An exception occurred.")))
    (postfixes-tr-helper list '())
    )
