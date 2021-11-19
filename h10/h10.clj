(load-file "./collection.clj")

(defn summingPairs [xs sum]
    (letfn [(summingPairsHelper [xs the_pairs]
            ;; If `xs` is empty, we're done.
        (if (empty? xs) the_pairs
            ;; Otherwise, decompose `xs` into the `fst` element
            ;; and the `rest`.
            (let [[fst & rest] xs]
                ;; We use the `recur` form to make the recursive call.
                ;; This ensures tail call optimisation
                (recur
                    rest
                    ;; Concatenate `the_pairs` we have so far with the sequence
                    ;; of every `[fst snd]` where `snd` is in `rest` with
                    ;; `fst + snd <= sum`. The `doall` outside the `concat`
                    ;; forces it to be calculated immediately; without this,
                    ;; we get a (lazy) buildup of `concat`'s which may
                    ;; cause a stack overflow when looking at the result.
                    (doall 
                        (concat the_pairs
                            (for [snd rest ;; For each `snd` in `rest`...
                                :when (<= (+ fst snd) sum)]
                            ;;... put `[fst snd]` into this sequence.
                            [fst snd])))))))]
    (summingPairsHelper xs [])))

(defn concurrentSummingPair [xs sum]

)



(println (str
            "Starting at:   "
            (.getSecond (java.time.LocalDateTime/now))
            " seconds, "
            (.getNano (java.time.LocalDateTime/now))
            " nanoseconds"))
(println (summingPairs input 2020))
(println (str
            "Ending at:     "
            (.getSecond (java.time.LocalDateTime/now))
            " seconds, "
            (.getNano (java.time.LocalDateTime/now))
            " nanoseconds"))