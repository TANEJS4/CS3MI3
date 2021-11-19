# CS 3MI3 - Assignment 2 README
###### Shivam Taneja, 400160537

### Question #1 - Scala
* Design Specification:
  1. Used a sealed trait named `STTerm`.
  2. methods of `STTerm` type are:  `STVar`, `STApp`, `STAbs`, `STSuc`, `STIsZero`, `STTest` case classes and `STZero`, `STTrue`, `STFalse` case objects.
  3. Extended `STType` and created `STNat`, `STBool`, `STFun` case classes.

    ```scala
        sealed trait STTerm
        case class STVar(index: Int) extends STTerm
        case class STApp(t1: STTerm , t2: STTerm) extends STTerm
        case class STAbs(ty: STType, t: STTerm) extends STTerm
        case class STSuc(t: STTerm) extends STTerm 
        case object STTrue extends STTerm
        case object STFalse extends STTerm
        case object STZero extends STTerm
        case class STIsZero(t: STTerm) extends STTerm 
        case class STTest(b: STTerm, t1: STTerm, t2: STTerm) extends STTerm 
    ```
### Question #1 - Ruby
* Design Specification:
    1. Used inheritance to declare a parent class  `STTerm`. Child classes (same methods as Scala) extended `STTerm`.
    2. Code snippet of one of the class
    ```ruby
    class STVar < STTerm
        attr_reader :index

        def initialize(i)
            unless i.is_a?(Integer)
                return false
            end
            @index  = i
        end
    end
    ```
    3. The `initialize` constructor ensures that the number passed is an integer, by using `is_a?` function, and stores it in a class variable.

### Question #2 - Scala
* Design Specification:
  1. Created a function called `typecheck(term)` which returns a boolean value. There is a inner helper function(`typeOf(exprssion, environemtList`) to keep track of environment that are abstracted by `STAbs`. the return type of this helper function is `Option[STtype]` i.e. it returns either `STType` or `None`. This helper function is also used for pattern matching and recursion for nested expression. If the helper functions returns `None`, i return `false` else i return `true`.
  2. Now talking about that environment, as briefly explained, when a `STAbs(type, expression)` is encountered, I take the `type` argument and prepend it in my environment list (used `ListBuffer[STType]`). As environemt is passed in each recursive call, correct state of `environmentList` is maintained. 
  3. Class's pattern matching  are explained below:
        * `STVar(i)`
            * If the index `i` associated with `STVar` is in the environment list, the case returns the environment in the form `Some(env)`, else `None` is returned. I used `.lift(*index)` method which naturally returns in the form `Option[STType]`
            ```scala
            case STVar(i) => envList.lift(i)
            ```
        * `STZero`
            * Returns a `Some(STNat)`
        * `STTrue`
            * Returns a `Some(STBool)`
        * `STFalse`
            * Returns a `Some(STBool)`
        * `STIsZero(expression)`
            * Checks if the expression is `STZero` and returns returns `Some(STBool)` if true, otherwise `None`.
            * `STSuc(expression)`
            * Recursively checks the inner expressions, and if a `STNat` is found, it returns `Some(STNat)` otherwise `None`.
        * `STTest(boolValue, expression1, expression2)`
            * Recursively gets the inner two expressions and then checks if they are same, the resulting check value if then compared with the boolean value given in the STTest parameter. If it return value  matches, it returns `Some(STBool)`,else returns `None`. Code snippet is attached below.
            ```scala
            case STTest(b, t1, t2) => {
                var exp1 = typeOf(t1, envList)
                var exp2 = typeOf(t2, envList)
                if (typeOf(b, envList) == Some(STBool)){
                    if (exp1 == exp2 && b == STTrue) {
                        Some(STBool)
                    } else if (exp1 != exp2 && b == STFalse) {
                        Some(STBool)
                    } else {
                        None
                    }
                } else {
                    None
                }
            }
            ```
        * `STApp(expression1, expression2)`
            * Recursively gets the `Option[STType]` value of the two expression. If the first expression does not return `Some(STFun)`, it returns `None`. If the type of the domain of the first term, and the type of the second term are not the same, it returns `None`. Otherwise, it returns the codomain of the first term.
            ```scala
            case STApp(t1, t2) => {
                val val_A = typeOf(t2, envList) 
                val val_B = typeOf(t1, envList) 

                (val_A, val_B) match {
                    case (Some(a), Some(STFun(b, c))) => if (a != b) return None
                    
                }
                val_B match {
                    case  Some(STFun(dom, codom) )=> Some(codom) 
                    case _ => None
                }
            }
            case
            ```
