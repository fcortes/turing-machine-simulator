// Checks if a list of binary integers is a valid min-heap
// This is, d[n] <= d[2n] && d[2n+1] for each n
// Input numbers should be separated by . and be of fixed width
name: is_heap
init: q0
accept: qheap

q0,0,_
qinit,0,_,<,-
q0,1,_
qinit,1,_,<,-
q0,.,_
qcheckn,.,|,-,-

qinit,_,_
qcheckn,.,|,-,-

// Revisar d_n con d_{2n} y d_{2n+1}

qcheckn,.,|
qfind2n,.,|,-,-

// Buscal el 2n-esimo .
qfind2n,.,|
qfind2np,.,|,>,-

qfind2np,.,|
qfind2n,.,|,>,>

qfind2n,0,|
qfind2n,0,|,>,-
qfind2n,1,|
qfind2n,1,|,>,-

// Si no lo encontramos, entonces ya es un heap :D
qfind2n,_,_
qheap,_,_,-,-

qfind2np,0,|
qfind2np,0,|,>,-
qfind2np,1,|
qfind2np,1,|,>,-

qfind2n,0,_
qcopy,0,_,-,-
qfind2n,1,_
qcopy,1,_,-,-

qcopy,0,_
qcopy,0,0,>,>
qcopy,1,_
qcopy,1,1,>,>

qcopy,.,_
qcopy2,.,#,>,>

qcopy2,0,_
qcopy2,0,0,>,>
qcopy2,1,_
qcopy2,1,1,>,>

qcopy2,.,_
qback2,.,_,-,<

qcopy2,_,_
qback2,.,_,-,<

// Volver al incio en la segunda
qback2,.,0
qback2,.,0,-,<
qback2,.,1
qback2,.,1,-,<
qback2,.,#
qback2,.,#,-,<
qback2,.,|
qback1,.,|,-,-

// Volver al inicio e ir al punto para empezar a comparar
qback1,.,|
qback1,.,|,<,-
qback1,0,|
qback1,0,|,<,-
qback1,1,|
qback1,1,|,<,-

qback1,_,|
qgotoandcompare,_,|,>,-

// Ir a la posicion
qgotoandcompare,.,|
qgotoandcompare,.,|,>,<
qgotoandcompare,0,|
qgotoandcompare,0,|,>,-
qgotoandcompare,1,|
qgotoandcompare,1,|,>,-

qgotoandcompare,0,_
qnumber2,0,_,<,>
qgotoandcompare,1,_
qnumber2,1,_,<,>

qnumber2,.,|
qnumber2,.,|,-,>

qnumber2,.,0
qcompare,.,0,>,-
qnumber2,.,1
qcompare,.,1,>,-

// Comparar en numero en la cinta 1 con los dos de la cinta 2
qcompare,0,0
qcompare,0,0,>,>
qcompare,1,1
qcompare,1,1,>,>
qcompare,0,1
qlt,0,1,>,>

// Seguir leyendo hasta el final
qlt,0,0
qlt,0,0,>,>
qlt,0,1
qlt,0,1,>,>
qlt,1,0
qlt,1,0,>,>
qlt,1,1
qlt,1,1,>,>

// Comparar el primer numero con el segundo
qlt,.,#
qback11,.,#,<,-

qback11,0,#
qback11,0,#,<,-
qback11,1,#
qback11,1,#,<,-

qback11,.,#
qcompare2,.,#,>,>

qcompare2,0,0
qcompare2,0,0,>,>
qcompare2,1,1
qcompare2,1,1,>,>
qcompare2,0,1
qlt2,0,1,-,-

// Si estamos en qlt2, este numero esta bien
qlt2,0,1
qnext,0,1,-,-

qnext,0,1
qnext_back1,0,1,-,-

// Ir al final de la segunda cinta
qnext_back1,0,1
qnext_back1,0,1,<,-
qnext_back1,1,1
qnext_back1,1,1,<,-
qnext_back1,.,1
qnext_back1,.,1,<,-

qnext_back1,_,1
qnext_end2,_,1,>,>

qnext_end2,.,0
qnext_end2,.,0,-,>
qnext_end2,.,1
qnext_end2,.,1,-,>

qnext_end2,.,_
qnext_erase2,.,_,-,<

// Borrar segunda cinta
qnext_erase2,.,0
qnext_erase2,.,_,-,<
qnext_erase2,.,1
qnext_erase2,.,_,-,<
qnext_erase2,.,#
qnext_erase2,.,_,-,<

qnext_erase2,.,|
qnext_back2,.,|,-,<

qnext_back2,.,|
qnext_back2,.,|,-,<

qnext_back2,.,_
qcheckn,.,|,-,-
