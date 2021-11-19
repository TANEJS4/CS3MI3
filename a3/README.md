# CS 3MI3 - Assignment 3 
###### Shivam Taneja, 400160537

### Question #1 - Ruby
* Design Specification:
  1. Used two modules `GCL` and `GCLe` with identical classes and subclasses but have differnt purpose.
  2. 3 classes `GCExpr` , `GCTest`, and `GCStmt` for both the modules
  3. Subclasses for  each class (common in both Modules):
        * `GCExpr` sub class:  `GCConst`, `GCVar`, `GCOp`.
        * `GCTest ` sub class :  `GCComp`, `GCAnd `, `GCOr`,`GCTrue`, and `GCFalse`.
        * `GCStmt` sub class:  `GCSkip`, `GCAssign`, `GCCompose`,`GCIf `, and `GCDo`. 
  4. Exception classes for `GCle` Module 
        * `GCStmt` sub class:  `GCLocal`. 
        * `GCProgram` class.
            3. The `initialize` constructor ensures that the number passed is an integer, by using `is_a?` function, and stores it in a class variable.
    3. The `initialize` constructor ensures that the arguments passes(if applicable) represent apt datatypes or class -used `is_a?` function.
  5. Code snippet 
    ```ruby
        # defining GCL and GCLe modules 
        module GCL 
            # GCExpr
            class GCExpr end
            class GCConst < GCExpr end
            class GCVar < GCExpr end
            class GCOp < GCExpr end
            class GCTest  end

            # GCTest
            class GCComp < GCTest  end
            class GCAnd <  GCTest end
            class GCOr <  GCTest end
            class GCTrue < GCTest end
            class GCFalse < GCTest end
            class GCStmt end

            # GCStmt
            class GCSkip < GCStmt  end
            class GCAssign < GCStmt  end
            class GCCompose < GCStmt   end
            class GCIf  < GCStmt  end
            class GCDo  < GCStmt  end
        end

        module GCLe 
            # GCExpr
            class GCExpr end
            class GCConst < GCExpr end
            class GCVar < GCExpr end
            class GCOp < GCExpr end

            # GCTest
            class GCTest  end
            class GCComp < GCTest  end
            class GCAnd <  GCTest end
            class GCOr <  GCTest end
            class GCTrue < GCTest end
            class GCFalse < GCTest end
            
            # GCStmt
            class GCStmt end
            class GCSkip < GCStmt   end
            class GCAssign < GCStmt   end
            class GCCompose < GCStmt   end
            class GCIf  < GCStmt   end
            class GCDo  < GCStmt   end
            class GCLocal  < GCStmt end 

            # GCProgram
            class GCProgram end
        end
    ```
### Question #1 - Clojure
* Design Specification:
    1. used `defrecord` to represent argumenets.
    Similar to Ruby, but in Clojure, There are no classes such as `GCExpr`,`GCTest `, and `GCStmt`. 
    2. Clojure represents only `GCL` classes and sub-classes.
    2. Code snippet 
    ```clojure
    (defrecord GCConst [value]) 
    (defrecord GCVar [symbol]) 
    (defrecord GCOp [exp1 exp2 sym]) 
    (defrecord GCComp [exp1 exp2 sym]) 
    (defrecord GCAnd [exp1 exp2]) 
    (defrecord GCOr [exp1 exp2]) 
    (defrecord GCTrue [] ) 
    (defrecord GCFalse []) 
    (defrecord GCSkip [] )
    (defrecord GCCompose [stmt1 stmt2])
    (defrecord GCIf [pair_list])
    (defrecord GCDo [pair_list])
    ```


### Question #2 - Ruby
* Design Specification:
    1. Created a method, in `GCL` module,  called `stackEvaL(comStack,resStack,memState)` that mimics evaluation of  `GCStmt` using a stack machines. The arguments of this function are, in order:
        * the command stack (implemented using a list) as `comStack`
        * the results stack (implemented a list) as `resStack`
        * the memory state (implemented using a lambda; that is, a block.) as `memState`
        and return updated memory state (lambda).
    2.  Function uses recrusive calls and concept of pattern matching to evaluate in the input and return the output.
        In stack machine, the nested expresion is decomposed into atomic items (using recursion to get the value of the nested values) one at a time, i.e. one the parent expression is decomposed, before it decomposes the enclosing expression, the command (enclosing expressions) are pushed on top of the stack `comStack` one by one. Where in the next iteration, enclosing expression (one at a time) are evaluated. If any expression evaluates into any constants, they are stored in resStack, i.e resultant of some expression is stored in resStack unless the expression `GCAssign`.
    3.  Incase of `GCAssign(variable, value)`, `variable`'s, or a symbol's, `value` is stored in memStack. 
    ```ruby
        memStack = {} #empty memory state
        #GCAssign(:s, 5)   -> assign variable ":s" to value "5".
        memStack[:s] = 5
        #{:s => 5}
    ```
    4. In case of `GCIf(list)`, it takes a list of tuple of guarded condition and command. We randomly select one command from the list where guarded conditions are satisfied.    
    
    5. function have 4 helper functions:
        * `eval(comStack,resStack, memState)`: This function is used for recursive calls to get values passed argument class.  It return updated resStack or comStack. 
        ```ruby
            class GCAssign < GCStmt  
                attr_reader :sym
                attr_reader :exp
                def eval(comStack, resStack, memState)
                    comStack.unshift(sym)
                    comStack.unshift(:assign)
                    comStack.unshift(exp)
                    return [comStack, resStack, memState]
            end
        ```
        * `operationHelper(resStack, command)`: In case command is an operation symbol, i.e. one of `[:times,:plus, :minus, :div,:or, :and, :assign,:eq,:less, :greater ]`, this helper is used to evaluate the result of the operation on the TWO recently added constants in resutant Stack.
        * `emptyState`: return empty Hash. In our representation, it the memory state which is interpreted as lambda.
        * `updateState(prevState, var, val)`: updates old memory state with new values or add new variable & value. This function is used by `:assign` command.  