### Question #2 - Ruby
* Design Specification:
  1. For each subclass of `STTerm`, I created a method called `typecheck` which returns a boolean value depending if the helper function returns `nil` value i.e. if helper function returns `nil`, `false` is returned.
  2. The helper function `typeOf(environemnt=Array.new)`. the function have optional argument, this arguments keeps track of our environment.
  Similar to scala implementation, helper function recursievly calls each subclass's `typeOf` to get apt return. 
  2. Now talking about that environment, as briefly explained, when a `STAbs(type, expression)` is encountered, I take the `type` argument and prepend it in my environment list (used `ListBuffer[STType]`) . As environemt is passed in each typeOf call, correct state of environment list is maintained. 
  3. Code snippets (with some explaination) for each subclass are below:
        * `class STVar < STTerm`
            * If the index `index` associated with `STVar` is in the environment list, the method returns the environment , else `nil` is returned. 
            ```ruby
                def typecheck
                    not typeOf().nil? 
                end
                def typeOf(environemnt=Array.new)
                    environemnt[index]
                end            
            ```
        * `STZero`
            * code
            ```ruby
                def typecheck
                    not typeOf().nil? 
                end
                def typeOf(environemnt=Array.new)
                    STNat.new
                end
                ```
        * `STTrue`
            * Returns a 
            ```ruby  
                def typecheck
                    not typeOf().nil? 
                end
                def typeOf(environemnt=Array.new)
                    STBool.new
                end
            ```
        * `STFalse`
            * Similar to `STTrue`
        * `STIsZero(expression)`
            * Checks if the expression is `STZero`(by using `is_a?`) and returns returns `STBool.new` if true, otherwise `nil`.
            * `STSuc(expression)`
            * Recursively checks the inner expressions, and if a `STNat` is found, it returns `Some(STNat)` otherwise `None`.
        * `STTest(boolValue, expression1, expression2)`
            * Recursively gets the inner two expressions and then checks if they are same, the resulting check value if then compared with the boolean value given in the STTest parameter. If it return value  matches, it returns `STBool.new`,else returns `nil`. Code snippet is attached below.
            ```ruby
                def typecheck
                    not typeOf().nil? 
                end
                def typeOf(environemnt=Array.new)
                    val_A  = @t1.typeOf(environemnt)
                    val_B  = @t2.typeOf(environemnt)
                    check_bool = @b.typeOf(environemnt)
                    if check_bool.is_a?(STBool)
                        if val_A == val_B && @b.boolValue?
                        STBool.new
                        elsif  val_A != val_B && @b.boolValue? == false
                        STBool.new
                        else
                        nil
                        end
                    end
                end
            ```
        * `STApp(expression1, expression2)`
            * Recursively gets the value of the two expression. If the first expression does not return `STFun.new(domain, codomain)`, it returns `nil`. If the type of the domain of the first term, and the type of the second term are not the same, it returns `nil`. Otherwise, it returns the codomain of the first term.
            ```ruby
                def typecheck
                not typeOf().nil? 
                end
                def typeOf(environemnt=Array.new)
                val_A  = @t2.typeOf(environemnt)
                val_B  = @t1.typeOf(environemnt)
                if val_B.is_a?(STFun) 
                    if val_B.dom != val_A 
                    return nil
                    end
                    return val_B.codom
                else
                    return nil
                end
                end
            ```










### Question #3 - Scala
* Design Specification:
  1. Created a function called `eraseTypes` which returns a `ULTerm` expression or throws error.

    2. `eraseTypes` calls a helper method called `eraseHelper` which uses recursion and class based pattern matching for nested expression. If the expression doesnt match a `nil` is returned, else apt ULTerm is returned.
  3. A code snippet for  one of the case:
        * `STFalse`
            * returns ` ULAbs(ULAbs(ULVar(0)))`
        * `STTrue`
            * returns ` ULAbs(ULAbs(ULVar(1)))`
    4. here are the Lambda expression for each `STTerm` case
    ```
        true   = λ t → λ f → t
        false  = λ t → λ f → f
        test   = λ l → λ m → λ n → l m n
        zero   = λ s → λ z → z
        suc    = λ n → λ s → λ z → s (n s z)
        iszero = λ m → m (λ x → false) true    
    ```
    5. Since `STAbs` and `STApp` counterparts exists in `ULTerm`, we can just replace the them with `ULAbs` and `ULApp` respectively. Note, we ignore the type parameter in `STAbs`

### Question #3 - Ruby
* Design Specification:
  1. Created methods for each subclass, called `eraseTypes` which returns a `ULTerm` expression.
        * ULTerm is Untypes lamda expression consisting of `ULVar`, `ULAbs`, and `ULApp` terms.
    2. The function uses pattern matching and recursion for nested expression. If the expression doesnt match, an error is thrown ```invalid syntax```, else apt ULTerm is returned.
  3. A code snippet for one of the case:
        * `STTrue`
            ```ruby 
            def eraseTypes
                res = eraseHelper()
                if res.nil?  
                    raise Exception.new "Wrong experession"
                else
                    res
                end
                end
            def eraseHelper
                ULAbs.new(ULAbs.new(ULVar.new(1)))
            end
            ```
    4. The Lambda expression are similar for scala implementation