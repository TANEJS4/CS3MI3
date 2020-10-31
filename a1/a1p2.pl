isExpr(constE(_)).
isExpr(plusE(X, Y)):- isExpr(X), isExpr(Y).
isExpr(expE(X, Y)) :- isExpr(X),isExpr(Y). 
isExpr(absE(X)) :- isExpr(X).
isExpr(minusE(X,Y)) :- isExpr(X),isExpr(Y).
isExpr(timesE(X,Y)) :- isExpr(X),isExpr(Y).
isExpr(negE(X)) :- isExpr(X).


interpretExpr(constE(X),Y) :- X = Y.
interpretExpr(plusE(X,Y),Z) :-   interpretExpr(X, Z1) ,   interpretExpr(Y, Z2),  Z is Z1 + Z2 .
interpretExpr(expE(X,Y),Z) :-   interpretExpr(X,Z1) ,   interpretExpr(Y,Z2), Z is Z1 ** Z2.
interpretExpr(absE(X),Y) :-   interpretExpr(X,Z1), Z1 >= 0 -> Y is Z1 ;   Y is -Z1.
interpretExpr(minusE(X,Y),Z) :-   interpretExpr(X,Z1) ,   interpretExpr(Y,Z2),  Z is Z1 - Z2.
interpretExpr(negE(X),Y) :-   interpretExpr(X,Z1),  Y is -Z1.
interpretExpr(timesE(X,Y),Z) :-   interpretExpr(X,Z1) ,   interpretExpr(Y,Z2),  Z is Z1 * Z2.
