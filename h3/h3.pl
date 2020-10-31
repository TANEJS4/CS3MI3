flatten(leaf(X), L):- append([], [X], L), !.
flatten(branch(X, Y), L):- flatten(X, L1), flatten(Y, L2), append(L1, [], Z), append(Z, L2, L), !.

flatten(empty, X):- append([], [], X), !.
flatten(X, L):- append([], [X], L).
flatten(node(X,Y,Z), L):- flatten(X, L1), flatten(Y, L2), flatten(Z, L3), append(L1, L2, L4) ,append(L4, L3, L).