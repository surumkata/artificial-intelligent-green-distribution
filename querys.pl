%Para poder inserir e remover
:- (dynamic estafeta/7). 
:- (dynamic meio_transporte/4). 
:- (dynamic pedido/8). 

%-----------------------------Ficheiros auxiliares ----------------------------
:- consult(base_de_conhecimento).
:- consult(invariantes).
%------------------------------------------------------------------------------%
%---------------------------------- Listagens  --------------------------------%
%------------------------------------------------------------------------------%

% (1) Estafeta -----------------------------------------------------------------

% Procura todos os estafetas por -----------------------------------------------

/*... um certo nome */
estafeta_nome(Nome,R) :- findall(estafeta(Nome,ID,Z,MT,Cl,LE,P),
                                 estafeta(Nome,ID,Z,MT,Cl,LE,P), R).
/*... um certo id */
estafeta_id(ID,R) :- findall(estafeta(N,ID,Z,MT,Cl,LE,P),
                             estafeta(N,ID,Z,MT,Cl,LE,P), R).
/*... uma certa zona */
estafeta_zona(Zona,R) :- findall(estafeta(N,ID,Zona,MT,Cl,LE,P),
                                 estafeta(N,ID,Zona,MT,Cl,LE,P), R).
/*... um certo tipo de transporte */
estafeta_meioT(TipoMT,R) :- findall(estafeta(N,ID,Z,meio_transporte(Matr,TipoMT,V,Peso),Cl,LE,P),
                                    estafeta(N,ID,Z,meio_transporte(Matr,TipoMT,V,Peso),Cl,LE,P), R).
/*... um somatorio de classificacoes*/
estafeta_sumClassf(SumClassf,R) :- findall(estafeta(N,ID,Z,MT,SumClassf/ClTotais,LE,P),
                                           estafeta(N,ID,Z,MT,SumClassf/ClTotais,LE,P), R).
/*... uma certa numero de classificacoes*/
estafeta_clTotais(ClTotais,R) :- findall(estafeta(N,ID,Z,MT,SumClassf/ClTotais,LE,P),
                                         estafeta(N,ID,Z,MT,SumClassf/ClTotais,LE,P), R).
/*... uma certa lista de entregas */
estafeta_LEntrega(LE,R) :- findall(estafeta(Nome,ID,Z,MT,Cl,LE,P),
                                   estafeta(Nome,ID,Z,MT,Cl,LE,P), R).
/*... um certo tipo de penalização */
estafeta_Penaliz(Penaliz,R) :- findall(estafeta(Nome,ID,Z,MT,Cl,LE,Penaliz),
                                       estafeta(Nome,ID,Z,MT,Cl,LE,Penaliz), R).

% (2) Meio de transporte -------------------------------------------------------

% Procura todos os meios de transporte por -------------------------------------
/*... uma certa matricula */
meioTransporte_matricula(Matr,R) :- findall(meio_transporte(Matr,Tipo,V,Peso),
                                            estafeta(_,_,_,meio_transporte(Matr,Tipo,V,Peso),_,_,_), R).
/*... um certo tipo */
meioTransporte_tipo(Tipo,R) :- findall(meio_transporte(Matr,Tipo,V,Peso),
                                            estafeta(_,_,_,meio_transporte(Matr,Tipo,V,Peso),_,_,_), R).
/*... uma certa velocidade */
meioTransporte_vel(V,R) :- findall(meio_transporte(Matr,Tipo,V,Peso),
                                            estafeta(_,_,_,meio_transporte(Matr,Tipo,V,Peso),_,_,_), R).
/*... um certo peso */
meioTransporte_peso(Peso,R) :- findall(meio_transporte(Matr,Tipo,V,Peso),
                                            estafeta(_,_,_,meio_transporte(Matr,Tipo,V,Peso),_,_,_), R).

% (3) Pedido -------------------------------------------------------------------

