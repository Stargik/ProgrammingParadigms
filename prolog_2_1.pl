has_divider(X, Y) :- Y1 is Y + 1, Y1 < X, has_divider(X, Y1), !.
has_divider(X, Y) :- X mod Y =:= 0, Y < X.
is_prime(X) :- X > 1, X1 is 2, \+has_divider(X, X1).

get_n_primes(1, PrimesTail, Primes) :- Primes = PrimesTail, !.
get_n_primes(N, PrimesTail, Primes) :-
    is_prime(N), !,
    N1 is N - 1,
    get_n_primes(N1, [N | PrimesTail], Primes).
get_n_primes(N, PrimesTail, Primes) :-
    N1 is N - 1,
    get_n_primes(N1, PrimesTail, Primes).
get_n_primes(N, Primes) :- get_n_primes(N, [], Primes).

split_list_helper([], _, _, _, []).
split_list_helper(List, SplitLen, _, _, [Sublist]) :-
    length(List, Len),
    Len < SplitLen,
    Len > 0,
    append([], Sublist, List), !.
split_list_helper(List, SplitLen, N, Primes, [Sublist|Sublists]) :- 
    length(Sublist, Len),
    append(Rest, Sublist, List),
    Len >= SplitLen,
    N1 is N + 1,
    nth0(N1, Primes, P),
    split_list_helper(Rest, P, N1, Primes, Sublists), !.
generate_lists(List, SplitLen, N, Primes, Sublists) :- 
    split_list_helper(List, SplitLen, N, Primes, SublistsReversed),
    reverse(SublistsReversed, Sublists), !.
generate_lists(List, Sublists) :-
    nth0(0, Primes, P),
    length(List, N),
    get_n_primes(N, Primes),
    generate_lists(List, P, 0, Primes, Sublists).

generate_splitted_lists :- 
    write('Write a list: '),
    read(List),
    generate_lists(List, Sublists),
    write(Sublists).