min_elements([], _, []).
min_elements([Head|Tail], List, [Head|Elements]) :- 
    member(Head, List), min_elements(Tail, List, Elements), !.
min_elements([_|Tail], List, Elements) :- min_elements(Tail, List, Elements).

min_n_elements(List, N, Elements) :- 
    sort(0, @=<, List, SortedList),
    length(MinElements, N),
    prefix(MinElements, SortedList),
    min_elements(List, MinElements, Elements).

find_min_n_elements :- 
    write('Write a list: '),
    read(List),
    write('Write N: '),
    read(N),
    min_n_elements(List, N, Elements),
    write(Elements).