% Procura todos os pedidos por -------------------------------------------------
/*... cliente */
pedido_cliente(ID_Cli,R) :- findall(LE, 
                                    estafeta(_,_,_,_,_,LE,_), LAux),
                            filter_by_IDC(ID_Cli,LAux,[],R).
/*... prazo */
pedido_prazo(Prazo,R) :- findall(LE, 
                                estafeta(_,_,_,_,_,LE,_), LAux),
                         filter_by_Prazo(Prazo,LAux,[],R).
/*... zona */
pedido_zona(Zona,R) :- findall(LE, 
                                estafeta(_,_,_,_,_,LE,_), LAux),
                         filter_by_Zona(Zona,LAux,[],R).
/*... peso */
pedido_peso(Peso,R) :- findall(LE, 
                                estafeta(_,_,_,_,_,LE,_), LAux),
                         filter_by_Peso(Peso,LAux,[],R).
/*... data */
pedido_data(Data,R) :- findall(LE, 
                                estafeta(_,_,_,_,_,LE,_), LAux),
                         filter_by_DataPed(Data,LAux,[],R).
/*... estado */
pedido_estado(Estado,R) :- findall(LE, 
                                estafeta(_,_,_,_,_,LE,_), LAux),
                         filter_by_Estado(Estado,LAux,[],R).
%------------------------------------------------------------------------------%


adiciona_classificacao(estafeta(A, B, C, D, E, Somatorio/Total, F), Classificacao, estafeta(A, B, C, D, E, NovoSomatorio/NovoTotal, F)) :-
    NovoSomatorio is Somatorio+Classificacao,
    NovoTotal is Total+1.
%------------------------------------------
add_estafeta(E) :- add_pred(E).
add_pred(T) :- findall(I,+T::I,Li),
               add_bc(T),
               teste(Li).

add_bc(T) :- assert(T).
add_bc(T) :- retract(T),!, fail.


%------------------------------------------
remove_estafeta(E) :- remove_pred(E).
remove_pred(T) :- findall(I,-T::I,Li),
                  remove_bc(T),
                  teste(Li).
%- remocao: T -> {V,F}
remove_bc(T) :- retract(T),!, fail.

%- teste: L -> {V,F}
teste([]).
teste([I|Is]):-I,teste(Is).

%------------------------------------------------------------------------------%
%---------------------------------- Querys   ----------------------------------%
%------------------------------------------------------------------------------%

% Query 1: Estafeta mais ecologico 

estafeta_mais_ecologico(EstafetaSol) :-
    findall(estafeta(Nome, ID, Freg, meio_transporte(ID_Tr,bicicleta,Vel,Peso), Classf, LPed, Penaliz), 
            estafeta(Nome, ID, Freg, meio_transporte(ID_Tr,bicicleta,Vel,Peso), Classf, LPed, Penaliz),
            L),
    
    length(L, LS),
    (  
        LS == 0 ->    % Caso nao existam estafetas de bicicleta, procura os que andam de moto
            (
                findall(estafeta(Nome, ID, Freg, meio_transporte(ID_Tr,moto,Vel,Peso), Classf, LPed, Penaliz), 
                    estafeta(Nome, ID, Freg, meio_transporte(ID_Tr,moto,Vel,Peso), Classf, LPed, Penaliz),
                    LL),
                length(LL, NewL),
                (
                    NewL == 0 -> % Caso nao existam estafetas de moto, procura os de carro
                        (
                            findall(estafeta(Nome, ID, Freg, meio_transporte(ID_Tr,carro,Vel,Peso), Classf, LPed, Penaliz), 
                                estafeta(Nome, ID, Freg, meio_transporte(ID_Tr,carro,Vel,Peso), Classf, LPed, Penaliz),
                                LLL)
                            ,maiorLista(LLL,_,EstafetaSol)
                        )
                   ;maiorLista(LL,_,EstafetaSol) 
                )  
            )
            ;maiorLista(L,_,EstafetaSol)
    )
    .

