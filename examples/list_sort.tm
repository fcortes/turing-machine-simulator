// Sorts a list of fixed-width binary integers separated by #
// Using a bubble-sort like algorithm
name: Number Comparator
init: q0
accept: qend

// Copy first number in second tape
q0,0,_,_
q0,_,0,_,>,>,-

q0,1,_,_
q0,_,1,_,>,>,-

q0,#,_,_
qend1,_,_,_,>,-,-

// Move to the back of tape 1
qend1,0,_,_
qend1,0,_,_,>,-,-

qend1,1,_,_
qend1,1,_,_,>,-,-

qend1,#,_,_
qback,#,_,_,<,<,-

qend1,_,_,_
qback,_,_,_,<,<,-

// Set both input numbers to same length
qsamelength,0,0,_
qsamelength,0,0,_,<,<,-
qsamelength,0,1,_
qsamelength,0,1,_,<,<,-
qsamelength,1,0,_
qsamelength,1,0,_,<,<,-
qsamelength,1,1,_
qsamelength,1,1,_,<,<,-

// First number larger than second
qsamelength,1,_,_
qsamelength,1,0,_,<,<,-
qsamelength,0,_,_
qsamelength,0,0,_,<,<,-
// Second number larger than first
qsamelength,_,1,_
qsamelength,0,1,_,<,<,-
qsamelength,_,0,_
qsamelength,0,0,_,<,<,-

// Same length
qsamelength,_,_,_
qcompare,_,_,_,>,>,-


// Move back in second tape

qback,0,0,_
qback,0,0,_,<,<,-
qback,0,1,_
qback,0,1,_,<,<,-
qback,1,0,_
qback,1,0,_,<,<,-
qback,1,1,_
qback,1,1,_,<,<,-

qback,_,_,_
qcompare,_,_,_,>,>,-

// Compare numbers
qcompare,1,1,_
qcompare,1,1,_,>,>,-

qcompare,0,0,_
qcompare,0,0,_,>,>,-

qcompare,0,1,_
qless,0,1,_,-,-,-

qcompare,_,_,_
qequal,_,_,_,-,-,-
qcompare,#,_,_
qequal,#,_,_,-,-,-

qcompare,1,0,_
qgreater,1,0,_,-,-,-

qless,0,0,_
qless,0,0,_,>,>,-
qless,1,0,_
qless,1,0,_,>,>,-
qless,0,1,_
qless,0,1,_,>,>,-
qless,1,1,_
qless,1,1,_,>,>,-
qgreater,0,0,_
qgreater,0,0,_,>,>,-
qgreater,1,0,_
qgreater,1,0,_,>,>,-
qgreater,0,1,_
qgreater,0,1,_,>,>,-
qgreater,1,1,_
qgreater,1,1,_,>,>,-
qequal,0,0,_
qequal,0,0,_,>,>,-
qequal,1,0,_
qequal,1,0,_,>,>,-
qequal,0,1,_
qequal,0,1,_,>,>,-
qequal,1,1,_
qequal,1,1,_,>,>,-

// If same or equal, continue checking
qequal,#,_,_
qback2,#,_,_,-,<,-
qgreater,#,_,_
qback2,#,_,_,-,<,-

// If we are at the end, we are done
qequal,_,_,_
qdone,_,_,_,-,-,-
qgreater,_,_,_
qdone,_,_,_,-,-,-

// If less than, swap numbers
qless,#,_,_
qswap,#,_,_,<,<,-
qless,_,_,_
qswap,_,_,_,<,<,-

// Swap numbers
qswap,0,0,_
qswap,0,0,_,<,<,-
qswap,0,1,_
qswap,1,0,_,<,<,-
qswap,1,0,_
qswap,0,1,_,<,<,-
qswap,1,1,_
qswap,1,1,_,<,<,-

qswap,#,_,_
qcompare,#,_,_,>,>,-
qswap,_,_,_
qcompare,_,_,_,>,>,-

// Return second tape to first cell
qback2,#,0,_
qback2,#,0,_,-,<,-
qback2,#,1,_
qback2,#,1,_,-,<,-
qback2,#,_,_
qcompare,#,_,_,>,>,-

// If we are in qdone, we should copy the second tape in the third
qdone,_,_,_
qback22,_,_,_,-,<,-

qback22,_,0,_
qback22,_,0,_,-,<,-
qback22,_,1,_
qback22,_,1,_,-,<,-

qback22,_,_,_
qcopy2to3,_,_,_,-,>,-

// Copy second tape to third
qcopy2to3,_,0,_
qcopy2to3,_,_,0,-,>,>
qcopy2to3,_,1,_
qcopy2to3,_,_,1,-,>,>

// Write # in thir tape and move first tape to start
qcopy2to3,_,_,_
qback1,_,_,#,<,-,>

// Move tape 1 to begining
qback1,0,_,_
qback1,0,_,_,<,-,-
qback1,1,_,_
qback1,1,_,_,<,-,-
qback1,#,_,_
qback1,#,_,_,<,-,-

qback1,_,_,_
q0,_,_,_,>,-,-


// Final steps
q0,_,_,_
qback23,_,_,_,-,<,-
qback23,_,0,_
qback23,_,0,_,-,<,-
qback23,_,1,_
qback22,_,1,_,-,<,-

qback23,_,_,_
qcopy2to32,_,_,_,-,>,-

// Copy second tape to third
qcopy2to32,_,0,_
qcopy2to32,_,_,0,-,>,>
qcopy2to32,_,1,_
qcopy2to32,_,_,1,-,>,>
qcopy2to32,_,_,_
qend,_,_,_,-,-,-
