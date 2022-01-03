:- consult(circuitos).
:- consult('../view/view_menu').

connect(Zona,X,Y,C):- aresta(Zona,X,Y,C).
connect(Zona,X,Y,C):- aresta(Zona,Y,X,C).

%-----------------------------------------

emProfundidade(Zona,[H],DestinoFinal, Acc, AccCost, NewCost,R):-
    dfs(Zona, H, DestinoFinal, CDist,L),
    NewCost is CDist + AccCost,
    append(Acc, L, R),
    printOnePath(L),
    write("Custo da travessia -> "),writeln(CDist).


emProfundidade(Zona, [H, X|T],DestinoFinal, Acc, AccCost,Cost, Cam) :-
    dfs(Zona, H, X, CD, L),
    NewAccCost is CD + AccCost,
    subtract(T,L,Result),
    append([X],Result,NewDest),
    append(Acc, L, NewL),
    printOnePath(L), 
    write("Custo da travessia -> "),writeln(CD),
    emProfundidade(Zona, NewDest,DestinoFinal, NewL, NewAccCost,Cost, Cam).

%-----------------------------------------
emLargura(Zona,[H],DestinoFinal, Acc, AccCost, NewCost,R):-
    bfs(Zona, H, DestinoFinal,L),
    calculaCustoDistancia(Zona,L,CDist),
    NewCost is CDist + AccCost,
    append(Acc, L, R),
    printOnePath(L),
    write("Custo da travessia -> "),writeln(CDist).


emLargura(Zona, [H, X|T],DestinoFinal, Acc, AccCost,Cost, Cam) :-
    bfs(Zona, H, X, L),
    calculaCustoDistancia(Zona,L,CD),
    NewAccCost is CD + AccCost,
    subtract(T,L,Result),
    append([X],Result,NewDest),
    append(Acc, L, NewL),
    printOnePath(L), 
    write("Custo da travessia -> "),writeln(CD),
    emLargura(Zona, NewDest,DestinoFinal, NewL, NewAccCost,Cost, Cam).

%-----------------------------------------
embilp(Zona,[H],DestinoFinal, Acc, R):-
    bilp(Zona, H, DestinoFinal, 0, L),
    append(Acc, L, R),
    printOnePath(L),
    calculaCustoDistancia(Zona,L,CD),
    write("Custo da travessia -> "),writeln(CD).

embilp(Zona, [H, X|T],DestinoFinal, Acc, Cam) :-     
    bilp(Zona, H, X, 0, L),
    subtract(T,L,Result),
    append([X],Result,NewDest),
    append(Acc, L, NewL),
    printOnePath(L),
    calculaCustoDistancia(Zona,L,CD),
    write("Custo da travessia -> "),writeln(CD),
    embilp(Zona, NewDest,DestinoFinal, NewL, Cam).


%-----------------------------------------

greedy(Zona,Pts,Destino,Velocidade, Modo, Cam/Cust) :-
    (Modo == 1 -> 
        emgulosa_distancia(Zona,Pts,Destino, []/0, Cam/Cust)
    );
    (Modo == 2 -> 
        emgulosa_tempo(Zona,Velocidade, Pts,Destino,[]/0,Cam/Cust)
    ).

emgulosa_distancia(Zona,[H],DestinoFinal,Acc/CustoAcc,R/CR):-
    resolve_gulosa_distancia(Zona,H,DestinoFinal,Caminho/Custo),
    printOnePath(Caminho),
    append(Acc,Caminho,R),
    CR is CustoAcc + Custo,
    write("\033\[32m > Custo: "),write(CR), writeln("\033\[0m").

emgulosa_distancia(Zona,[H,X|T],DestinoFinal,Acc/CustoAcc,R/CR):-
    resolve_gulosa_distancia(Zona,H,X,Caminho/Custo),
    subtract(T,Caminho,NovoDestinos),
    printOnePath(Caminho),
    append(Acc,Caminho,NovoAcc),
    write("\033\[32m > Custo: "),write(Custo), writeln("\033\[0m"),
    NovoCusto is CustoAcc + Custo,
    emgulosa_distancia(Zona,[X|NovoDestinos],DestinoFinal,NovoAcc/NovoCusto,R/CR).