% Devolve a lista de entregas do estafeta
getListPed(estafeta(_, _, _, _, _, LPed, _),LPed).


%devolve o estafeta com mais entregas
maiorLista([],L,L).

maiorLista([H|T],L,R) :-
    getListPed(H,L1),
    length(L1,R1),
    getListPed(L,L2),
    length(L2,R2),
    (R1 >= R2 ->
        maiorLista(T,H,R);
        maiorLista(T,L,R)
    ).


%------------------------------------------------------------------------------%
% Query 2: Estafetas que entregaram a um dado pedido_cliente

estafeta_entregaram_cliente(Cliente,S):-
findall(estafeta(Nome, ID, Freg, MT, Classf, LPed, Penaliz), 
            estafeta(Nome, ID, Freg, MT, Classf, LPed, Penaliz),
            Lista),
    estafeta_entregaram_cliente_aux(Cliente,Lista,[],S).


estafeta_entregaram_cliente_aux(_,[],S,S).


estafeta_entregaram_cliente_aux(Cliente,[H|T],Lista,S):-
    getListPed(H,Pedidos),
    vezes_entregue(Cliente,Pedidos,0,R),
    (R>0 ->
        estafeta_entregaram_cliente_aux(Cliente,T,[H|Lista],S);
        estafeta_entregaram_cliente_aux(Cliente,T,Lista,S)
        ).

% estafeta_mais_entregou(6).

%------------------------------------------------------------------------------%
% Query 3: Clientes servidos por um determinado estafeta

clientes_servidos(EstafetaId,L):-
    estafeta(_, EstafetaId, _, _, _, LPed, _),
    clientes_servidos_aux(LPed,[],L).


clientes_servidos_aux([],S,S).

clientes_servidos_aux([H|T],Acc,S):-
    H = pedido(IdCliente,_, _, _, _, _, _, _),
    clientes_servidos_aux(T,[IdCliente|Acc],S).


% clientes_servidos(938283).


%------------------------------------------------------------------------------%
% Query 4: Calcular valor faturado pela empresa em um dado dia

calcular_valor_faturado_dia(Data,Total):-
    findall(estafeta(Nome, ID, Freg, MT, Classf, LPed, Penaliz), 
            estafeta(Nome, ID, Freg, MT, Classf, LPed, Penaliz),
            Lista),
    calcular_valor_faturado_dia_aux(Data,Lista,0,Total).


calcular_valor_faturado_dia_aux(_,[],Total,Total).

calcular_valor_faturado_dia_aux(Data,[H|T],Calculado,Total):-
    estafeta_valor_faturado_dia(Data,H,R),
    NovoCalculado is R + Calculado,
    calcular_valor_faturado_dia_aux(Data,T,NovoCalculado,Total) . 


estafeta_valor_faturado_dia(Data,H,R):-
    getListPed(H,Pedidos),
    estafeta_valor_faturado_dia_aux(Data,Pedidos,0,R).

estafeta_valor_faturado_dia_aux(_,[],R,R).

estafeta_valor_faturado_dia_aux(Ano/Mes/Dia,[H|T],C,R):-
    H = pedido(_,_, Limite, _, _, Peso, Y/M/D, _),
    (Y == Ano , M == Mes , D == Dia ->
        calcular_valor(Y/M/D,Limite,Peso,Valor),
        NovoC is C + Valor,
        estafeta_valor_faturado_dia_aux(Ano/Mes/Dia,T,NovoC,R);
        estafeta_valor_faturado_dia_aux(Ano/Mes/Dia,T,C,R)
        ).


calcular_valor(_/_/D,_/_/DLim,Peso,Valor):-
    Valor is div(Peso*2 , (DLim - D)).



%calcular_valor_faturado_dia(2021/4/1).

%------------------------------------------------------------------------------%
% Query 5: Calcular zonas com maior volume de entregas
% tirar writes para por no menu
maior_volume_entregas_zona():-
    findall(estafeta(Nome, ID, Freg, MT, Classf, LPed, Penaliz), 
            estafeta(Nome, ID, Freg, MT, Classf, LPed, Penaliz),
            Lista),
    maior_volume_entregas_zonaAux(Lista,[]).
   
