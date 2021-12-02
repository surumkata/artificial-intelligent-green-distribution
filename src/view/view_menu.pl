%-------------------------------------------------------------------------------------%
menuPrincipal :-
    write('\n'),
    write('\033\[32m-----------MENU-------------\033\[0m\n'),
    write('Seleciona um número (não te esqueças do ponto final):\n'),
    write('> 1. Adicionar termos\n'),
    write('> 2. Efetuar listagens\n'),
    write('> 3. Efetuar querys\n\n'),
    write('> 0. Sair\n').
%-------------------------------------------------------------------------------------%
menuAddTermosGeral :-
    write('\033\[32mPretende adicionar:\033\[0m\n'),
    write('> 1. Morada\n'),
    write('> 2. Meio de transporte\n'),
    write('> 3. Cliente\n'),
    write('> 4. Pedido\n'),
    write('> 5. Estafeta\n'),
    write('> 6. Pedido ao estafeta\n\n'),
    write('> 0. Sair\n').


%-------------------------------------------------------------------------------------%

menuListas :-
    write('\n'),
    write('\033\[32m-----------Listagens-----------\033\[0m\n'),
    write(' 1. Listar estafetas\n'),
    write(' 2. Listar meios de transporte\n'),
    write(' 3. Listar pedidos\n\n'),
    write(' 0. Sair\n').

menuListar_estafetas :-
    write('\033\[32mListar estafetas por:\033\[0m\n'),
    write(' 1. Nome \n'),
    write(' 2. ID \n'),
    write(' 3. Zona \n'),
    write(' 4. Meio de Transporte \n'),
    write(' 5. Somatório de classificações \n'),
    write(' 6. Número de classificações totais \n'),
    write(' 7. Pedido \n'),
    write(' 8. Nível de penalização \n\n'),
    write(' 0. Sair\n').

menuListar_MT :-
    write('\n\033\[32mListar meios de transporte por:\033\[0m\n'),
    write(' 1. Matricula\n'),
    write(' 2. Tipo \n'),
    write(' 3. Velocidade \n'),
    write(' 4. Peso \n\n'),
    write(' 0. Sair\n').

menuListar_Pedidos :-
    write('\n\033\[32mListar pedidos por:\033\[0m\n'),
    write(' 1. ID do pedido \n'),
    write(' 2. ID do cliente \n'),
    write(' 3. Data limite \n'),
    write(' 4. Rua \n'),
    write(' 5. Freguesia \n'),
    write(' 6. Peso \n'),
    write(' 7. Data do pedido \n'),
    write(' 8. Estado \n\n'),
    write(' 0. Sair \n').

%-------------------------------------------------------------------------------------%
menuQuery_view :-
    write('\n'),
    write('\033\[32m-----------Querys-----------\033\[0m\n'),
    write(' 1. Identificar o estafeta que utilizou mais vezes um meio de transporte mais ecológico\n'),
    write(' 2. Identificar que estafetas entregaram determinada(s) encomenda(s) a um determinado cliente\n'),
    write(' 3. Identificar os clientes servidos por um determinado estafeta\n'),
    write(' 4. Calcular o valor faturado pela Green Distribution num determinado dia\n'),
    write(' 5. Identificar quais as zonas com maior volume de entregas por parte da Green Distribution\n'),
    write(' 6. Calcular a classificação média de satisfação de cliente para um determinado estafeta\n'),
    write(' 7. Identificar o número total de entregas pelos diferentes meios de transporte, num determinado intervalo de tempo\n'),
    write(' 8. Identificar o número total de entregas pelos estafetas, num determinado intervalo de tempo\n'),
    write(' 9. Calcular o número de encomendas entregues e não entregues pela Green Distribution, num determinado período de tempo\n'),
    write('10. Calcular o peso total transportado por estafeta num determinado dia\n'),
    write('11. Calcular o peso total transportado por um dado estafeta num determinado dia\n\n'),
    write(' 0. Sair \n').

%-------------------------------------------------------------------------------------%
%                           Pretty print dos termos 
%-------------------------------------------------------------------------------------%

writeEstafeta(estafeta(Nome,ID,Zona,MeioT,CL,LE,Penaliz)) :-
  write('Nome do estafeta: '), write(Nome), writeln(';'),
  write('ID: '), write(ID), writeln(';'),
  write('Zona: '), write(Zona), writeln(';'),
  writeln('Meio de transporte: '), writeMT(MeioT), writeln(';'),
  write('Somatório/Número de classificações: '), write(CL), writeln(';'),
  writeln('Pedidos associados: '), printPedidos(LE),
  write('Nível de penalização: '), write(Penaliz), write('\n').


write_lista_estafeta([],_).

write_lista_estafeta([H|T],Option):-
    (Option == 0 ->
        writeEstafeta(H);
        H = estafeta(Nome,ID,_,_,_,_,_),
        write('\n> Nome do estafeta: '), write(Nome), writeln(';'), 
        write('ID do estafeta: '), writeln(ID),
        writeln('-----------------------------------')
        ),
    write_lista_estafeta(T,Option).

write_lista_estafPesos([]).
write_lista_estafPesos([Name/Peso|T]):-
    nl,write(Name),write(" - "),write(Peso),nl,
    write_lista_estafPesos(T).



writeMT(meio_transporte(ID,T,P,V)) :-
  write('> Matricula: '), write(ID), write('; '),  
  write('Tipo: '), write(T), write('; '),
  write('Peso máximo: '), write(P), write('; '),
  write('Velocidade máxima: '), writeln(V).

printMts([]).
printMts([H|T]) :-
    writeMT(H),
    printMts(T).

printPedidos([]).
printPedidos([H|T]) :-
    writePedido(H),
    printPedidos(T).

writePedido(pedido(cliente(NomeC,ID_Cl), ID_Ped, DataEnt, Rua, Freg, Peso, DataPed, Est)) :-
  write('> ID do pedido: '), write(ID_Ped), write('; '),
  write('Nome do cliente: '), write(NomeC), write(';'),
  write('ID do cliente: ' ), write(ID_Cl), write('; '),
  write('Data de entrega: '), write(DataEnt), write('; '),
  write('Rua: '), write(Rua), write('; '),
  write('Freguesia: '), write(Freg), write('; '),
  write('Peso: '), write(Peso), write('; '),
  write('Data do pedido: '), write(DataPed), write('; '),
  write('Estado: '), write(Est), writeln('.').

% limpar tela
limpaT :-
    write('\033[H\033[2J').