emgulosa_tempo(Zona,Velocidade,[H],DestinoFinal,Acc/CustoAcc,R/CR):-
    resolve_gulosa_tempo(Velocidade,Zona,H,DestinoFinal,Caminho/Custo),
    printOnePath(Caminho),
    append(Acc,Caminho,R),
    CR is CustoAcc + Custo,
    write("\033\[32m > Custo: "),write(CR), writeln("\033\[0m").

emgulosa_tempo(Zona,Velocidade,[H,X|T],DestinoFinal,Acc/CustoAcc,R/CR):-
    resolve_gulosa_tempo(Velocidade,Zona,H,X,Caminho/Custo),
    subtract(T,Caminho,NovoDestinos),
    printOnePath(Caminho),
    append(Acc,Caminho,NovoAcc),
    write("\033\[32m > Custo: "),write(Custo), writeln("\033\[0m"),
    NovoCusto is CustoAcc + Custo,
    emgulosa_tempo(Zona,Velocidade,[X|NovoDestinos],DestinoFinal,NovoAcc/NovoCusto,R/CR).

%-----------------------------------------
%em_a_estrela("Ferreiros",["Centro de distribuições","Rua 11","Rua 10","Rua 18"],"Centro de distribuições",[]/0,R/CR).

em_a_estrela(Zona,[H],DestinoFinal,Acc/CustoAcc,R/CR):-
    resolve_aestrela(Zona,H,DestinoFinal,Caminho/Custo),
    printOnePath(Caminho),
    append(Acc,Caminho,R),
    CR is CustoAcc + Custo,
    write("\033\[32m > Custo: "),write(CR), writeln("\033\[0m").

em_a_estrela(Zona,[H,X|T],DestinoFinal,Acc/CustoAcc,R/CR):-
    resolve_aestrela(Zona,H,X,Caminho/Custo),
    subtract(T,Caminho,NovoDestinos),
    printOnePath(Caminho),
    append(Acc,Caminho,NovoAcc),
    write("\033\[32m > Custo: "),write(Custo), writeln("\033\[0m"),
    NovoCusto is CustoAcc + Custo,
    em_a_estrela(Zona,[X|NovoDestinos],DestinoFinal,NovoAcc/NovoCusto,R/CR).




%------ Pesquisa em profundidade ---------

dfs(Zona, Orig, Dest, Distancia,Cam) :-
    dfs2(Zona, Orig, Dest, [Orig], 0, Distancia, Cam). %condicao final: nó actual = destino
dfs2(_,Dest,Dest,LA,CD,CD,Cam):- reverse(LA,Cam). %caminho actual esta invertido
dfs2(Zona, Act, Dest, LA,AccCD,CD, Cam) :-
    connect(Zona, Act, X,Cost), %testar ligacao entre ponto actual e um qualquer X
    NewAcc is AccCD + Cost,
    \+ member(X, LA), %testar nao circularidade p/evitar nós ja visitados
    dfs2(Zona, X, Dest, [X|LA], NewAcc, CD, Cam). %chamada recursiva

%------ Pesquisa em largura ---------

bfs(Zona, Orig, Dest, Cam) :-
    bfs2(Zona, Dest, [[Orig]], Cam).
bfs2(_,Dest,[[Dest|T]|_],Cam):- reverse([Dest|T],Cam). %o caminho aparece pela ordem inversa
bfs2(Zona, Dest, [LA|Outros], Cam) :-
    LA=[Act|_],
    findall([X|LA],
            ( Dest\==Act,
              connect(Zona, Act, X,_),
              \+ member(X, LA)
            ),
            Novos),
    append(Outros, Novos, Todos),
    bfs2(Zona, Dest, Todos, Cam).

%------Busca Iterativa Limitada em Profundidade -----
bilp(Zona, Orig, Dest, Size, Cam) :- 
    (bilpAux(Zona, Orig, Dest, Size, Cam) ->
        !;
        NewSize is Size + 1,
        bilp(Zona, Orig, Dest, NewSize, Cam)
    ).

bilpAux(Zona, Orig, Dest, SizeInicial, Cam) :-
    dfs(Zona, Orig, Dest, _, Cam),
    length(Cam, S),
    S =:= SizeInicial.



%------Pesquisa gulosa-----