maior_volume_entregas_zonaAux([],[]):-
    writeln("Nao existem estafetas").

maior_volume_entregas_zonaAux([],[H|T]):-
    H = Zona/Acc,
    writeGreatestDouble(T,Acc,Zona,RAcc,RZona),
    writeln(RZona),writeln(RAcc).

maior_volume_entregas_zonaAux([H|T],Zona_Acc):-
    H = estafeta(_,_,_,_,_,ListaPedidos,_),
    adicionaContagem(ListaPedidos,Zona_Acc,NovaZona_Acc),
    maior_volume_entregas_zonaAux(T,NovaZona_Acc).

%atualiza lista de zona/contagem
adicionaContagem([],S,S).
adicionaContagem([H|T],Zona_Acc,NovaZona_Acc):-
    H = pedido(_,_, _, _, Zona, _, _, _),
    atualiza_lista_pares(Zona,1,Zona_Acc,[],S,0),
    adicionaContagem(T,S,NovaZona_Acc).


atualiza_lista_pares(_,_,_,S,S,1).

atualiza_lista_pares(Z,Acc,[],R,S,0):-
    atualiza_lista_pares(Z,Acc,[],[Z/Acc|R],S,1).

atualiza_lista_pares(Z,Acc,[H|T],R,S,0):-
    H = Zona/A,
    (Z == Zona->
        Acc2 is A +Acc,
        append(T,[Z/Acc2|R],NovaLista),
        atualiza_lista_pares(Z,Acc,T,NovaLista,S,1);
        atualiza_lista_pares(Z,Acc,T,[H|R],S,0)
        ).


%maior_volume_entregas_zona().
%atualiza_lista_pares(ferreiros,1,[figueiredo/1,ferreiros/5],[],S,0).

%------------------------------------------------------------------------------%
% Query 6: Calcular classificacao media de um estafeta

classificacao_media(EstafetaId, Media):-
    estafeta(_,EstafetaId,_,_,SomatClassf/ClTotais,_,_),
    Media is SomatClassf / ClTotais.



%classificacao_media(938283).


%------------------------------------------------------------------------------%
% Query 7: Calcular numero de entregas para cada transporte num intervalo de tempo

numero_entregas_intervalo_transporte(DataLo,DataHi,TotalBic,TotalMo,TotalCar):-
    findall(estafeta(Nome, ID, Freg, meio_transporte(ID_Tr,T,Vel,Peso), SomatClassf/NumClassf, LPed, Penaliz), 
            estafeta(Nome, ID, Freg, meio_transporte(ID_Tr,T,Vel,Peso), SomatClassf/NumClassf, LPed, Penaliz),
            Lista),
    numero_entregas_intervalo_transporte_aux(DataLo,DataHi,Lista,0,0,0,TotalBic,TotalMo,TotalCar).


numero_entregas_intervalo_transporte_aux(_,_,[],TotalBic,TotalMo,TotalCar,TotalBic,TotalMo,TotalCar).

numero_entregas_intervalo_transporte_aux(DataLo,DataHi,[H|T],CalcBi,CalcMo,CalcCar,TotalBic,TotalMo,TotalCar):-
    H = estafeta(_,_,_,meio_transporte(_,Meio,_,_),_,Pedidos,_),
    numero_entregas_intervalo_transporte_aux2(DataLo,DataHi,Meio,Pedidos,0,0,0,B,M,C),
    NovoCalcBi is CalcBi + B,
    NovoCalcMo is CalcMo + M,
    NovoCalcCar is CalcCar + C,
    numero_entregas_intervalo_transporte_aux(DataLo,DataHi,T,NovoCalcBi,NovoCalcMo,NovoCalcCar,TotalBic,TotalMo,TotalCar).

