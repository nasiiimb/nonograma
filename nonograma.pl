/***************************************************************************
 *  nonograma.pl
 *  Práctica final de PROLOG · Curso 2024-25 · UIB
 *
 *  ───────────────────────────────────────────────────────────────────
 *  Datos de la entrega
 *  ───────────────────────────────────────────────────────────────────
 *    Estudiantes : Nasim Hosam Benyacoub Terki, David Vázquez Rivas
 *    Asignatura  : 21721 – Lenguajes de Programación (grupo de prácticas 1)
 *    Profesor    : Francesc Xavier Gaya Morey, Antoni Oliver Tomàs 
 *    Convocatoria: Ordinaria
 *    Fecha       : mayo 2025
 *
  *  ───────────────────────────────────────────────────────────────────
 *  Ejemplos requeridos
 *  ───────────────────────────────────────────────────────────────────
 *  ?- nonograma(
 *         [[5], [], [2,1], [1], [1,2]],
 *         [[1,1],[1,1],[1,1,1],[1,2],[1,1]],
 *         Casillas).
 *  Casillas = [[1,1,1,1,1],
 *              [0,0,0,0,0],
 *              [0,1,1,0,1],
 *              [0,0,0,1,0],
 *              [1,0,1,1,0]].
 *
 *  ?- nonograma(
 *         [[2],[1]],
 *         [[2],[1],[]],
 *         Casillas).
 *  Casillas = [[1,1,0],
 *              [1,0,0]].
 *
 *  ───────────────────────────────────────────────────────────────────
 *  Ejemplos con generador y pintado
 *  ───────────────────────────────────────────────────────────────────
 *  ?- genera_nonograma(5,7,PFilas,PCols,Sol),
 *     pinta_nonograma(Sol).
 *  %  PFilas y PCols unifican con las pistas calculadas.
 *  %  La cuadrícula 5×7 se muestra en consola.
 *
 *  ?- genera_nonograma(4,4,PF,PC,Sol),
 *     nonograma(PF,PC,Sol).      % debe dar true
 *
 *  ───────────────────────────────────────────────────────────────────

 ?- genera_nonograma(5,7,PistasFilas,PistasCols,Solucion),
    pinta_nonograma(Solucion).
 PistasFilas = …      % listas de bloques calculadas para las 5 filas
 PistasCols  = …      % listas de bloques calculadas para las 7 columnas
 % en pantalla se dibuja la cuadrícula 5×7 con |* , … |

 ?- genera_nonograma(4,4,PF,PC,Sol),
    nonograma(PF,PC,Sol).      % verifica que la cuadrícula generada es correcta
 true.

──────────────────────────────────────────────────────────────────
 *  Uso de los predicados
 *  ───────────────────────────────────────────────────────────────────
 *    • nonograma(PF,PC,Sol)        resuelve o verifica el nonograma.
 *    • genera_nonograma(F,C,PF,PC,Sol)  crea puzzle aleatorio F×C.
 *    • pinta_nonograma(Sol)        imprime la cuadrícula en ASCII.
 *
 *  ───────────────────────────────────────────────────────────────────
 *  Opcionales implementados
 *  ───────────────────────────────────────────────────────────────────
 *    ✓ Nonogramas rectangulares (N ≠ M).
 *    ✓ genera_nonograma (puzzle aleatorio + pistas).
 *    ✓ pinta_nonograma   (salida |* , …|).
 *
 *  ───────────────────────────────────────────────────────────────────
 *  Diseño declarativo resumido
 *  ───────────────────────────────────────────────────────────────────
 *    1.  Se crea una matriz de variables con length.
 *    2.  fila_ok genera o comprueba cada fila contra su lista de bloques.
 *    3.  La matriz se transpone y se aplica el mismo criterio a columnas.
 *    4.  Sin cortes ni if, todo se basa en unificación y retroceso.
 *
 *  Predicados usados : length, append, write, nl,
 *  random, aritmética y recursión sobre listas.
 ***************************************************************************/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  nonograma  –  paso global
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nonograma(PistasFilas, PistasColumnas, Matriz) :-
    length(PistasFilas, NF),
    length(PistasColumnas, NC),
    length(Matriz, NF),
    inicializar_filas(Matriz, NC),
    verificar_filas(Matriz, PistasFilas),
    trasponer(Matriz, Columnas),
    verificar_filas(Columnas, PistasColumnas),
    !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  inicializar_filas  –  crea todas las filas con NC variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inicializar_filas([], _).