### Question #3 - Clojure
* Design Specification:
    1. Created function called `reduce` that pattern matches the records or input - nestes expression - to evaluate to a constant value (Integer or Boolean).
    2. Function works the same way as **`Question 2 - Ruby`** i.e. we have memory state that keeps record of all variable assignment.
    3. 2 Helper functions:
        * `emptyState`: returns empty lambda
        * `updateState[sig var value]`: takes in previous memory state(`sig`) and updates the value of `var` and adds it if does not exist yet. 
        ```clojure
        (defn updateState [sig var value] (fn [com] (if (= var com) value ((sig) com))))
        ```
    3. Code snippet for one of the pattern
    ```clojure
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
                                        ))
    ```
### Question #4 - Ruby
* Design Specification:

    Created two methods, in `GCLe` module, called `wellScoped(program)` and `eval(stmt)` which return `true/false` and lambda hash, respectively.

    *  `wellScoped(program)`
        1. Method only takes one input - subclasss `GCProgram` - and returns `true/false` based on  whether the expression is well-scoped in local and global environment.
        2. Uses helper class function called `scoped(local_env , local_vars, global_env,global_vars)` which takes 4 lists that represents local environment, local variables in the expression, global environment, and global variables. The class function updates concerned lists. For example:
            * Only `GCProgram` is the only class that can update can access global environment.
            * Only `GCLocal` is the only class that can update can access local environment.
            * All other classes can update only update local and global variable list.
        3. Code snippet for some class functions:
            * `GCAssign`
            ```ruby
                class GCAssign < GCStmt  
                    attr_reader :sym
                    attr_reader :exp

                    def scoped(local_env , local_vars, global_env,global_vars)
                        local_vars.unshift(sym)
                        return exp.scoped(local_env , local_vars, global_env,global_vars)
                    end
                end
            ```
            and `GCProgram`
            ```ruby 
                class GCProgram
                    attr_reader :list_symbol
                    attr_reader :stmt

                    def scoped(local_env , local_vars, global_env,global_vars)
                        global_env = list_symbol
                        if stmt.is_a?(GCLocal)
                            @@local_scoped = true
                        end
                        return stmt.scoped(local_env , local_vars, global_env,global_vars)
                    end
                end
            ```
        4. There is a module-wide variable called `local_scoped` that is used to know if local environment should be check or not.
    *  `eval(stmt)`
        1. Method only takes one input and returns lambda hash with variables assigned to constant, after evaluated the nestes expression. Similar to `stackEval` method in `GCL` module, but this uses Big-step evaluation instead of `stackEval`'s small step evaluation methodology, i.e. the way each subclass execute is similar. 
        2. First it uses `wellscope` to check if the nested expression has proper variable scoping across its environment. Then uses helper class function called `eval(memState)` which takes memory state to keep track of variable assigned to a value. At last, we call `clear_local` to re-assign global variable to local variable's value in the memory.
        For example,
        ```ruby
        puts memState  # current state of memmory
        # {:y => :t, :t = 5}    global variable :y is assigned to local variable :t and   local variable  is assigned to contant value 5

        memState = clear_local(memState)
        puts memState
         # {:y => 5}
        ```
        3. Code snippet for some class functions:
            * `GCIf`
            ```ruby
                    class GCIf  < GCStmt  
                        attr_reader :pair_list
                        def eval(memState)
                            true_list=[]
                            pair_list.each do |elem|
                                if elem[0].eval(memState)
                                    true_list.push(elem[1])
                                end
                            end
                            selectCom = true_list.sample
                            return selectCom.eval(memState)
                        end
                    end
            ```
            and `GCConst`
            ```ruby 
                    class GCConst < GCExpr
                        attr_reader :value
                        def eval(memState)
                            return value
                        end
                    end
            ```