numero_entregas_intervalo_transporte_aux2(_,_,_,[],B,M,C,B,M,C).

numero_entregas_intervalo_transporte_aux2(DataLo,DataHi,Meio,[H|T],CB,CM,CC,B,M,C):-
    H = pedido(_,_, _, _, _, _,Data, _),
    data_no_intervalo(DataLo,DataHi,Data,S),
    (S == 1 -> 
        (Meio == bicicleta ->
            (
                NovoCB is CB + 1,
                numero_entregas_intervalo_transporte_aux2(DataLo,DataHi,Meio,T,NovoCB,CM,CC,B,M,C)
                );
            Meio == moto ->
            (
                NovoCM is CM + 1,
                numero_entregas_intervalo_transporte_aux2(DataLo,DataHi,Meio,T,CB,NovoCM,CC,B,M,C)
                );
            NovoCC is CC + 1,
            numero_entregas_intervalo_transporte_aux2(DataLo,DataHi,Meio,T,CB,CM,NovoCC,B,M,C)
            );
        numero_entregas_intervalo_transporte_aux2(DataLo,DataHi,Meio,T,CB,CM,CC,B,M,C)
        ).


%numero_entregas_intervalo_transporte(2021/1/1,2021/5/20).

%------------------------------------------------------------------------------%
% Query 8: identificar o numero total de entregas pelos estafetas num determinado tempo

total_entregas_intervalo(DataLo,DataHi,Total) :-
    findall(estafeta(Nome, ID, Freg, meio_transporte(ID_Tr,T,Vel,Peso), SomatClassf/NumClassf, LPed, Penaliz), 
            estafeta(Nome, ID, Freg, meio_transporte(ID_Tr,T,Vel,Peso), SomatClassf/NumClassf, LPed, Penaliz),
            Lista),
    total_entregas_intervalo_aux(DataLo,DataHi,Lista,0,Total).

total_entregas_intervalo_aux(_,_,[],R,R).
total_entregas_intervalo_aux(DataLo,DataHi,[H|T],R):-
    getListPed(H,Pedidos),
    numero_entregas_intervalo_transporte_aux2(DataLo,DataHi,__,Pedidos,0,0,0,B,M,C),
    CalcEstafeta is R +B + M + C,
    total_entregas_intervalo_aux(DataLo,DataHi,T,CalcEstafeta).

%total_entregas_intervalo(2021/1/1,2021/12/31).

%------------------------------------------------------------------------------%
% Query 9: nº de encomendas entregues e nao entregues num intervalo de tempo-------------%

calcula_n_encomendas(DataI,DataF,R) :-
    findall(LPed, 
            estafeta(_, _, _, _, _, LPed, _),
            L),
    filtra_pedidos(L,DataI,DataF,0/0,R). 

filtra_pedidos([],_,_,R,R).
filtra_pedidos([[]|TS],D1,D2,Accs,Rs) :- filtra_pedidos(TS,D1,D2,Accs,Rs).
filtra_pedidos([[P|T]|TS],DataI,DataF,Acc1/Acc2,R) :-
    getData(P,DataP),
    data_no_intervalo(DataI,DataF,DataP,S),
    (S == 1 ->
        getEstado(P,Estado),
        (Estado == 0 ->
         New_Acc1 is Acc1+1,
         filtra_pedidos([T|TS],DataI,DataF,New_Acc1/Acc2,R);

         New_Acc2 is Acc2+1,
         filtra_pedidos([T|TS],DataI,DataF,Acc1/New_Acc2,R)
        );
        
        filtra_pedidos([T|TS],DataI,DataF,Acc1/Acc2,R)
    ).   

getData(pedido(_,_, DataP,_, _, _,_, _),DataP).
getEstado(pedido(_,_, _, _, _, _,_, Estado),Estado).
%------------------------------------------------------------------------------%
% Query 10: calcular o peso total transportado por um estafeta em um dia

