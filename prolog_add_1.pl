list_count([], 0).
list_count([_|T], Count) :- 
    list_count(T, Count1),
    Count is Count1 + 1.

get_list_count :-
    write('Write a list: '),
    read(List),
    list_count(List, Count),
    write(Count), !.
    
main :- get_list_count.