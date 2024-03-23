:- initialization(main).
  main :- read_facts_from_file('/uploads/prolog_test_3.txt').
  
word_exists(K) :- 
    word_k_exists(K, Word),
    print_word(Word), !.

word_k_exists(K, Word) :-
    initial_state(I),
    final_state(Final),
    automata_path(I, K, Final, Word).

automata_path(State, K, Final, [S|Word]) :-
    K > 0,
    K1 is K - 1,
    transition(State, S, State1),
    \+ eps_sign(S),
    automata_path(State1, K1, Final, Word).
    
automata_path(State, K, Final, [S|Word]) :-
    K > 0,
    K1 is K,
    transition(State, S, State1),
    State \== State1,
    eps_sign(S),
    automata_path(State1, K1, Final, Word).
  
automata_path(Final, 0, Final, []).

print_word([]) :- !.
print_word([H|T]) :-
    eps_sign(H),
    print_word(T).
print_word([H|T]) :-
    \+ eps_sign(H),
    write(H),
    print_word(T).

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

assert_facts([]).
assert_facts([Fact|Facts]) :-
    assertz(Fact),
    assert_facts(Facts).