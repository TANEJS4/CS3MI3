isMixedExpr(constE(_)).
isMixedExpr(plusE(X, Y)):- isMixedExpr(X), isMixedExpr(Y).
isMixedExpr(expE(X, Y)) :- isMixedExpr(X),isMixedExpr(Y). 
isMixedExpr(absE(X)) :- isMixedExpr(X).
isMixedExpr(minusE(X,Y)) :- isMixedExpr(X),isMixedExpr(Y).
isMixedExpr(negE(X)) :- isMixedExpr(X).
isMixedExpr(timesE(X,Y)) :- isMixedExpr(X),isMixedExpr(Y).

isMixedExpr(ff).
isMixedExpr(tt).
isMixedExpr(band(X, Y)) :- isMixedExpr(X) , isMixedExpr(Y).
isMixedExpr(bor(X, Y)) :-  isMixedExpr(X) , isMixedExpr(Y) .
isMixedExpr(bnot(X)) :-  isMixedExpr(X) .

interpretMixedExpr(constE(X),Y) :- X = Y.
interpretMixedExpr(plusE(X,Y),Z) :- interpretMixedExpr(X, Z1) , interpretMixedExpr(Y, Z2),  Z is Z1 + Z2 .
interpretMixedExpr(expE(X,Y),Z) :- interpretMixedExpr(X,Z1) , interpretMixedExpr(Y,Z2), Z is Z1 ** Z2.
interpretMixedExpr(absE(X),Y) :- interpretMixedExpr(X,Z1), Z1 >= 0 -> Y is Z1 ;  Y is -Z1.
interpretMixedExpr(minusE(X,Y),Z) :- interpretMixedExpr(X,Z1) , interpretMixedExpr(Y,Z2), Z is Z1 - Z2.
interpretMixedExpr(negE(X),Y) :- interpretMixedExpr(X,Z1),  Y is -Z1.
interpretMixedExpr(timesE(X,Y),Z) :- interpretMixedExpr(X,Z1) , interpretMixedExpr(Y,Z2), Z is Z1 * Z2.

interpretMixedExpr(band(X,Y),Z) :- interpretMixedExpr(X,Z) , interpretMixedExpr(Y,Z).
interpretMixedExpr(band(ff,Y),Z) :- Z = false.
interpretMixedExpr(band(X,ff),Z) :- Z = false.
interpretMixedExpr(band(tt,tt),Z) :- Z = true.

interpretMixedExpr(bor(X,Y),Z) :- interpretMixedExpr(X,Z) ; interpretMixedExpr(Y,Z).
interpretMixedExpr(bnot(X),Z) :- (\+ interpretMixedExpr(X,Z)).
interpretMixedExpr(tt,Y) :- true = Y.
interpretMixedExpr(ff,Y) :- fail = Y.