inicializar_filas([Fila|R], NC) :-
    length(Fila, NC),
    inicializar_filas(R, NC).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  verificar_filas  –  aplica fila_ok a cada fila y su pista
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verificar_filas([], []).
verificar_filas([Fila|RF], [Pista|RP]) :-
    fila_ok(Fila, Pista),
    verificar_filas(RF, RP).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  fila_ok  –  coloca 1/0 para que una fila cumpla su lista de bloques
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fila_ok(Fila, []) :-                         % sin bloques → solo ceros
    todos_ceros(Fila).

fila_ok(Fila, [Tam]) :-                      % último bloque
    append(CerosIni, R1, Fila),
    todos_ceros(CerosIni),
    bloque_unos(Tam, Unos),
    append(Unos, CerosFin, R1),
    todos_ceros(CerosFin).

fila_ok(Fila, [Tam|Resto]) :-                % bloque + separador + resto
    append(CerosIni, R1, Fila),
    todos_ceros(CerosIni),
    bloque_unos(Tam, Unos),
    append(Unos, [0|R2], R1),
    fila_ok(R2, Resto).

bloque_unos(0, []).
bloque_unos(N, [1|R]) :-
    N>0, N1 is N-1,
    bloque_unos(N1, R).

todos_ceros([]).
todos_ceros([0|R]) :-
    todos_ceros(R).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  trasponer  –  filas → columnas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trasponer([[]|_], []) :- !.
trasponer(M, [Col|RC]) :-
    primera_columna(M, Col, M1),
    trasponer(M1, RC).

primera_columna([], [], []).
primera_columna([[X|Xs]|F], [X|RC], [Xs|RF]) :-
    primera_columna(F, RC, RF).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  genera_nonograma  –  aleatorio + pistas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

genera_nonograma(F, C, PFilas, PCols, Matriz) :-
    length(Matriz, F),
    filas_aleatorias(Matriz, C),
    pistas_filas(Matriz, PFilas),
    trasponer(Matriz, Cols),
    pistas_filas(Cols, PCols).

filas_aleatorias([], _).
filas_aleatorias([Fila|R], C) :-
    length(Fila, C),
    bits_aleatorios(Fila),
    filas_aleatorias(R, C).

bits_aleatorios([]).
bits_aleatorios([B|R]) :-
    random(0,2,B),
    bits_aleatorios(R).

pistas_filas([], []).
pistas_filas([F|R], [P|RP]) :-
    fila_a_pistas(F, P),
    pistas_filas(R, RP).

fila_a_pistas([], []).
fila_a_pistas([0|R], P) :-
    fila_a_pistas(R, P).
fila_a_pistas([1|R], [L|RP]) :-
    contar_unos([1|R], L, Rest),
    fila_a_pistas(Rest, RP).

contar_unos([1|R], N, S) :-
    contar_unos(R, N1, S),
    N is N1 + 1.
contar_unos([0|R], 0, R) :- !.
contar_unos([], 0, []).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  pinta_nonograma  –  ASCII: |celda,celda …|
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pinta_nonograma(M) :-
    nl, imprimir_filas(M), nl.

imprimir_filas([]).
imprimir_filas([F|R]) :-
    imprimir_fila(F), nl,
    imprimir_filas(R).

imprimir_fila(F) :-
    write('|'), imprimir_celdas(F), write('|').

imprimir_celdas([X]) :- celda_fin(X).
imprimir_celdas([X|R]) :-
    celda_coma(X),
    imprimir_celdas(R).

celda_coma(1) :- write('1,').
celda_coma(0) :- write('0,').

celda_fin(1) :- write('1').
celda_fin(0) :- write('0').