resolve_gulosa_distancia(Zona,Origem,Destino,CaminhoDistancia/CustoDist) :-
    vertice(Zona,Origem,X),
    vertice(Zona,Destino,Y),
    estima_distancia(X, Y,Est),
    agulosa_distancia_g(Zona,[[Origem]/0/Est], Destino, InvCaminho/CustoDist/_,Y),
    inverso(InvCaminho, CaminhoDistancia).

agulosa_distancia_g(_,Caminhos, Destino,Caminho,_) :-
    obtem_melhor_distancia_g(Caminhos, Caminho),
    Caminho = [Destino|_]/_/_.
    

agulosa_distancia_g(Zona,Caminhos, Destino,SolucaoCaminho,CoordenadasDestino) :-
    obtem_melhor_distancia_g(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
    expande_agulosa_distancia_g(Zona,MelhorCaminho, ExpCaminhos,CoordenadasDestino),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    agulosa_distancia_g(Zona,NovoCaminhos, Destino,SolucaoCaminho,CoordenadasDestino).  

obtem_melhor_distancia_g([Caminho], Caminho) :- !.
obtem_melhor_distancia_g([Caminho1/Custo1/Est1,_/_/Est2|Caminhos], MelhorCaminho) :-
    Est1 =< Est2, !,
    obtem_melhor_distancia_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 
obtem_melhor_distancia_g([_|Caminhos], MelhorCaminho) :- 
    obtem_melhor_distancia_g(Caminhos, MelhorCaminho).


expande_agulosa_distancia_g(Zona,Caminho, ExpCaminhos,CoordenadasDestino) :-
    findall(NovoCaminho, adjacente_distancia(Zona,Caminho,NovoCaminho,CoordenadasDestino), ExpCaminhos).


%-------------------------------------    
resolve_gulosa_tempo(Velocidade, Zona,Origem,Destino,CaminhoDistancia/CustoDist) :-
    vertice(Zona,Origem,X),
    vertice(Zona,Destino,Y),
    estima_tempo(Velocidade, X, Y,Est),
    agulosa_tempo_g(Zona,Velocidade,[[Origem]/0/Est], Destino, InvCaminho/CustoDist/_,Y),
    inverso(InvCaminho, CaminhoDistancia).

agulosa_tempo_g(_,_,Caminhos, Destino,Caminho,_) :-
    obtem_melhor_tempo_g(Caminhos, Caminho),
    Caminho = [Destino|_]/_/_.
    

agulosa_tempo_g(Zona,Velocidade, Caminhos, Destino,SolucaoCaminho,CoordenadasDestino) :-
    obtem_melhor_tempo_g(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
    expande_agulosa_tempo_g(Zona,Velocidade, MelhorCaminho, ExpCaminhos,CoordenadasDestino),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    agulosa_tempo_g(Zona,Velocidade, NovoCaminhos, Destino,SolucaoCaminho,CoordenadasDestino).  

obtem_melhor_tempo_g([Caminho], Caminho) :- !.
obtem_melhor_tempo_g([Caminho1/Custo1/Est1,_/_/Est2|Caminhos], MelhorCaminho) :-
    Est1 =< Est2, !,
    obtem_melhor_tempo_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 
obtem_melhor_tempo_g([_|Caminhos], MelhorCaminho) :- 
    obtem_melhor_tempo_g(Caminhos, MelhorCaminho).
    

expande_agulosa_tempo_g(Zona,Velocidade,Caminho, ExpCaminhos,CoordenadasDestino) :-
    findall(NovoCaminho, adjacente_tempo(Zona,Velocidade,Caminho,NovoCaminho,CoordenadasDestino), ExpCaminhos).



%------Pesquisa A*-----
 
%resolve_aestrela("Semelhe","Centro de distribuições","Rua 13",R/CR). 

resolve_aestrela(Zona,Origem,Destino,CaminhoDistancia/CustoDist) :-
    vertice(Zona,Origem,X),
    vertice(Zona,Destino,Y),
    estima_distancia(X, Y,Est),
    aestrela_distancia(Zona,[[Origem]/0/Est],Destino, InvCaminho/CustoDist/_,Y),
    inverso(InvCaminho, CaminhoDistancia).


aestrela_distancia(_,Caminhos,Destino, Caminho,_) :-
    obtem_melhor_distancia(Caminhos, Caminho),
    Caminho = [Destino|_]/_/_.

aestrela_distancia(Zona,Caminhos,Destino, SolucaoCaminho,CoordenadasDestino) :-
    obtem_melhor_distancia(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
    expande_aestrela_distancia(Zona,MelhorCaminho, ExpCaminhos,CoordenadasDestino),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela_distancia(Zona,NovoCaminhos,Destino, SolucaoCaminho,CoordenadasDestino).   

obtem_melhor_distancia([Caminho], Caminho) :- !.
obtem_melhor_distancia([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
    Custo1 + Est1 =< Custo2 + Est2, !,
    obtem_melhor_distancia([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 
obtem_melhor_distancia([_|Caminhos], MelhorCaminho) :- 
    obtem_melhor_distancia(Caminhos, MelhorCaminho).
    

expande_aestrela_distancia(Zona,Caminho, ExpCaminhos,CoordenadasDestino) :-
    findall(NovoCaminho, adjacente_distancia(Zona,Caminho,NovoCaminho,CoordenadasDestino), ExpCaminhos).
    

%------ Predicados auxiliares ---------
% Devolve todos os pontos de entrega de um estafeta
getTodosPontosEntrega(estafeta(_, _, _, _, _, LE, _), R) :-
    extract(LE, [], Aux),
    remove_dups(Aux, R).

extract([], R, R).
extract([pedido(_, _, _, Rua, _, _, _, _)|T], Acc, R) :-
    extract(T, [Rua|Acc], R).

% Remove os elementos duplicados de uma lista
remove_dups([], []).
remove_dups([H|T], R) :-
    member(H, T), !,
    remove_dups(T, R).
remove_dups([H|T], [H|R]) :-
    remove_dups(T, R).


remove_instancias_iguais([],R,R).

remove_instancias_iguais([H|L],XS,NewDest):-
    write("Pontos a retirar : "),writeln([H|L]),
    write("Lista original : "),writeln(XS),
    delete(XS,H,New),
    write("Lista Modificada : "),
    writeln(New),
    remove_instancias_iguais(L,New,NewDest).


%Inverte a lista Xs
inverso(Xs, Ys) :-
    inverso(Xs, [], Ys).
inverso([], Xs, Xs).
inverso([X|Xs], Ys, Zs) :-
    inverso(Xs, [X|Ys], Zs).


seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).

estima_distancia(X1/Y1,X2/Y2,Est) :- 
    Aux is (X2 - X1)^2,
    Aux2 is (Y2 - Y1)^2,
    Aux3 is Aux+Aux2,
    Est is sqrt(Aux3).

estima_tempo(Vel, X1/Y1, X2/Y2, Est) :- 
    Aux is (X2 - X1)^2,
    Aux2 is (Y2 - Y1)^2,
    Aux3 is Aux+Aux2,
    Est is sqrt(Aux3)/Vel.

adjacente_distancia(Zona,[Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstDist,CoordenadasDestino) :-
    connect(Zona,Nodo,ProxNodo,PassoCustoDist),
    \+ member(ProxNodo,Caminho),
    NovoCusto is Custo + PassoCustoDist,
    vertice(Zona,ProxNodo,X),
    estima_distancia(X,CoordenadasDestino,EstDist).

adjacente_tempo(Zona,Velocidade, [Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstDist,CoordenadasDestino) :-
    connect(Zona,Nodo,ProxNodo,PassoCustoDist),
    \+ member(ProxNodo,Caminho),
    NovoCusto is Custo + PassoCustoDist/Velocidade,
    vertice(Zona,ProxNodo,X),
    estima_tempo(Velocidade,X,CoordenadasDestino,EstDist).

calculaCustoDistancia(_,[],_).
calculaCustoDistancia(Zona, [Nodo|T], Cust) :-
    calculaCustoDistancia2(Zona,[Nodo|T], 0, Cust).

calculaCustoDistancia2(_,[_],R,R).
calculaCustoDistancia2(Zona,[Nodo,Nodo2|T], Acc, Cust) :-
    connect(Zona,Nodo,Nodo2,CD),
    NewAcc is CD + Acc,
    calculaCustoDistancia2(Zona,[Nodo2|T], NewAcc, Cust).
