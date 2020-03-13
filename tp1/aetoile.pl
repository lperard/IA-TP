%*******************************************************************************
%                                    AETOILE
%*******************************************************************************


%Rappels sur l'algorithme
% 
%- structures de donnees principales = 2 ensembles : P (etat pendants) et Q (etats clos)
%- P est dedouble en 2 arbres binaires de recherche equilibres (AVL) : Pf et Pu
% 
%   Pf est l'ensemble des etats pendants (pending states), ordonnes selon
%   f croissante (h croissante en cas d'egalite de f). Il permet de trouver
%   rapidement le prochain etat a developper (celui qui a f(U) minimum).
%   
%   Pu est le meme ensemble mais ordonne lexicographiquement (selon la donnee de
%   l'etat). Il permet de retrouver facilement n'importe quel etat pendant
%
%   On gere les 2 ensembles de fa�on synchronisee : chaque fois qu'on modifie
%   (ajout ou retrait d'un etat dans Pf) on fait la meme chose dans Pu.
%
%   Q est l'ensemble des etats deja developpes. Comme Pu, il permet de retrouver
%   facilement un etat par la donnee de sa situation.
%   Q est modelise par un seul arbre binaire de recherche equilibre.
%
%Predicat principal de l'algorithme :
%
%   aetoile(Pf,Pu,Q)
%
%   - reussit si Pf est vide ou bien contient un etat minimum terminal
%   - sinon on prend un etat minimum U, on genere chaque successeur S et les valeurs g(S) et h(S)
%	 et pour chacun
%		si S appartient a Q, on l'oublie
%		si S appartient a Ps (etat deja rencontre), on compare
%			g(S)+h(S) avec la valeur deja calculee pour f(S)
%			si g(S)+h(S) < f(S) on reclasse S dans Pf avec les nouvelles valeurs
%				g et f 
%			sinon on ne touche pas a Pf
%		si S est entierement nouveau on l'insere dans Pf et dans Ps
%	- appelle recursivement etoile avec les nouvelles valeurs NewPF, NewPs, NewQs
%
%

%*******************************************************************************

:- ['avl.pl'].       % predicats pour gerer des arbres bin. de recherche   
:- ['taquin.pl'].    % predicats definissant le systeme a etudier

%*******************************************************************************

affiche_solution([[F,H,G], U]):-
	print(F),
	print(H),
	print(G),
	print(U).


main:-
	% initialisations Pf, Pu et Q 
	initial_state(Ini),
	heuristique1(Ini, H1),
	Pf = [[H1, H1, 0], Ini],
	Pu = [Ini, [H1, H1, 0], nil, nil],
	Q = [],
	% lancement de Aetoile
	aetoile(Pf,Pu,Q).



%*******************************************************************************
expand(U, G, R):-
	G1 is G+1,
	findall([U2, [F, H, G1],U, A],
		(rule(A, 1, U, U2), heuristique1(U2, H), F is H + G1),
		R).

loop_successors([],_,_,_,_,_).


loop_successors([Head|Tail], Q, Pu, Pf, Pu2, Pf2):-
	Head = [U, [F,H,G], Pere, A],
	HPf = [[F,H,G], U],
	(%If
	belongs(Head, Q) ->
		%Then on oublie cet état et on passe à la suite
		loop_successors(Tail,Q, Pu, Pf, Pu2, Pf2)
		;
	%Else
		(%If
		Xtest = [U,[Fp,Hp,Gp],Perep,Ap],
		belongs(Xtest,Pu) ->
			%Then on garde le meilleur
			(F < Fp -> % Xtest est meilleur, on l'insere dans Pu et Pf, et on retire l'ancien
				suppress(Xtest, Pu,Pu2),
				insert(Head, Pu, Pu2),
				HPfTemp = [[Fp,Hp,Gp], U],
				suppress(HPfTemp, Pf,Pf2),
				insert(HPf, Pf, Pf2),
				loop_successors(Tail, Q, Pu2, Pf2, Pu3, Pf3)
				)
		;
		%Else
		insert(Head, Pu, Pu2),
		insert(HPf, Pf, Pf2),
		loop_successors(Tail,Q, Pu2, Pf2, Pu3, Pf3)
		)
	).


aetoile([],[], _):-
	print("Pas de solution, l_etat final n_est pas atteignable").


aetoile(Pf, Pu, Qs) :-
	final_state(Final),
	print(Pf),
	suppress_min(Umin, Pf, Pf2_inutile), %a checker
	print(Umin),
	Umin = [[Fu, Hu, Gu], U],
	(%If
	print('Test'),
	U = Final ->
	%Then
	affiche_solution(Umin)
	;
	%Else
	suppress([[F,H,G],U],Pf,Pf2),
	suppress([U, [Fu2, Hu2, Gu2], Upere, Au], Pu, Pu2),
	expand(U,G,R),
	loop_successors(R, Q, Pu2, Pf2, Pf3, Ps3),
	aetoile(Pf3, Pu3, Ps3)).