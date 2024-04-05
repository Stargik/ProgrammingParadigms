object_is('HTC Wildfire E2') :- 
    it_is('HTC'),
    not(posit('Allow expensive model')),
    (posit('Green'); posit('Silver')).
object_is('HTC U12+') :- 
    it_is('HTC'),
    (posit('Black'); posit('Blue')).
object_is('HTC Desire 20 Pro') :- 
    it_is('HTC'),
    not(posit('Allow expensive model')),
    (posit('Silver'); posit('Blue')).
object_is('Honor 9X') :- 
    it_is('Honor'),
    not(posit('Allow expensive model')),
    (posit('Black'); posit('Blue')).
object_is('Honor 20 Pro') :- 
    it_is('Honor'),
    (posit('Silver'); posit('Red')).
object_is('Huawei P30 Lite') :- 
    it_is('Huawei'),
    not(posit('Allow expensive model')),
    (posit('White'); posit('Black')).
object_is('Huawei P40 Pro') :- 
    it_is('Huawei'),
    (posit('Green'); posit('Black')).
object_is('Huawei Mate 30 Pro') :- 
    it_is('Huawei'),
    (posit('White'); posit('Red')).
it_is('HTC') :- posit('Allow brand from Taiwan').
it_is('Huawei') :- posit('Allow brand from China').
it_is('Honor') :- it_is('Huawei'), posit('Allow sub-brand of the main brand').

do_consulting :- clear_facts, object_is(X), !, nl, write('Our recommendation: '), write(X), write('.').
do_consulting :- nl, write('Sorry, we have no offer for you.').

clear_facts :- retractall(dposit(_)), fail.
clear_facts :- retractall(dnegat(_)), fail.
clear_facts.

posit(X) :- dposit(X), !.
posit(X) :- not(dnegat(X)), ask(X).

ask(X) :- nl, write('Are you considering an option that meets this requirement: "'), write(X), write('" (y/n)? - '), readln(Rep), remember(X,Rep).

remember(X,[y]) :- assertz(dposit(X)).
remember(X,[n]) :- assertz(dnegat(X)), fail.

:- initialization(main).
main :- do_consulting.