% Part 1

hasDivisorLessThanOrEqualTo(_,1) :- !, false.
hasDivisorLessThanOrEqualTo(X,Y) :- 0 is X mod Y, !.
hasDivisorLessThanOrEqualTo(X,Y) :- Z is Y - 1, hasDivisorLessThanOrEqualTo(X,Z).

isPrime(2) :- !,true.
isPrime(X) :- X < 2 ;  0 is X mod 2 -> !, false ;  P is integer(sqrt(X)) , not(hasDivisorLessThanOrEqualTo(X,P)).

% part 2

isDigitList(_,[]) :- false.
isDigitList(X,[X]) :- X < 10 -> X is X , !.
isDigitList(X, [H|T]) :-  append([H], T, L),P is X div 10 , isDigitList(P, L1) , Z is (X mod 10), append([Z], L1, L).

dropLast([_],[]).
dropLast([H|T],[H|T2]) :- reverse(T, [_Z|RL]),reverse(RL, T3), T3 = T2. 
dropLast([H|T], X) :- reverse(T, [_Z|RL]),reverse(RL, A1), X is append([H],A1).

% part 3
isPalindrome([]) :- !, true.
isPalindrome([_]) :- !, true.
isPalindrome([H|T]) :- last(T,H) -> dropLast(T,X),isPalindrome(X); !, false.

% part 4

primePalindrome(X) :- X < 10 -> isPrime(X).
primePalindrome(X) :- isPrime(X) -> isDigitList(X,L), isPalindrome(L) -> !, true; !, false.

%part 5