find_element_count(_,[],0).
find_element_count(X,[Element|Rest],Count):- 
    X = Element -> find_element_count(X,Rest,CountRest), 
    Count is 1 + CountRest; find_element_count(X,Rest,Count).

find_even_elements(List,EvenList) :-
	include(is_even_count(List),List,EvenList).

is_even_count(List,X) :- 
    find_element_count(X,List,Count), 
    Count mod 2 =:= 0.

filter_list(List1,List2,List) :-
    find_even_elements(List2,EvenList),
    subtract(List1,EvenList,List).

get_filtered_list :-
	write('Write the first list: '),
    read(List1),
    write('Write the second list: '),
    read(List2),
    filter_list(List1,List2,List),
    write(List).