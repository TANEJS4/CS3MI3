# CS 3MI3 - Assignment 1
##### Shivam Taneja, 400160537

### Part 1 
* Language: Scala 
* Design:
    * Used unary operators to perform arithmetic operations on Integers. 
    * Created a trait `Expr` and and its case classes for the input expression.

### Part 2 
* Language: Prolog 
* Design:
    * Created a recursive function `isExpr` to determine if the input is an expression.
    * `interpretExpr` uses unary operators to determine the value of the input expression and compare it with the value passed in second parameter , e.g. `interpretExpr(plusE(X,Y), Z)` computed to ``X + Y == C``.

###  Part 3 
* Language: _Scala_ and _Prolog_ 
* Design - Scala: 
    * I used `LinkedHashMap` to save the state during each recursive call which then replaces the symbol (Variable in expression) with the linked value to compute the expression. 
    * The reason I did not go with `HashMap` was because I did not want to bother myself with the complexity of having a return type of `Option[Either[A, B]]` meaning the helper function would return in `Some(Left(X)) | Some(Right(Y)) | None` and I would have to convert that to Int.  
* Design - Prolog: 
    * For Prolog, I found another way to solve the same question without using `HashMaps`. 
    * I used a pattern matching and recursive calls to my helper functions to solve this problem.
    * I used `is_of_type(atom, X)` to make sure the expression is sound.

###  Part 4 
* Language: _Scala_ and _Prolog_ 
* Design - Scala: 
    * Similar to part 3 - scala, but here I added 2 `case objects (TT and FF)` and case classes for them. 
    * `interpretMixedExpr(expr)` has a return type of `Option[Either[Int, Boolean]]` i.e.  the method can return in `Some(Left(X)) | Some(Right(Y)) | None`. 
    * For robustness, the method returns `None` if integer and boolean expressions are in the same expression.
        *  For example,for expression `Plus(FF, Const(0))`, the function will return None.
    
* Design - Prolog: 
    * I assumed that all input expressions are valid - the script does not check if the input expression is valid. 