calcula_pesos(Data,ListaRes):-
    findall(estafeta(Nome, ID, Freg, meio_transporte(ID_Tr,T,Vel,Peso), SomatClassf/NumClassf, LPed, Penaliz), 
            estafeta(Nome, ID, Freg, meio_transporte(ID_Tr,T,Vel,Peso), SomatClassf/NumClassf, LPed, Penaliz),
            ListaEstaf),
    calcula_pesosAux(Data,ListaEstaf,ListaRes).


calcula_pesosAux(_,[],_).
calcula_pesosAux(Data,[estafeta(Nome,ID,_,_,_,_,_)|T],ListaRes):-
    calcula_peso_total(ID,Data,PesoTotal),
    calcula_pesosAux(Data,T,[Nome/PesoTotal|T]).
    


calcula_peso_total(ID, Data, PesoTotal) :-
    estafeta(_,ID,_,_,_,LPed,_),
    filtra_pedidos_dia(LPed,Data,0,PesoTotal).
    

filtra_pedidos_dia([],_,R,R).
filtra_pedidos_dia([pedido(_,_,_, _,_,Peso,A/M/D, _)|T],Ano/Mes/Dia,Acc,R) :-
    ((A == Ano , M == Mes , D == Dia) ->
        NewAcc is Acc+Peso,
        filtra_pedidos_dia(T,Ano/Mes/Dia,NewAcc,R);
        filtra_pedidos_dia(T,Ano/Mes/Dia,Acc,R)
    ).

%------------------------------------------------------------------------------%


% Query Extra: Estafeta que mais entregou a um dado pedido_cliente

estafeta_mais_entregou(Cliente,S):-
findall(estafeta(Nome, ID, Freg, MT, Classf, LPed, Penaliz), 
            estafeta(Nome, ID, Freg, MT, Classf, LPed, Penaliz),
            Lista),
    estafeta_mais_entregou_aux(Cliente,Lista,_,0,S).


estafeta_mais_entregou_aux(_,[],S,_,S).


estafeta_mais_entregou_aux(Cliente,[H|T],Max,R2,S):-
    getListPed(H,Pedidos),
    vezes_entregue(Cliente,Pedidos,0,R1),
    (R1>=R2 ->
        estafeta_mais_entregou_aux(Cliente,T,H,R1,S);
        estafeta_mais_entregou_aux(Cliente,T,Max,R2,S)
        ).

vezes_entregue(_,[],R,R).


vezes_entregue(Cliente,[pedido(cliente(_,IdCliente),_, _, _, _, _, _, _)|T],X,R):-
    (Cliente == IdCliente->
        X2 is X + 1,
        vezes_entregue(Cliente,T,X2,R);
        vezes_entregue(Cliente,T,X,R)
        ).
% estafeta_mais_entregou(6).
%------------------------------------------------------------------------------%

%Auxiliares
valida_data((Ano, Mes, Dia)) :-
    Ano>0,
    Mes>0,
    Mes<13,
    Dia>0,
    Dia<32.

is_transporte(moto).
is_transporte(bicicleta).
is_transporte(carro).

valida_transporte(moto, V, P) :-
    V >= 0, V =< 35,
    P >= 0, P =< 20.
valida_transporte(bicicleta,V,P) :-
    V >= 0, V =< 10, 
    P >= 0, P =< 5.
valida_transporte(carro,V,P) :-
    V >= 0, V =< 25,
    P >= 0, P =< 100.

data_no_intervalo(DataLo,DataHi,Data,S):-
    data_valor(DataLo, Lo),
    data_valor(DataHi,Li),
    data_valor(Data,L),
    (L>=Lo , L=<Li -> S is 1; S is 0).



data_valor(AnoLo/MesLo/DiaLo,S):-
    S is AnoLo*400 + MesLo*32 + DiaLo.

writeGreatestDouble([],TAcc,AZona,TAcc,AZona).

writeGreatestDouble([Z/A|T],Acc,Zona,TAcc,AZona):-
    (A>Acc ->
        writeGreatestDouble(T,A,Z,TAcc,AZona);
        writeGreatestDouble(T,Acc,Zona,TAcc,AZona)
        ).

