:- initialization(main).
  main :- read_facts_from_file('/uploads/prolog_test_4.txt'), run_eliminating, !.

run_eliminating :-
    find_all_terminals(Terminals),
    find_all_nonterminals(NonTerminals),
    find_all_rules(Rules),
    write('Grammar: '), nl,
    write_grammar(NonTerminals, Terminals, Rules),
    generate_all_product_nonterminals(X0),
    unique(X0, ProductNonterminals),
    write('Productive nonterminals: '), write_symbols(ProductNonterminals), nl,
    subtract(NonTerminals, ProductNonterminals, UnProductNonterminals),
    write('Unproductive nonterminals: '), write_symbols(UnProductNonterminals), nl,
    ((is_not_empty(ProductNonterminals), find_all_product_rules(X1)); append([], [], X1)),
    unique(X1, ProductRules),
    append(['S'], ProductNonterminals, X2),
    unique(X2, NewProductNonterminals),
    write('New grammar: '), nl,
    write_grammar(NewProductNonterminals, Terminals, ProductRules).

find_all_terminals(Terminals) :- findall(X, terminal(X), Terminals).
find_all_nonterminals(NonTerminals) :- findall(X, non_terminal(X), NonTerminals).
find_all_rules(Rules) :- findall([X, Y], rule(X, Y), Rules).
find_all_product_nonterminals(NonTerminals) :- findall(X, product_nonterminal(X), NonTerminals).
find_all_product_rules(Rules) :- findall([X, Y], is_product_rule(X, Y), Rules).


write_grammar(NonTerminals, Terminals, Rules) :-
    write('Nonterminals: '), write_symbols(NonTerminals), nl,
    write('Terminals: '), write_symbols(Terminals), nl,
    write('Rules: '), nl, write_rules(Rules).

write_symbols([]).
write_symbols([H|T]) :- write(H), write(' '), write_symbols(T).

write_rules([]).
write_rules([H|T]) :- write_rule(H), nl, write_rules(T).

write_rule([H|[T]]) :- 
    write(H), write(' -> '), write_list(T).

write_list([]).
write_list([H|T]) :- write(H), write(' '), write_list(T).

all_product_nonterminals0(NonTerminals) :- 
    findall(NT, is_product_rule0(NT, _), NonTerminals).

is_product_rule0(NT, List) :- 
    rule(NT, List),
    find_all_terminals(TList),
    subset(List, TList),
    add_product_nonterminal(NT).
    
all_product_nonterminals(NonTerminals) :- 
    findall(NT, is_product_rule(NT, _), NonTerminals).
    
is_product_rule(NT, List) :- 
    rule(NT, List),
    find_all_product_nonterminals(PNTList),
    find_all_terminals(TList),
    append(PNTList, TList, PList),
    subset(List, PList),
    (member(NT, PList); (\+ member(NT, PList), add_product_nonterminal(NT))).

all_product_nonterminals_repeater(X, List) :- 
    all_product_nonterminals(Y), 
    unique(Y, UY),
    \+ subset(UY, X), 
    append(X, Y, Z),
    unique(Z, List),
    all_product_nonterminals_repeater(Y, List).

all_product_nonterminals_repeater(_, List) :- 
    all_product_nonterminals(Y),
    unique(Y, UY),
    append(UY, [], List).

subset([], _).
subset([X|Xs], List) :- member(X, List), subset(Xs, List).

unique([], []).
unique([H|T], [H|Result]) :- \+ member(H, T), unique(T, Result).
unique([H|T], Result) :- member(H, T), unique(T, Result).

add_product_nonterminal(X) :- assertz(product_nonterminal(X)).

is_not_empty([_|_]).

assert_facts([]).
assert_facts([Fact|Facts]) :-
    assertz(Fact),
    assert_facts(Facts).
    
generate_all_product_nonterminals(X) :- 
  all_product_nonterminals0(X0),
  ((is_not_empty(X0),
  all_product_nonterminals_repeater(X0, X)); append(X0, [], X)).
  
read_facts_from_file(File) :-
    open(File, read, Stream),
    read_lines(Stream, Facts),
    close(Stream),
    assert_facts(Facts).

read_lines(Stream, []) :- at_end_of_stream(Stream).
read_lines(Stream, [Fact|Facts]) :-
    \+ at_end_of_stream(Stream),
    read(Stream, Fact),
    read_lines(Stream, Facts).