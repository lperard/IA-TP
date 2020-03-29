:- ['avl.pl'].       % predicats pour gerer des arbres bin. de recherche   
:- ['taquin.pl'].    % predicats definissant le systeme a etudier
:- ['aetoile.pl'].

test1 :- %test de la liste des situations vides
    initial_state(Ini),
	% initialisations Pf, Pu et Q
	empty(Q),
	empty(Pf_vide),
	empty(Pu_vide),
    loop_successors_2([], Q, Pu_vide, Pf_vide, Pu, Pf).

test2 :- %test si la situation est déjà dans Q
    initial_state(Ini),
    empty(Q),
    empty(Pf_vide),
	empty(Pu_vide),
    insert(Ini, Q, Q2),
    node_process(Ini,Q2, Pu_vide, Pf_vide, Pu, Pf).

test3 :- %test si la situation est déjà dans Pu et Pf, mais avec un moins bon coût
    initial_state(Ini),
    empty(Q),
    empty(Pf_vide),
	empty(Pu_vide),
    heuristique2(Ini, H1),
    print(H1),
	insert([[H1,H1,0], Ini], Pf_vide, Pf),
	insert([Ini, [H1,H1,0], nil, nil], Pu_vide, Pu),
    H2 is H1+1,
    Ini_Pu = [Ini, [H2,H2,0], nil, nil],
    node_process(Ini_Pu, Q, Pu, Pf, Pu2, Pf2),
    print(Pu2).

test4 :- %test si la situation est déjà dans Pu et Pf, mais avec un moins bon coût
    initial_state(Ini),
    empty(Q),
    empty(Pf_vide),
	empty(Pu_vide),
    heuristique2(Ini, H1),
    print(H1),
	insert([[H1,H1,0], Ini], Pf_vide, Pf),
	insert([Ini, [H1,H1,0], nil, nil], Pu_vide, Pu),
    H2 is H1-1,
    Ini_Pu = [Ini, [H2,H2,0], nil, nil],
    node_process(Ini_Pu, Q, Pu, Pf, Pu2, Pf2),
    print(Pu2).

test5 :-
    initial_state(Ini),
    empty(Q),
    empty(Pf_vide),
	empty(Pu_vide),
    heuristique2(Ini, H1),
    Ini_Pu = [Ini, [H1,H1,0], nil, nil],
    node_process(Ini_Pu, Q, Pu_vide, Pf_vide, Pu, Pf),
    print(Pu).