filter_by_IDC(_,[],R,R).
filter_by_IDC(ID_Cli,[[]|TS], Acc,R) :- filter_by_IDC(ID_Cli,TS, Acc,R).
filter_by_IDC(ID_Cli,[[pedido(cliente(NomeCliente,IdCliente),ID_Ped, DataE, R_, Z, Pes, DataP, Est)|T]|TS],Acc,R) :-
    (ID_Cli == IdCliente->
        filter_by_IDC(ID_Cli,[T|TS],[pedido(cliente(NomeCliente,IdCliente),ID_Ped, DataE, R_, Z, Pes, DataP, Est)|Acc],R);
        filter_by_IDC(ID_Cli,[T|TS],Acc,R)
        ).

filter_by_Prazo(_,[],R,R).
filter_by_Prazo(Prazo,[[]|TS], Acc,R) :- filter_by_Prazo(Prazo,TS, Acc,R).
filter_by_Prazo(Prazo,[[pedido(Cl,ID_Ped, DataE, R_, Z, Pes, DataP, Est)|T]|TS],Acc,R) :-
    (DataE == Prazo->
        filter_by_Prazo(Prazo,[T|TS],[pedido(Cl,ID_Ped, DataE, R_, Z, Pes, DataP, Est)|Acc],R);
        filter_by_Prazo(Prazo,[T|TS],Acc,R)
        ).

filter_by_Zona(_,[],R,R).
filter_by_Zona(Zona,[[]|TS], Acc,R) :- filter_by_Zona(Zona,TS, Acc,R).
filter_by_Zona(Zona,[[pedido(Cl,ID_Ped, DataE, R_, Z, Pes, DataP, Est)|T]|TS],Acc,R) :-
    (Zona == Z->
        filter_by_Zona(Zona,[T|TS],[pedido(Cl,ID_Ped, DataE, R_, Z, Pes, DataP, Est)|Acc],R);
        filter_by_Zona(Zona,[T|TS],Acc,R)
        ).

filter_by_Peso(_,[],R,R).
filter_by_Peso(Peso,[[]|TS], Acc,R) :- filter_by_Peso(Peso,TS, Acc,R).
filter_by_Peso(Peso,[[pedido(Cl,ID_Ped, DataE, R_, Z, Pes, DataP, Est)|T]|TS],Acc,R) :-
    (Peso == Pes->
        filter_by_Peso(Peso,[T|TS],[pedido(Cl,ID_Ped, DataE, R_, Z, Pes, DataP, Est)|Acc],R);
        filter_by_Peso(Peso,[T|TS],Acc,R)
        ).

filter_by_DataPed(_,[],R,R).
filter_by_DataPed(DataPed,[[]|TS], Acc,R) :- filter_by_DataPed(DataPed,TS, Acc,R).
filter_by_DataPed(DataPed,[[pedido(Cl,ID_Ped, DataE, R_, Z, Pes, DataP, Est)|T]|TS],Acc,R) :-
    (DataPed == DataP->
        filter_by_DataPed(DataPed,[T|TS],[pedido(Cl,ID_Ped, DataE, R_, Z, Pes, DataP, Est)|Acc],R);
        filter_by_DataPed(DataPed,[T|TS],Acc,R)
        ).

filter_by_Estado(_,[],R,R).
filter_by_Estado(Estado,[[]|TS], Acc,R) :- filter_by_Estado(Estado,TS, Acc,R).
filter_by_Estado(Estado,[[pedido(Cl,ID_Ped, DataE, R_, Z, Pes, DataP, Est)|T]|TS],Acc,R) :-
    (Est == Estado->
        filter_by_Estado(Estado,[T|TS],[pedido(Cl,ID_Ped, DataE, R_, Z, Pes, DataP, Est)|Acc],R);
        filter_by_Estado(Estado,[T|TS],Acc,R)
        ).
