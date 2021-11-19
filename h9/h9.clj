(defrecord GuardedCommand [guard command])


; part 1
(defn allowed-commands [commands]
  (if (empty? commands) nil
      (let[[command & rest] commands]
        (if (eval (.guard command)) (cons (.command command) (allowed-commands rest))
        (allowed-commands rest)
        )
      )
  )
)

; part 2
(defmacro guarded-if [& commands]
  `(eval (rand-nth (allowed-commands [~@commands])))
)

; part 3
; (defmacro guarded-do [& commands]
;   `(eval (allowed-commands [rand-nth ~@commands])) 
; )

; part 4

(defn gcd [a b]
  ( guarded-if 
    (GuardedCommand. `(= 0 ~b) a )
    (GuardedCommand. `(not (= 0 ~b)) `(gcd ~b (mod ~a ~b)) )
  )
)
