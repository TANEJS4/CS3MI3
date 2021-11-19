; expr
(defrecord GCConst [value]) 
(defrecord GCVar [var]) 
(defrecord GCOp [exp1 exp2 sym]) 
(defrecord GCComp [exp1 exp2 sym]) 

; stmt
(defrecord GCAnd [t1 t2]) 
(defrecord GCOr [t1 t2]) 
(defrecord GCTrue [] ) 
(defrecord GCFalse []) 
(defrecord GCSkip [] )
(defrecord GCCompose [stmt1 stmt2])
(defrecord GCAssign [var exp])

(defrecord Config [stmt sig])
; helper functions to update memory
(defn updateState [sig var value] (fn [com] (if (= var com) value ((sig) com))))
(defn emptyState [] (fn [com] 0))


(defn reduce [someCommand]
    (let [command (.stmt someCommand)]
        (cond

        (instance? GCVar command)
            (Config. ((.sig someCommand) (.var command)) (.sig someCommand))

        (instance? GCAnd command)
            (if (or (instance? GCTrue (.t1 command)) (instance? GCFalse (.t1 command)))
                (if (or (instance? GCTrue (.t2 command)) (instance? GCFalse (.t2 command)))
                    (if (and (instance? GCTrue (.t1 command)) (instance? GCTrue (.t2 command)))
                        (Config. (GCTrue.) (.sig someCommand))
                            (Config. (GCFalse.) (.sig someCommand))) 
                                (let [newcommand (reduce (Config. (.t2 command) (.sig someCommand)))]
                                (Config. (GCAnd. (.t1 command) (.stmt newcommand)) (.sig newcommand))
                                ))
                                    (let [newcommand (reduce (Config. (.t1 command) (.sig someCommand)))]
                                    (Config. (GCAnd. (.stmt newcommand) (.t2 command)) (.sig newcommand))
                                    )
            )

        (instance? GCOr command)
            (if (or (instance? GCTrue (.t1 command)) (instance? GCFalse (.t1 command)))
                (if (or (instance? GCTrue (.t2 command)) (instance? GCFalse (.t2 command)))
                    (if (or (instance? GCTrue (.t1 command)) (instance? GCTrue (.t2 command)))
                        (Config. (GCTrue.) (.sig someCommand))
                            (Config. (GCFalse.) (.sig someCommand))) 
                                (let [newcommand (reduce (Config. (.t2 command) (.sig someCommand)))]
                                (Config. (GCAnd. (.t1 command) (.stmt newcommand)) (.sig newcommand))
                                ))
                                    (let [newcommand (reduce (Config. (.t1 command) (.sig someCommand)))]
                                    (Config. (GCAnd. (.stmt newcommand) (.t2 command)) (.sig newcommand))
                                    ))

        (instance? GCOp command)
            (if (instance? GCConst (.exp2 command))
                (if (instance? GCConst (.exp2 command))
                    (cond
                    (= :plus  (.sym command)) (Config. (+ (.value (.exp2 command)) (.value (.exp2 command))) (.sig someCommand))
                    (= :minus (.sym command)) (Config. (- (.value (.exp2 command)) (.value (.exp2 command))) (.sig someCommand))
                    (= :times (.sym command)) (Config. (* (.value (.exp2 command)) (.value (.exp2 command))) (.sig someCommand))
                    (= :div   (.sym command)) (Config. (/ (.value (.exp2 command)) (.value (.exp2 command))) (.sig someCommand))
                    )
                        (let [newcommand (reduce (Config. (.exp2 command) (.sig someCommand)))]
                        (Config. (GCOp. (.exp2 command) (.stmt newcommand) (.sym command)) (.sig newcommand))
                        ))
                            (let [newercommand (reduce (Config. (.exp2 command) (.sig someCommand)))]
                            (Config. (GCOp. (.stmt newercommand) (.exp2 command) (.sym command)) (.sig newercommand))
                            )
            )

        (instance? GCComp command)
            (if (instance? GCConst (.exp2 command))
                (if (instance? GCConst (.exp2 command))
                    (cond
                    (= :eq      (.sym command)) (Config. (= (.value (.exp2 command)) (.value (.exp2 command))) (.sig someCommand))
                    (= :less    (.sym command)) (Config. (< (.value (.exp2 command)) (.value (.exp2 command))) (.sig someCommand))
                    (= :greater (.sym command)) (Config. (> (.value (.exp2 command)) (.value (.exp2 command))) (.sig someCommand))
                    )
                        (let [newcommand (reduce (Config. (.exp2 command) (.sig someCommand)))]
                        (Config. (GCOp. (.exp2 command) (.stmt newcommand) (.sym command)) (.sig newcommand))
                        )
                )
                            (let [newercommand (reduce (Config. (.exp2 command) (.sig someCommand)))]
                            (Config. (GCOp. (.stmt newercommand) (.exp2 command) (.sym command)) (.sig newercommand))
                            )
            )
        (instance? GCCompose command)
            (if (instance? GCSkip (.stmt1 command))
                (Config. (.stmt2 command) (.sig someCommand))
                    (let [newcommand (reduce (Config. (.stmt1 command) (.sig someCommand)))]
                    (Config. (GCCompose. (.stmt newcommand) (.stmt2 command)) (.sig newcommand))
                    )
            )

        (instance? GCAssign command)
            (if (instance? GCConst (.exp command))
                (Config. (GCSkip.) (updateState (.sig someCommand) (.var command) (.value (.exp command))))
                    (let [newcommand (reduce (Config. (.exp command) (.sig someCommand)))]
                    (Config. (GCAssign. (.var command) (.stmt newcommand)) (.sig newcommand))
                    ))
        
        )    
    )
)
