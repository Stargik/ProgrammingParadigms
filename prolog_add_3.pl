list_elements(0, []).
list_elements(N, List) :- 
    N2 is N*2,
    N0 is N-1,
    list_elements(N0, List1),
    append1(List1, [N2], List).

append1([], List, List).
append1([H|T1], List2, [H|R2]) :- 
    append1(T1, List2, R2).

get_list_elements :-
    write('Write n: '),
    read(N),
    list_elements(N, List),
    write(List), !.
    
main :- get_list_elements.