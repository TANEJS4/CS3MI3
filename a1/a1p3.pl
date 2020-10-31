
isVarExpr(constE(X)) :-  is_of_type(integer, X).
isVarExpr(plusE(X, Y)):- isVarExpr(X), isVarExpr(Y).
isVarExpr(expE(X, Y)) :- isVarExpr(X),isVarExpr(Y). 
isVarExpr(absE(X)) :- isVarExpr(X).
isVarExpr(minusE(X,Y)) :- isVarExpr(X),isVarExpr(Y).
isVarExpr(timesE,Y)) :- isVarExpr(X),isVarExpr(Y).
isVarExpr(var(X)):- is_of_type(atom,X).
isVarExpr(negE(X)):- is_of_type(integer,X).
isVarExpr(subst(E, X, Y)) :- isVarExpr(E), is_of_type(atom, X), isVarExpr(Y).

interpretVarExpr(constE(X),Y) :- X = Y.
interpretVarExpr(plusE(X,Y),Z) :- interpretVarExpr(X, Z1) , interpretVarExpr(Y, Z2), Z is Z1 + Z2 .
interpretVarExpr(minusE(X,Y),Z) :- interpretVarExpr(X, Z1) , interpretVarExpr(Y, Z2), Z is Z1 - Z2 .
interpretVarExpr(expE(X,Y),Z) :- interpretVarExpr(X, Z1) , interpretVarExpr(Y, Z2), Z is Z1 ** Z2 .
interpretVarExpr(timesE(X,Y),Z) :- interpretVarExpr(X, Z1) , interpretVarExpr(Y, Z2), Z is Z1 * Z2 .
interpretVarExpr(absE(X),Z) :- interpretVarExpr(X,Z1), Z1 >= 0 -> Z is Z1 ;   Z is -Z1.
interpretVarExpr(negE(X),Z) :- interpretVarExpr(X,Z1),  Z is -Z1.
interpretVarExpr(subst(E, S, V),Z) :- helperVarExpr(E, S , V, Z1), interpretVarExpr(Z1,Z2), Z = Z2.

helperVarExpr(constE(X),S, V, Z) :- Z = constE(X).
helperVarExpr(var(X),S, V, Z ):- X == S ->  Z = V; Z = var(X).
helperVarExpr(plusE(X, Y),S, V, Z) :- helperVarExpr(X, S, V, Z1), helperVarExpr(Y,S, V, Z2), Z = plusE(Z1, Z2).
helperVarExpr(absE(X),S, V, Z) :- helperVarExpr(X, S, V, Z1), Z = absE(Z1).
helperVarExpr(negE(X),S, V, Z) :- helperVarExpr(X, S, V, Z1), Z = negE(Z1).
helperVarExpr(minusE(X, Y),S, V, Z) :- (helperVarExpr(X, S, V, Z1), helperVarExpr(Y,S, V, Z2), Z = minusE(Z1, Z2).
helperVarExpr(timesE(X, Y),S, V, Z) :- (helperVarExpr(X, S, V, Z1), helperVarExpr(Y,S, V, Z2), Z = timesE(Z1, Z2).
helperVarExpr(expE(X, Y),S, V, Z) :- helperVarExpr(X, S, V, Z1), helperVarExpr(Y,S, V, Z2, Z = expE(Z1, Z2).
helperVarExpr(subst(E, ST, VT),S, V, Z) :- helperVarExpr(E, ST, VT, Z1), Z = subst(Z1, S, V) .